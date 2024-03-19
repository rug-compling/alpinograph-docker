export LANG=nl_NL.utf8
export LANGUAGE=nl_NL.utf8
export LC_ALL=nl_NL.utf8
export COLUMNS
export LINES
export EDITOR=nano

alias ..='cd ..'
alias beep='echo -e '\''\a\c'\'
alias ll='ls -Fla'
alias rm='rm -i'
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
alias path='echo $PATH | perl -p -e "s/:/\n/g"'

PS1='[docker:'"$(< /etc/issue.net)"'] \u:\w\$ '

umask 002

cd /opt
