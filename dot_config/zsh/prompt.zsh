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

    # Directory + Git section
    local dir_display git_info=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo_root repo_name rel_path branch dirty
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name=${repo_root:t}
        rel_path=${PWD#$repo_root}
        rel_path=${rel_path#/}

        # Branch name
        branch=$(git branch --show-current 2>/dev/null)
        [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

        # Worktree detection
        local is_worktree=false
        local git_dir=$(git rev-parse --git-dir 2>/dev/null)
        [[ "$git_dir" == *"/worktrees/"* ]] && is_worktree=true

        local worktree_icon=""
        if [[ "$is_worktree" == true ]]; then
            worktree_icon=$'\uf1bb'" "
            # Condense <repo>.<branch> → <repo> when branch matches
            if [[ "$repo_name" == *".${branch}" ]]; then
                repo_name=${repo_name%.${branch}}
            fi
        fi

        if [[ -n "$rel_path" ]]; then
            dir_display=" ${worktree_icon}${repo_name}/${rel_path}"
        else
            dir_display=" ${worktree_icon}${repo_name}"
        fi

        # Dirty check (staged, modified, or untracked)
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            dirty=" *"
        fi

        # Ahead/behind upstream
        local counts
        counts=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
        if [[ -n "$counts" ]]; then
            local ahead=${counts%%$'\t'*}
            local behind=${counts##*$'\t'}
            [[ "$ahead" -gt 0 ]] && git_info+=" %F{${_prompt_red}}⇡${ahead}%f"
            [[ "$behind" -gt 0 ]] && git_info+=" %F{${_prompt_red}}⇣${behind}%f"
        fi

        git_info=" %F{${_prompt_pink}}"$'\ue0a0'" ${branch}%f%F{${_prompt_red}}${dirty}%f${git_info}"
    else
        dir_display=" ${PWD/#$HOME/~}"
    fi

    # AWS section (aws-vault sets AWS_VAULT, not AWS_PROFILE)
    local aws_info=""
    if [[ -n "$AWS_VAULT" ]]; then
        aws_info=" %F{${_prompt_orange}}"$'\uf270'" ${AWS_VAULT}%f"
    fi

    # Character color based on last exit code
    local char_color
    if [[ $exit_code -eq 0 ]]; then
        char_color=$_prompt_purple
    else
        char_color=$_prompt_red
    fi

    # SSH indicator
    local ssh_info=""
    if [[ -n "$SSH_CONNECTION" ]]; then
        ssh_info="%F{${_prompt_orange}}[$(hostname)]%f"
    fi

    # Build prompt
    PROMPT="${ssh_info}%F{${_prompt_purple}}${dir_display}%f${git_info}${aws_info} %F{${char_color}}❯%f "
}

# Register precmd hook
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
