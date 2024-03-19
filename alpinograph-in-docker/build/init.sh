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

sudo service apache2 start

cd /var/www/html
for i in corpora.txt menu.xml
do
    if [ ! -f ~/$i ]
    then
        cp -p $i ~
    fi
done
cp ~/corpora.txt ~/menu.xml .
make

if [ ! -d ~/db_cluster ]
then
    mkdir ~/log
    initdb -U user
    ag_ctl -l ~/log/logile start
    createdb -e -O user -U user
else
    ag_ctl -l ~/log/logile start
fi

function cleanexit {
    ag_ctl -m fast stop
    exit
}
trap cleanexit 1 2 3 9 15

alias ag_start='ag_ctl -l ~/log/logfile start'
alias ag_stop='ag_ctl -m fast stop'

cd
