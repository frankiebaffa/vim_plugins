#!/bin/bash
# get current directory
CURR_DIR=$(pwd)
# get script dir
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $SCRIPT_DIR
# install coc-neco
cd ./neoclide/start/coc-neco && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-rust-analyzer
cd ./fannheyward/start/coc-rust-analyzer && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-tsserver
cd ./neoclide/start/coc-tsserver && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-java
cd ./neoclide/start/coc-tsserver && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-json
cd ./neoclide/start/coc-json && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-python
cd ./neoclide/start/coc-python && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-css
cd ./neoclide/start/coc-css && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-sh
cd ./josa42/start/coc-sh && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-html
cd ./neoclide/start/coc-html && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-powershell
cd ./coc-extensions/start/coc-powershell && yarn install --frozen-lockfile && cd $SCRIPT_DIR
# install coc-texlab
cd ./fannheyward/start/coc-texlab && yarn install --frozen-lockfile && cd $SCRIPT_DIR
