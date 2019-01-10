

## IBC 测试及使用手册

本文将详细描述如何在 Kylin Testnet plus BOS Testnet 环境中编译、部署、测试IBC系统。


### 编译

nodeos编译
``` bash
# Kylin Testnet 中继全节点
$ git clone https://github.com/cryptokylin/eos 
$ cd eos && git checkout feature/ibc-plugin
# 注释掉 plugins/ibc_plugin/ibc_plugin.cpp 文件中约第39行的 #define PLUGIN_TEST
$ ./eosio_build.sh

# BOS Testnet 中继全节点
$ git clone https://github.com/boscore/bos 
$ cd eos && git checkout feature/ibc-plugin   # 为了结合bos其他功能一起测试，此分支已经合并了master分支的内容
# 注释掉 plugins/ibc_plugin/ibc_plugin.cpp 文件中约第39行的 #define PLUGIN_TEST
$ ./eosio_build.sh
```

合约编译
``` bash
$ git clone https://github.com/bos/bos.contracts
$ cd eosio.contracts && git checkout feature/ibc
$ ./build.sh
```

### 合约部署

在Kylin测试网和BOS测试网各创建两个账号 ibc2chain555, ibc2token555, ibc2relay555
为 ibc2chain555, ibc2token555 购买 RAM 10Mb, CPU 100 EOS/BOS, NET 100 EOS/BOS
为 ibc2relay555 购买 CPU 5000 EOS/BOS, NET 500 EOS/BOS
并在各个测试网的 ibc2chain555 部署ibc.chain 合约， 在 ibc2token555 部署ibc.token合约

### 合约初始化

``` bash

cleos1=cleos -u http://kylin.fn.eosbixin.com
cleos2=cleos -u http://47.254.82.241
contract_chain=ibc2chain555
contract_token=ibc2token555

把两个链的ibc2token555合约设置eosio.code权限
$cleos1 set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}
$cleos2 set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}


$cleos1 push action ${contract_chain} setglobal '[{"lib_depth":170}]' -p ${contract_chain}
$cleos1 push action ${contract_chain} relay '["add","ibc2relay555"]' -p ${contract_chain}
$cleos1 push action ${contract_token} setglobal '["ibc2chain555","ibc2token555",5000,1000,10,true]' -p ${contract_token}
$cleos1 push action ${contract_token} regacpttoken \
    '["eosio.token","1000000000.0000 EOS","ibc2token555","10.0000 EOS","5000.0000 EOS",
    "100000.0000 EOS",1000,"organization-name","www.website.com","fixed","0.1000 EOS",0.01,true,"4,EOSPG"]' -p ${contract_token}
$cleos1 push action ${contract_token} regpegtoken \
    '["1000000000.0000 BOSPG","10.0000 BOSPG","5000.0000 BOSPG",
    "100000.0000 BOSPG",1000,"ibc2token555","eosio.token","4,BOS",true]' -p ${contract_token}


$cleos2 push action ${contract_chain} setglobal '[{"lib_depth":170}]' -p ${contract_chain}
$cleos2 push action ${contract_chain} relay '["add","ibc2relay555"]' -p ${contract_chain}
$cleos2 push action ${contract_token} setglobal '["ibc2chain555","ibc2token555",5000,1000,10,true]' -p ${contract_token}
$cleos2 push action ${contract_token} regacpttoken \
    '["eosio.token","1000000000.0000 BOS","ibc2token555","10.0000 BOS","5000.0000 BOS",
    "100000.0000 BOS",1000,"organization-name","www.website.com","fixed","0.1000 BOS",0.01,true,"4,BOSPG"]' -p ${contract_token}
$cleos2 push action ${contract_token} regpegtoken \
    '["1000000000.0000 EOSPG","10.0000 EOSPG","5000.0000 EOSPG",
    "100000.0000 EOSPG",1000,"ibc2token555","eosio.token","4,EOS",true]' -p ${contract_token}

```

### nodeos配置文件添加ibc_plugin相关配置

kylin 测试网中继全节点配置项
``` 
plugin = eosio::ibc::ibc_plugin
ibc-chain-contract = ibc2chain555
ibc-token-contract = ibc2token555
ibc-relay-name = ibc2relay555
ibc-relay-private-key = EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi=KEY:5K2ezP476ThBo9zSrDqTofzaLiKrQaLEkAzv3USdeaFFrD5LAX1
ibc-listen-endpoint = 0.0.0.0:6001
#ibc-peer-address = 127.0.0.1:6002
ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
```

BOS 测试网中继全节点配置项
``` 
plugin = eosio::ibc::ibc_plugin
ibc-chain-contract = ibc2chain555
ibc-token-contract = ibc2token555
ibc-relay-name = ibc2relay555
ibc-relay-private-key = EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi=KEY:5K2ezP476ThBo9zSrDqTofzaLiKrQaLEkAzv3USdeaFFrD5LAX1
ibc-listen-endpoint = 0.0.0.0:6001
#ibc-peer-address = 127.0.0.1:6002
ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
```

配置好后启动节点，等各方合约都初始化，并完成第一个section之后，可以进行跨链交易

### 执行跨链交易

从 kylin 测试网account1账户，转移50个EOS 到 BOS测试网的account2账户
$cleos1 transfer account1 ibc2token555 "50.0000 EOS" "ibc receiver=account2" -p account1

从 BOS 测试网account2账户，转回15个EOS （实际符号是EOSPG） 到 Kylin测试网的account3账户
$cleos2 push action ibc2token555 transfer '["account2","ibc2token555","10.0000 EOSPG" "ibc receiver=account3"]' -p account2

从 BOS 测试网account1账户，转移50个BOS 到 BOS测试网的account2账户
$cleos2 transfer account1 ibc2token555 "50.0000 BOS" "ibc receiver=account2" -p account1

从 Kylin 测试网account2账户，转回15个BOS （实际符号是BOSPG） 到BOS测试网的account3账户
$cleos1 push action ibc2token555 transfer '["account2","ibc2token555","10.0000 BOSPG" "ibc receiver=account3"]' -p account2






