#!/bin/bash
# get current directory
CURR_DIR=$(pwd)
# get script dir
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# check args
if [ -z "$1" ]; then
	echo "Please include the name of the lang server to install, if all then include \"all\"";
	exit 1;
fi
# goto script dir
cd $SCRIPT_DIR
if [ "$1" == "coc-neco" ] || [ "$1" == "all" ]; then
	# install coc-neco
	cd ./neoclide/start/coc-neco &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-rust-analyzer" ] || [ "$1" == "all" ]; then
	# install coc-rust-analyzer
	cd ./fannheyward/start/coc-rust-analyzer &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-tsserver" ] || [ "$1" == "all" ]; then
	# install coc-tsserver
	cd ./neoclide/start/coc-tsserver &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-tsserver" ] || [ "$1" == "all" ]; then
	# install coc-java
	cd ./neoclide/start/coc-tsserver &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-json" ] || [ "$1" == "all" ]; then
	# install coc-json
	cd ./neoclide/start/coc-json &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-python" ] || [ "$1" == "all" ]; then
	# install coc-python
	cd ./neoclide/start/coc-python &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-css" ] || [ "$1" == "all" ]; then
	# install coc-css
	cd ./neoclide/start/coc-css &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-sh" ] || [ "$1" == "all" ]; then
	# install coc-sh
	cd ./josa42/start/coc-sh &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-html" ] || [ "$1" == "all" ]; then
	# install coc-html
	cd ./neoclide/start/coc-html &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-powershell" ] || [ "$1" == "all" ]; then
	# install coc-powershell
	cd ./coc-extensions/start/coc-powershell &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
if [ "$1" == "coc-texlab" ] || [ "$1" == "all" ]; then
	# install coc-texlab
	cd ./fannheyward/start/coc-texlab &&
		yarn install --frozen-lockfile &&
		cd $SCRIPT_DIR
fi
