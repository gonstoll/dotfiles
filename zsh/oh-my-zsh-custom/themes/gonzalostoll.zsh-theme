# Color shortcuts
BL=$fg[black]
B=$fg[blue]
C=$fg[cyan]
G=$fg[green]
M=$fg[magenta]
R=$fg[red]
W=$fg[white]
Y=$fg[yellow]
I="\e[3m" # Italics
CI="\e[23m" # Close italics
RC=$reset_color

ZSH_THEME_GIT_PROMPT_PREFIX="%{$B%}branch:{%{$Y%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$RC%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$B%}} 🧹 "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$B%}} 🤌 "

ZSH_THEME_SVN_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_SVN_PROMPT_SUFFIX="$ZSH_THEME_GIT_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

ZSH_THEME_HG_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_HG_PROMPT_SUFFIX="$ZSH_THEME_GIT_PROMPT_SUFFIX"
ZSH_THEME_HG_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_HG_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

vcs_status() {
  if (( ${+functions[in_svn]} )) && in_svn; then
    svn_prompt_info
  elif (( ${+functions[in_hg]} )) && in_hg; then
    hg_prompt_info
  else
    git_prompt_info
  fi
}

PROMPT="%{$M%}%~ "
PROMPT+='$(vcs_status)%{$W%}'
