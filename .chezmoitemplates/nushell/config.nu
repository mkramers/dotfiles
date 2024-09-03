# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.show_banner = false

use std/util "path add"
path add "~/.local/bin"
path add "~/.local/share/aquaproj-aqua/bin"

# macos only
path add "/Applications/Sublime Text.app/Contents/SharedSupport/bin"

# do this after paths are setup so we can resolve micro
$env.config.buffer_editor = if (which micro | is-empty) { "nano" } else { "micro" }
$env.EDITOR = $env.config.buffer_editor
$env.SHELL = 'nu'

alias ll = ls -la
alias nano = micro
alias cat = bat
alias s = kitten ssh
alias y = yazi

# aws-vault + 1Password auth
def awsv [account_name: string] {
  aws-vault exec --duration 12h -t (op item get $"aws-($account_name)" --otp) $account_name -- nu
}

# hack for fnm in nu
use ./modules/fnm.nu
