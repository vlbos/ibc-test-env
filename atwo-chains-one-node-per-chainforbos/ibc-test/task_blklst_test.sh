#!/usr/bin/env bash

. env.sh
#. chains_init.sh


# set_contracts(){
#     cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
#     ${!cleos} set contract ${contract_chain} ${CONTRACTS_DIR}/${contract_chain_folder} -x 1000 -p ${contract_chain}
#     sleep .2
#     ${!cleos} set contract ${contract_token} ${CONTRACTS_DIR}/${contract_token_folder} -x 1000 -p ${contract_token}
#     sleep .2
# }
# set_contracts c1
# set_contracts c2

# init_contracts(){
#     cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

#     ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

#     # --- ibc.chain ---
#     ${!cleos}  push action  ${contract_chain} setglobal '[{"lib_depth":170}]' -p ${contract_chain}
#     ${!cleos}  push action  ${contract_chain} relay '["add","ibc2relay555"]' -p ${contract_chain}
#     #cleos get table ${contract_chain} ${contract_chain} global

#     # --- ibc.token ---
#     ${!cleos} push action ${contract_token} setglobal '["ibc2chain555","ibc2token555",5000,1000,10,true]' -p ${contract_token}

# #    ${!cleos} push action ${contract_token} regacpttoken \
# #    '["eosio.token","1000000000.0000 EOS","ibc2token555","1.0000 EOS","100.0000 EOS",
# #    "1000.0000 EOS",100,"org","websit","fixed","0.0100 EOS",0.01,true,"4,EOS"]' -p ${contract_token}
# #
# #
# #    ${!cleos} push action ${contract_token} regpegtoken \
# #    '["1000000000.0000 EOS","1.0000 EOS","100.0000 EOS","1000.0000 EOS",100,
# #    "ibc2token555","eosio.token","4,EOS",true]' -p ${contract_token}

#     #cleos get table ${contract_token} ${contract_token} globals

# }
# init_contracts c1
# init_contracts c2

init_two(){
    $cleos2 push action eosio namelist '{"list":"actor_blacklist","action":"insert","names":[ibc2chain555]}' -p eosio




}
init_two

# return

get_chain_table(){
    echo --- cleos1 ---
    $cleos1 get table ${contract_chain} ${contract_chain} $1
    echo && echo --- cleos2 ---
    $cleos2 get table ${contract_chain} ${contract_chain} $1
}

get_token_table(){
    echo --- cleos1 ---
    $cleos1 get table ${contract_token} ${contract_token} $1
    echo && echo --- cleos2 ---
    $cleos2 get table ${contract_token} ${contract_token} $1
}

#    get_chain_table sections
#    get_chain_table prodsches
#    get_chain_table chaindb
#    get_token_table globals
#    get_token_table globalm
#    get_token_table origtrxs
#    get_token_table cashtrxs


get_balance(){
    $cleos2 get table eosio $1 account
    # $cleos2 get table ibc2token555 $1 accounts
}
get_balance ibc2chain555
#    get_balance chengsong111

get_receiver_b(){
    # $cleos2 get currency balance eosio.token ibc2chain555 "EOS"
    $cleos2 get currency balance eosio.token ibc2chain555 "BOS"
}
get_receiver_b

get_account(){
    # echo --- cleos1 ---
    # $cleos1 get account  $1
    echo && echo --- cleos2 ---
    $cleos2 get account  $1
}
get_account ibc2chain555
# get_account ibc2token555
# get_account ibc2chain555




transfer(){
    echo --- cleos1 transfer ---
    # $cleos2 transfer  ibc2chain555 ibc2token555 "10.0000 EOS"  -p ibc2chain555
    $cleos2 transfer  ibc2chain555 ibc2token555 "10.0000 BOS" "ibc receiver=chengsong111" -p ibc2chain555
}

transfer

withdraw(){
    $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "ibc receiver=receiverbos1"]' -p chengsong111
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "ibc receiver=receivereos1"]' -p chengsong111
}

transfer_fail(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "ibc receiver=chengsong123" -p firstaccount
    $cleos2 transfer -f firstaccount ibc2token555 "10.0000 BOS" "ibc receiver=chengsong123" -p firstaccount
}

withdraw_fail(){
    $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "ibc receiver=receiver1111"]' -p chengsong111
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "ibc receiver=receiver1111"]' -p chengsong111
}


once(){
    for i in `seq 10`; do transfer && sleep .2 ;done
    for i in `seq 10`; do withdraw && sleep .2 ;done
    for i in `seq 2`; do transfer_fail && sleep .2 ;done
    for i in `seq 2`; do transfer_fail && sleep .2 ;done
}




# for i in `seq 10000`; do transfer && withdraw &&          sleep .5 ;done










pressure(){
    for i in `seq 10000`; do transfer && sleep .5 ;done
    for i in `seq 10000`; do withdraw && sleep .5 ;done

     $cleos1 get table ibc2chain555 ibc2chain555 chaindb -L 9000 |less





}

huge_pressure(){

    for i in `seq 200`; do withdraw  ; done >/dev/null 2>&1  &

}

