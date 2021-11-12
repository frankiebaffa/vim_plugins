#!/bin/bash
# get current directory
CURR_DIR=$(pwd)
# get script dir
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# check args
if [ -z "$1" ]; then
	echo "Please include the plugin author's github username as first argument"
	exit 1
fi
if [ -z "$2" ]; then
	echo "Please include the plugin name as the second argument"
	exit 1
fi
if [ ! -z "$3" ]; then
	echo "Only two arguments are required"
	exit 1
fi
# prepare script to insert
INSTALL=$(cat << EOM
if [ "\$1" == "$2" ] || [ "\$1" == "all" ]; then
	# install $2
	cd ./$1/start/$2 &&
		yarn install --frozen-lockfile &&
		cd \$SCRIPT_DIR
fi
EOM
)
# add language server plugin
cd $SCRIPT_DIR &&
	mkdir -p "$1/start" &&
	git submodule add "https://github.com/$1/$2" "$1/start/$2" &&
	echo "$INSTALL" >> ./install.sh &&
	cd $CURR_DIR
exit 0
