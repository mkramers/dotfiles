#!/usr/bin/env bash
set -euo pipefail

# Codex owns ~/.codex/config.toml: it rewrites the file whenever a server is
# added or a login lands, so chezmoi cannot manage it as a template. That is not
# theoretical. The Mac's playwright entry disappeared between two audits, and the
# callback pin below has to survive the same rewrites on every machine.
#
# The two keys exist because Slack registered exactly http://localhost:3118/callback
# against the client the Claude slack plugin ships. Codex otherwise offers an
# ephemeral port and a 127.0.0.1 host, and Slack refuses both. Pinning the port
# alone is not enough; the URL decides the hostname string.
#
# Both must sit above the first [table] header. Below one, TOML reads them as that
# table's keys and Codex ignores them without a word.
#
# No associative arrays here: macOS still ships bash 3.2.

config="$HOME/.codex/config.toml"
[[ -f $config ]] || exit 0

changed=0

ensure_key() {
    key="$1"
    value="$2"
    line="$key = $value"

    current=$(awk -v k="$key" '
        /^[[:space:]]*\[/ { exit }
        $1 == k { sub(/^[^=]*=[[:space:]]*/, ""); print; exit }
    ' "$config")

    [[ $current == "$value" ]] && return 0

    tmp=$(mktemp)
    if [[ -n $current ]]; then
        # Present with the wrong value. The Thinkpad sat on port 8432 for weeks,
        # which no Slack app has registered, so a wrong value here is a breakage
        # rather than a preference worth keeping.
        awk -v k="$key" -v repl="$line" '
            !done && /^[[:space:]]*\[/ { done = 1 }
            !done && $1 == k { print repl; next }
            { print }
        ' "$config" > "$tmp"
        echo "codex: corrected $key (was $current)"
    else
        awk -v repl="$line" '
            !done && /^[[:space:]]*\[/ { print repl; print ""; done = 1 }
            { print }
            END { if (!done) print repl }
        ' "$config" > "$tmp"
        echo "codex: set $key"
    fi
    cat "$tmp" > "$config"
    rm -f "$tmp"
    changed=1
}

# An absent server block is restored, a present one is left exactly as it is: the
# file is where a login or a hand-tuned timeout lands, and this script has no way
# to tell a deliberate edit from drift. Absence is the only unambiguous signal,
# and it is the one that actually bit: codex dropped the Mac's playwright entry
# on its own. That also propagates, because sandy seeds each sandbox by mirroring
# these blocks from the host.
ensure_server() {
    name="$1"
    block="$2"

    grep -q "^\[mcp_servers\.$name\]" "$config" && return 0

    printf '\n%s\n' "$block" >> "$config"
    echo "codex: restored [mcp_servers.$name]"
    changed=1
}

ensure_key mcp_oauth_callback_port '3118'
ensure_key mcp_oauth_callback_url '"http://localhost:3118/callback"'

# Slack's client id is the one the Claude slack plugin ships, not a self-created
# app; it is what the pinned callback above is registered against.
ensure_server slack '[mcp_servers.slack]
url = "https://mcp.slack.com/mcp"
oauth.client_id = "1601185624273.8899143856786"'

ensure_server linear-server '[mcp_servers.linear-server]
url = "https://mcp.linear.app/mcp"'

ensure_server playwright '[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@0.0.80"]'

# env_vars forwards the name from the launching shell. The [.env] table instead
# sets a literal, and codex never expands ${VAR} there, so that form silently
# hands the server the string rather than the key.
ensure_server doit_mcp_server '[mcp_servers.doit_mcp_server]
command = "npx"
args = ["-y", "@doitintl/doit-mcp-server@1.6.0"]
env_vars = ["DOIT_API_KEY"]'

if (( changed )); then
    echo "codex: run 'codex mcp login slack' if Slack reads Not logged in"
fi
