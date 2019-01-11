#!/usr/bin/env bash

read -d '' genesis << EOF
{
  "initial_timestamp": "2019-01-11T09:37:15.000",
  "initial_key": "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
  "initial_configuration": {
    "max_block_net_usage": 1048576,
    "target_block_net_usage_pct": 1000,
    "max_transaction_net_usage": 524288,
    "base_per_transaction_net_usage": 12,
    "net_usage_leeway": 500,
    "context_free_discount_net_usage_num": 20,
    "context_free_discount_net_usage_den": 100,
    "max_block_cpu_usage": 200000,
    "target_block_cpu_usage_pct": 1000,
    "max_transaction_cpu_usage": 150000,
    "min_transaction_cpu_usage": 100,
    "max_transaction_lifetime": 3600,
    "deferred_trx_expiration_window": 600,
    "max_transaction_delay": 3888000,
    "max_inline_action_size": 4096,
    "max_inline_action_depth": 4,
    "max_authority_depth": 6
    }
}
EOF


read -d '' config_common << EOF
plugin = eosio::chain_api_plugin
plugin = eosio::net_plugin
plugin = eosio::history_api_plugin
p2p-max-nodes-per-host = 50
max-clients = 25

plugin = eosio::ibc::ibc_plugin
ibc-chain-contract = ibc2chain555
ibc-token-contract = ibc2token555
ibc-relay-name = ibc2relay555
ibc-relay-private-key = EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi=KEY:5K2ezP476ThBo9zSrDqTofzaLiKrQaLEkAzv3USdeaFFrD5LAX1
EOF


read -d '' confignode1 << EOF
http-server-address = 127.0.0.1:18888
p2p-peer-address = localhost:9801
p2p-peer-address = localhost:9802
p2p-peer-address = localhost:9803
p2p-peer-address = localhost:9804
p2p-listen-endpoint = 0.0.0.0:19770

ibc-listen-endpoint = 0.0.0.0:6001
#ibc-peer-address = 127.0.0.1:6002

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF


read -d '' confignode2 << EOF
http-server-address = 127.0.0.1:18889
p2p-peer-address = localhost:9901
p2p-peer-address = localhost:9902
p2p-peer-address = localhost:9903
p2p-peer-address = localhost:9904
p2p-listen-endpoint = 0.0.0.0:19771


#ibc-listen-endpoint = 0.0.0.0:6002
ibc-peer-address = 127.0.0.1:6001

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF



read -d '' logging << EOF
{
  "includes": [],
  "appenders": [{
      "name": "stderr",
      "type": "console",
      "args": {
        "stream": "std_error",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    },{
      "name": "stdout",
      "type": "console",
      "args": {
        "stream": "std_out",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    }
  ],
  "loggers": [{
      "name": "default",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    }
  ]
}
EOF




read -d '' logging_v << EOF
{
  "includes": [],
  "appenders": [{
      "name": "stderr",
      "type": "console",
      "args": {
        "stream": "std_error",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    },{
      "name": "stdout",
      "type": "console",
      "args": {
        "stream": "std_out",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    }
  ],
  "loggers": [{
      "name": "default",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    },
    {
      "name": "ibc_plugin_impl",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    }
  ]
}
EOF

