# vim:ft=zsh ts=2 sw=2 sts=2

rvm_current() {
  rvm current 2>/dev/null
}

rbenv_version() {
  rbenv version 2>/dev/null | awk '{print $1}'
}

# MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
# local return_status="%(?..%{$fg_bold[red]%}%?%{$reset_color%})%{$reset_color%} "

function _exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=''
    EXIT_CODE_PROMPT+="%{$fg[red]%}"
    EXIT_CODE_PROMPT+="%(?..%{$fg_bold[red]%}%?)!%{$reset_color%} "
    echo "$EXIT_CODE_PROMPT"
  fi
}

function _kubectx() {
  kc="$(kubectl config current-context)"
  if [[ $kc =~ production ]]; then
    echo "%{$fg[red]%}${kc} 🐞%{$reset_color%}"
  else
    echo "%{$fg[white]%}${kc} 🌴%{$reset_color%}"
  fi
}

function empty-buffer() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER=""
	PROMPT="$ "
    else
        PROMPT='
$(_exit_code)%{$reset_color%}福 %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_short_sha)$(git_prompt_info) %{$fg_bold[red]%}%*%{$reset_color%}%{$fg[white]%}..$(_kubectx)%{$reset_color%}
$ '
    fi
}
# set special widget, see man zshzle
zle -N zle-line-finish empty-buffer

PROMPT='
$(_exit_code)%{$reset_color%}福 %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_short_sha)$(git_prompt_info) %{$fg_bold[red]%}%*%{$reset_color%}%{$fg[white]%}..$(_kubectx)%{$reset_color%}
$ '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
#
# # Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="➤ %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="|%{$reset_color%}"


if [ -e ~/.rvm/bin/rvm-prompt ]; then
  RPROMPT='%{$fg_bold[red]%}‹$(rvm_current)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    RPROMPT='%{$fg_bold[red]%}$(rbenv_version)%{$reset_color%}'
  fi
fi
