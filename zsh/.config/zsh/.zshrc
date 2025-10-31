# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Options
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
unsetopt NOMATCH				 # No annoying "Sorry this command is not found"
setopt INTERACTIVE_COMMENTS
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
setopt EXTENDED_GLOB
setopt GLOB_DOTS

stty -ixon <$TTY >$TTY           # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')     # Extremely annoying highlight when pasting.

# Colors
autoload -Uz colors && colors
eval $(dircolors)

# History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=$XDG_CACHE_HOME/.zhistory
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt APPEND_HISTORY            # Append history to history file.
setopt INC_APPEND_HISTORY_TIME   # Write to history file upon command completion.

# Basic auto/tab complete:
fpath=($HOME/.zsh/completions $fpath)
zmodload zsh/complist
autoload -Uz compinit ; compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump
_comp_options+=(globdots)        # Include hidden files.
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/.zcompcache"
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Bash completions
autoload -U +X bashcompinit && bashcompinit

# fzf
if [ -f /usr/share/fzf/completion.zsh ] ; then . /usr/share/fzf/completion.zsh ; fi
if [ -f /usr/share/fzf/key-bindings.zsh ] ; then . /usr/share/fzf/key-bindings.zsh ; fi

# uv fix
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# Vim mode
bindkey -v
export KEYTIMEOUT=1
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
bindkey "^?" backward-delete-char           # Fix Backspace key in insert mode

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
        for c in {a,i}{\',\",\`}; do
                bindkey -M $m $c select-quoted
        done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
        for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
                bindkey -M $m $c select-bracketed
        done
done

# Source important files
source $XDG_CONFIG_HOME/shell/aliases
source $XDG_CONFIG_HOME/shell/functions

# Prompt
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
eval "$(starship init zsh)"
# Remove that one pesky newline
precmd() {
    precmd() {
        echo
    }
}
alias clear="precmd() { precmd() { echo } } && clear"

# Zoxide
if command -v zoxide 1>/dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
