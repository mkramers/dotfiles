# ----------------------------------------------------
# ----- path -----------------------------------------
# ----------------------------------------------------

use std/util "path add"
{{- range .shell.paths }}
{{-   if or (not (hasKey . "os")) (eq .os $.chezmoi.os) }}
{{-     if and (hasKey . "relative") .relative }}
path add ($env.HOME | path join "{{ .path }}")
{{-     else }}
path add "{{ .path }}"
{{-     end }}
{{-   end }}
{{- end }}

# ----------------------------------------------------
# ----- env -----------------------------------------
# ----------------------------------------------------

$env.config.show_banner = false
$env.config.buffer_editor = if (which micro | is-empty) { "nano" } else { "micro" }
$env.SHELL = $env.HOME | path join ".local/bin/nu"

{{ range $name, $val := .shell.env -}}
{{-   if kindIs "map" $val }}
$env.{{ $name }} = if (which {{ $val.check }} | is-empty) { "{{ $val.fallback }}" } else { "{{ $val.value }}" }
{{-   else if hasPrefix "." $val }}
$env.{{ $name }} = $env.HOME | path join "{{ $val }}"
{{-   else }}
$env.{{ $name }} = "{{ $val }}"
{{-   end }}
{{ end }}

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

{{ range $name, $func := .shell.functions -}}
# {{ $func.description }}
def {{ $name }} [] {
  {{ $func.nu }}
}

{{ end }}

# ----------------------------------------------------
# ----- alias -----------------------------------------
# ----------------------------------------------------

{{ range $name, $cmd := .shell.aliases -}}
alias {{ $name }} = {{ $cmd }}
{{ end }}

# allows us to edit the config.nu chezmoi source file instead of the real one
alias confignu = nano (chezmoi source-path | decode utf-8 | str trim | path join ".chezmoitemplates/nushell/config.nu")

# ----------------------------------------------------
# ----- mise (tool version manager) -------------------
# ----------------------------------------------------

$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join ".local/share/mise/shims"))
