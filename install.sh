#!/bin/bash
# get current directory
CURR_DIR=$(pwd)
# get script dir
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $SCRIPT_DIR
# install coc-neco
cd ./neoclide/start/coc-neco && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install rust-analyzer
cd ./fannheyward/start/coc-rust-analyzer && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install tsserver
cd ./neoclide/start/coc-tsserver && yarn install --frozen-lockfile && cd $SCRIPT_DIR

