. /env.sh

groupadd --gid $USER user
useradd --no-create-home --uid $USER --gid $GROUP user --password PKz1s.HfgMeIU --groups sudo
find /var/www/html | xargs chown user:user

service apache2 start

if [ ! -d /home/user/db_cluster ]
then
    sudo -u user mkdir -p /home/user/log
    echo user > /pw
    sudo -u user -E /my/opt/agensgraph/bin/initdb -A md5 --locale=nl_NL.UTF-8 -U user --pwfile=/pw
    rm /pw
    sudo -u user -E /my/opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start
    sudo -u user -E /my/opt/agensgraph/bin/createdb -e -O user -U user
    echo "CREATE ROLE guest WITH LOGIN PASSWORD 'guest';" > /guest
    sudo -u user -E /my/opt/agensgraph/bin/agens -f /guest -U user -a
    rm /guest
else
    sudo -u user -E /my/opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start
fi

echo
echo
sudo -u user bash --rcfile /user.sh
echo
echo
sudo -u user -E /my/opt/agensgraph/bin/ag_ctl -m fast stop
echo
echo
exit
