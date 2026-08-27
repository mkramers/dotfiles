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

    # Directory + Git section.
    #
    # Every git fork costs ~10ms on an NFS home, so this section is written to use as
    # few as possible: one rev-parse for all the path info, HEAD read straight off disk
    # for the branch, and -uno on the dirty check so git doesn't walk the whole
    # worktree hunting untracked files. That took a prompt render on the uofc login
    # node from 724ms to roughly 30ms.
    local dir_display git_info=""
    local -a git_facts
    git_facts=("${(@f)$(git rev-parse --is-inside-work-tree --path-format=absolute \
                            --show-toplevel --git-dir --git-common-dir 2>/dev/null)}")
    if [[ $git_facts[1] == true ]]; then
        local repo_root=$git_facts[2] git_dir=$git_facts[3]
        local worktree_name rel_path branch dirty
        worktree_name=${repo_root:t}
        rel_path=${PWD#$repo_root}
        rel_path=${rel_path#/}

        # Branch from HEAD directly. A file read beats another fork, and this handles
        # detached HEAD (raw sha) and commit-less repos, which rev-parse chokes on.
        local head_ref
        if read -r head_ref <$git_dir/HEAD 2>/dev/null; then
            if [[ $head_ref == ref:* ]]; then
                branch=${head_ref#ref: refs/heads/}
            else
                branch=${head_ref[1,7]}
            fi
        fi

        # Primary repo name (always the actual repo, even from inside a worktree)
        local primary_root primary_name
        primary_root=${git_facts[4]%/.git}
        primary_name=${primary_root:t}

        # Worktree detection
        local is_worktree=false
        [[ "$git_dir" == *"/worktrees/"* ]] && is_worktree=true

        local worktree_icon=""
        local display_name="$primary_name"
        if [[ "$is_worktree" == true ]]; then
            worktree_icon=$''" "
            # Only show the worktree dir name if it differs from the branch
            if [[ "$worktree_name" != "$branch" ]]; then
                display_name="${primary_name}/${worktree_name}"
            fi
        fi

        # Bold the repo segment to highlight which repo we're in
        display_name="%B${display_name}%b"

        if [[ -n "$rel_path" ]]; then
            dir_display=" ${worktree_icon}${display_name}/${rel_path}"
        else
            dir_display=" ${worktree_icon}${display_name}"
        fi

        # Dirty check (staged or modified; untracked files are skipped, see above)
        if [[ -n $(git status --porcelain -uno 2>/dev/null) ]]; then
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

        git_info=" %F{${_prompt_pink}}"$''" ${branch}%f%F{${_prompt_red}}${dirty}%f${git_info}"
    else
        dir_display=" ${PWD/#$HOME/~}"
    fi

    # AWS section (aws-vault sets AWS_VAULT, not AWS_PROFILE)
    local aws_info=""
    if [[ -n "$AWS_VAULT" ]]; then
        aws_info=" %F{${_prompt_orange}}"$''" ${AWS_VAULT}%f"
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
        ssh_info="%F{${_prompt_orange}}[${HOST}]%f"
    fi

    # Build prompt
    PROMPT="${ssh_info}%F{${_prompt_purple}}${dir_display}%f${git_info}${aws_info} %F{${char_color}}❯%f "
}

# Register precmd hook
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
