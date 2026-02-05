# Pure ZSH prompt - no external dependencies
# Works in all terminals including Sublime Text Terminus

setopt PROMPT_SUBST

# Colors (256-color palette)
typeset -g _prompt_purple=141
typeset -g _prompt_pink=212
typeset -g _prompt_red=203
typeset -g _prompt_orange=215

# Gather prompt info before each prompt
_prompt_precmd() {
    local exit_code=$?

    # Directory section
    local dir_display
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo_root repo_name rel_path
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name=${repo_root:t}
        rel_path=${PWD#$repo_root}
        rel_path=${rel_path#/}
        if [[ -n "$rel_path" ]]; then
            dir_display=" ${repo_name}/${rel_path}"
        else
            dir_display=" ${repo_name}"
        fi
    else
        dir_display=${PWD/#$HOME/\~}
    fi

    # Git section (only inside git repos)
    local git_info=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch dirty ahead behind

        # Branch name
        branch=$(git branch --show-current 2>/dev/null)
        [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

        # Dirty check (staged, modified, or untracked)
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            dirty=" *"
        fi

        # Ahead/behind upstream
        local counts
        counts=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
        if [[ -n "$counts" ]]; then
            ahead=${counts%%$'\t'*}
            behind=${counts##*$'\t'}
            [[ "$ahead" -gt 0 ]] && git_info+=" %F{${_prompt_red}}⇡${ahead}%f"
            [[ "$behind" -gt 0 ]] && git_info+=" %F{${_prompt_red}}⇣${behind}%f"
        fi

        git_info=" %F{${_prompt_pink}} ${branch}%f%F{${_prompt_red}}${dirty}%f${git_info}"
    fi

    # AWS section
    local aws_info=""
    if [[ -n "$AWS_PROFILE" ]]; then
        aws_info=" %F{${_prompt_orange}} ${AWS_PROFILE}%f"
    fi

    # Character color based on last exit code
    local char_color
    if [[ $exit_code -eq 0 ]]; then
        char_color=$_prompt_purple
    else
        char_color=$_prompt_red
    fi

    # Build prompt
    PROMPT="%F{${_prompt_purple}}${dir_display}%f${git_info}${aws_info} %F{${char_color}}❯%f "
}

# Register precmd hook
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
