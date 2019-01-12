#!/bin/bash

. init.sh
. config.sh

cluster_init(){
    cluster_clear

    cName=config.ini
    lName=logging.json
    gName=genesis.json

    # prepare genesis time
    times1=`cat ../chain-first/genesis_time.txt`
    times2=`cat ../chain-second/genesis_time.txt`

    for i in 1 2; do
        path=staging/etc/eosio/node${i}
        mkdir -p $path
        r=confignode$i && echo "${!r}"  > $path/$cName
        echo "$config_common" >>  $path/$cName
        echo "$logging_v"     > $path/$lName
        echo "$genesis"     > $path/$gName

        time_n=times$i
        sed 's/"initial_timestamp": ".*/"initial_timestamp": "'${!time_n}'",/g' $path/$gName >  $path/${gName}_tmp
        rm $path/$gName
        mv $path/${gName}_tmp $path/$gName
    done
}


cluster_start(){

    echo "starting node 1"
    node1data=var/lib/node1/
    node1conf=staging/etc/eosio/node1
    genesis=staging/etc/eosio/node1/genesis.json

    gen=""
    if [ "$1" == "gen" ];then
        gen="--genesis-json $genesis"
    fi

    echo $gen

    nohup ./programs/nodeos/nodeos -d $node1data --config-dir $node1conf  \
        --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin  \
        --contracts-console  --max-transaction-time 1000 $gen > node1.log &


    echo "starting node 2"
    node2data=var/lib/node2/
    node2conf=staging/etc/eosio/node2
    genesis=staging/etc/eosio/node2/genesis.json

    gen=""
    if [ "$1" == "gen" ];then
        gen="--genesis-json $genesis"
    fi

    nohup ./programs/nodeos/nodeos -d $node2data --config-dir $node2conf  \
        --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin  \
        --contracts-console  --max-transaction-time 1000 $gen > node2.log &

    echo "tail -f node1.log"
}


cluster_clear(){
    rm *.json *.dot *.ini *.log topology* 2>/dev/null
    rm -rf staging
    rm -rf etc/eosio/node_*
    rm -rf var/lib

    cd ./../ibc-test/ && ./clear.sh 2>/dev/null && cd - >/dev/null
}


if [ "$#" -ne 1 ];then
	echo "usage: cluster.sh init|start-gen|start|clear"
	exit 0
fi


case "$1"
in
    "init"  )       cluster_init;;
    "start-gen" )    cluster_start gen;;
    "start" )       cluster_start;;
    "clear" )       cluster_clear;;
    *) echo "usage: cluster.sh init|start-gen|start|clear" ;;
esac


