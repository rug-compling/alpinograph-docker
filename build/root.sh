. /env.sh

groupadd --gid $USER user
useradd --no-create-home --uid $USER --gid $GROUP user --password PKz1s.HfgMeIU --groups sudo
find /var/www/html | xargs chown user:user

service apache2 start &> /dev/null

if [ ! -d /home/user/db_cluster ]
then
    sudo -u user mkdir -p /home/user/log
    sudo -u user -E /my/opt/agensgraph-new/bin/initdb -U user
    sudo -u user -E /my/opt/agensgraph-new/bin/ag_ctl -l /home/user/log/logile start
    sudo -u user -E /my/opt/agensgraph-new/bin/createdb -e -O user -U user
else
    sudo -u user -E /my/opt/agensgraph-new/bin/ag_ctl -l /home/user/log/logile start
fi

echo
echo
sudo -u user bash --rcfile /user.sh
echo
echo
sudo -u user -E /my/opt/agensgraph-new/bin/ag_ctl -m fast stop
echo
echo
exit
