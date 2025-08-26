# ----------------------------------------------------
# ----- path -----------------------------------------
# ----------------------------------------------------

use std/util "path add"
path add "/usr/local/bin"
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".local/share/aquaproj-aqua/bin")
{{- if eq .chezmoi.os "darwin" }}
#macos - allows subl command
path add "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
{{- end }}

# ----------------------------------------------------
# ----- env -----------------------------------------
# ----------------------------------------------------

# enable usage of a custom aqua registry - do early to ensure aqua works
$env.AQUA_POLICY_CONFIG = $env.HOME | path join ".aqua/aqua-policy.yaml"

$env.config.show_banner = false
$env.config.buffer_editor = if (which micro | is-empty) { "nano" } else { "micro" }
$env.EDITOR = $env.config.buffer_editor
$env.SHELL = 'nu'

# ----------------------------------------------------
# ----- alias -----------------------------------------
# ----------------------------------------------------

alias ll = ls -la
alias nano = micro
alias cat = bat
alias s = kitten ssh
alias y = yazi
alias tre = tre -a
alias lzg = lazygit
alias pipenv = uv run --no-project --with pipenv pipenv
alias cdg = cd (git rev-parse --show-toplevel)

# allows us to edit the config.nu chezmoi source file instead of the real one
alias confignu = nano (chezmoi source-path | decode utf-8 | str trim | path join ".chezmoitemplates/nushell/config.nu")

# ----------------------------------------------------
# ----- funcs -----------------------------------------
# ----------------------------------------------------

# aws-vault + 1Password OTP
def awsv [account_name: string] {
  aws-vault exec --duration 12h -t (op item get $"aws-($account_name)" --otp) $account_name -- nu
}

# aws-vault exec + 1Password OTP
def awsve [
  account_name: string,
  ...rest
] {
  aws-vault exec --duration 12h -t (op item get $"aws-($account_name)" --otp) $account_name -- ...$rest
}

def paws [] {
  $env | transpose key value | where key =~ "AWS" | format pattern '{key}={value}' | to text
}

# ----------------------------------------------------
# ----- apps -----------------------------------------
# ----------------------------------------------------
# partially broken - enables better fnm integration 
use ./modules/fnm.nu
