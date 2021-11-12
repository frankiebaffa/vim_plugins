#!/bin/bash
# get current directory
CURR_DIR=$(pwd)
# get script dir
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $SCRIPT_DIR
# update submodules
git submodule update --init --recursive --remote
# return
cd $CURR_DIR

