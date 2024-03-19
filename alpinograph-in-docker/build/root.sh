. /env.sh

if [ "$USER" = "0" ]
then
    AGUSER=agensgraph
    HOME=/home/user
else
    AGUSER=user
    groupadd --gid $USER user
    useradd --no-create-home --uid $USER --gid $GROUP user --password PKz1s.HfgMeIU --groups sudo
    find /var/www/html | xargs chown user:user
fi

service apache2 start

if [ ! -d /home/user/db_cluster ]
then
    mkdir /ttt
    chmod --reference /home/user /ttt
    chmod 777 /home/user
    sudo -u $AGUSER mkdir -p /home/user/log
    echo user > /pw
    sudo -u $AGUSER -E /opt/agensgraph/bin/initdb -A md5 --locale=nl_NL.UTF-8 -U user --pwfile=/pw
    rm /pw
    sudo -u $AGUSER -E /opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start
    sudo -u $AGUSER -E /opt/agensgraph/bin/createdb -e -O user -U user user
    chmod --reference /ttt /home/user
    rmdir /ttt
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

    mkdir /ttt
    chmod --reference /home/user /ttt
    chmod 777 /home/user

    # Index op primary moet weg
    sudo -u $AGUSER -E /opt/agensgraph-2.1.0/bin/ag_ctl -l /home/user/log/agensgraph.log start
    corpora=`echo '\dn' | sudo -u $AGUSER -E /opt/agensgraph-2.1.0/bin/agens --quiet | perl -n -e 'if (/(\S+)\s+\|\s+(user)/ ) { if ($1 ne 'public') { print("$1\n") } }'`
    for corpus in $corpora
    do
        echo "set graph_path = '$corpus'; drop property index rel_primary_idx;" | sudo -u $AGUSER -E /opt/agensgraph-2.1.0/bin/agens
    done
    sudo -u $AGUSER -E /opt/agensgraph-2.1.0/bin/ag_ctl -m smart stop

    cd /home/user
    sudo -u $AGUSER -E mv /home/user/db_cluster /home/user/db_cluster_old
    echo user > /pw
    sudo -u $AGUSER -E /opt/agensgraph/bin/initdb -A md5 --locale=nl_NL.UTF-8 -U user --pwfile=/pw
    rm /pw
    sudo -u $AGUSER -E /opt/agensgraph/bin/pg_upgrade -r -d /home/user/db_cluster_old -D /home/user/db_cluster -b /opt/agensgraph-2.1.0/bin -B /opt/agensgraph-2.13.1/bin
    sudo -u $AGUSER -E /opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start

    # Index op primary herstellen
    for corpus in $corpora
    do
        echo "set graph_path = '$corpus'; create property index on rel(\"primary\");" | sudo -u $AGUSER -E /opt/agensgraph/bin/agens
    done
    unset corpora

    chmod --reference /ttt /home/user
    rmdir /ttt
else
    sudo -u $AGUSER -E /opt/agensgraph/bin/ag_ctl -l /home/user/log/agensgraph.log start
fi

echo
echo
if [ "$USER" = "0" ]
then
    bash --rcfile /user.sh
else
    sudo -u user bash --rcfile /user.sh
fi
echo
echo
sudo -u $AGUSER -E /opt/agensgraph/bin/ag_ctl -m fast stop
echo
echo
exit
