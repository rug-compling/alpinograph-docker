. /env.sh

alias ..='cd ..'
alias beep='echo -e '\''\a\c'\'
alias ll='ls -Fla'
alias rm='rm -i'
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'

PS1='[docker:AlpinoGraph] \u:\w\$ '

export COLUMNS
export LINES
export EDITOR=nano

umask 002

alias ag_start='ag_ctl -l ~/log/agensgraph.log start'
alias ag_stop='ag_ctl -m fast stop'
alias update='cp -u ~/corpora.txt ~/menu.xml /var/www/html; make -C /var/www/html'

cd /var/www/html
cp -u corpora.txt menu.xml ~
cp -u ~/corpora.txt ~/menu.xml .
make

echo
echo
echo Editor: $EDITOR
echo
echo

cd
