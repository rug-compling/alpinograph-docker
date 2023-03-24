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
elif [ "$(< /home/user/db_cluster/PG_VERSION)" = 10 ]
then
    echo
    echo "Upgrade ~/db_cluster nodig"
    echo
    if [ -d /home/user/db_cluster_old ]
    then
	echo FOUT: /home/user/db_cluster_old bestaat al
	exit
    fi

    # Index op primary moet weg
    sudo -u user -E /my/opt/agensgraph-2.1.0/bin/ag_ctl -l /home/user/log/agensgraph.log start
    corpora=`echo '\dn' | sudo -u user -E /my/opt/agensgraph-2.1.0/bin/agens --quiet | perl -n -e 'if (/(\S+)\s+\|\s+(user)/ ) { if ($1 ne 'public') { print("$1\n") } }'`
    for corpus in $corpora
    do
	echo "set graph_path = '$corpus'; drop property index rel_primary_idx;" | sudo -u user -E /my/opt/agensgraph-2.1.0/bin/agens
    done
    sudo -u user -E /my/opt/agensgraph-2.1.0/bin/ag_ctl -m smart stop

    cd /home/user
    sudo -u user -E mv /home/user/db_cluster /home/user/db_cluster_old
    echo user > /pw
    sudo -u user -E /my/opt/agensgraph/bin/initdb -A md5 --locale=nl_NL.UTF-8 -U user --pwfile=/pw
    rm /pw
    sudo -u user -E /my/opt/agensgraph/bin/pg_upgrade -r -d /home/user/db_cluster_old -D /home/user/db_cluster -b /my/opt/agensgraph-2.1.0/bin -B /my/opt/agensgraph-2.13.1/bin
    sudo -u user -E /my/opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start

    # Index op primary herstellen
    for corpus in $corpora
    do
        echo "set graph_path = '$corpus'; create property index on rel(\"primary\");" | sudo -u user -E /my/opt/agensgraph/bin/agens
    done
    unset corpora

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
