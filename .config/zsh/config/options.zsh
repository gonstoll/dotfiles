setopt correct
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nobeep
setopt appendhistory
setopt inc_append_history
setopt histignorealldups
setopt autocd
setopt histignorespace
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
# set -o vi

# "If a completion is performed with the cursor within a word, and a
# full completion is inserted, the cursor is moved to the end of the
# word."
# https://zsh.sourceforge.io/Doc/Release/Options.html#Completion-4
setopt always_to_end

# "If the internal history needs to be trimmed to add the current
# command line, setting this option will cause the oldest history
# event that has a duplicate to be lost before losing a unique event
# from the list."
# https://zsh.sourceforge.io/Doc/Release/Options.html#History
setopt hist_expire_dups_first

# "When searching for history entries in the line editor, do not
# display duplicates of a line previously found, even if the
# duplicates are not contiguous."
# https://zsh.sourceforge.io/Doc/Release/Options.html#History
setopt hist_find_no_dups

# "Turns on interactive comments; comments begin with a #."
# https://zsh.sourceforge.io/Intro/intro_16.html
#
# That is, enable comments in the terminal. Nice when copying and
# pasting from documentation/tutorials, and disable part of
# a command pulled up from history.
setopt interactivecomments
