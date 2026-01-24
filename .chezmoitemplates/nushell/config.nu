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
$env.SHELL = $env.HOME | path join ".local/bin/nu"

# cli
$env.FZF_DEFAULT_COMMAND = "fd --type file --color=always"
$env.FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
$env.GIT_PAGER = "delta"

# ----------------------------------------------------
# ----- funcs -----------------------------------------
# ----------------------------------------------------

# forces devpod to use zsh internally to avoid parsing errors
# NOTE: nushell-only, no need to sync to zsh
def --wrapped devpod [...rest] {
	with-env { SHELL: 'zsh' } {
		^devpod ...$rest
	}
}

def paws [] {
  $env | transpose key value | where key =~ "AWS" | format pattern '{key}={value}' | to text
}

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
alias cdg = cd (git rev-parse --show-toplevel)
alias k9s-kflow = aws-vault exec admin-kflow -- k9s


# allows us to edit the config.nu chezmoi source file instead of the real one
alias confignu = nano (chezmoi source-path | decode utf-8 | str trim | path join ".chezmoitemplates/nushell/config.nu")

# ----------------------------------------------------
# ----- apps -----------------------------------------
# ----------------------------------------------------
# partially broken - enables better fnm integration 
use ./modules/fnm.nu
