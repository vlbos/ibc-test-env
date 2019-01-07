本文将详细描述如何在 Kylin Testnet plus BOS Testnet 环境中编译、部署、测试IBC系统。

nodeos编译
``` 
Kylin Testnet 中继全节点
$ git clone https://github.com/cryptokylin/eos 
$ cd eos && git checkout feature/ibc-plugin
$ ./eosio_build.sh

BOS Testnet 中继全节点
$ git clone https://github.com/boscore/bos 
$ cd eos && git checkout feature/ibc-plugin
$ ./eosio_build.sh
```

合约编译
``` 
$ git clone https://github.com/vonhenry/eosio.contracts
$ cd eosio.contracts && git checkout feature/ibc
$ ./build.sh
```

