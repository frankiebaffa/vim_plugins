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
if [ -z "$3" ]; then
	echo "Please include the desired reference name for the plugin as the third argument"
	exit 1
fi
if [ ! -z "$4" ]; then
	echo "Only three arguments are required"
	exit 1
fi
# prepare script to insert
PATH="./$1/start/$2"
if [[ -f "$PATH/.git" ]]; then
	echo "The repo for language server \"$2\" may already be added";
else
	echo "Creating dir and cloning repo"
	mkdir -p "$1/start" &&
		git submodule add "https://github.com/$1/$2" "$1/start/$2" &&
		echo "Complete"
fi
INSTALL_LINE="$3,$PATH"
INSTALL_FILE="./ls.csv"
HAS_LINE=$(egrep "$INSTALL_LINE" $INSTALL_FILE)
if [ ! -z "$HAS_LINE" ]; then
	echo "Plugin definition \"$INSTALL_LINE\" already exists in \"$INSTALL_FILE\""
else
	echo "Adding line \"$INSTALL_LINE\" to \"$INSTALL_FILE\""
	echo "$INSTALL_LINE" >> $INSTALL_FILE &&
		echo "Complete"
fi
# return to dir
cd "$CURR_DIR"
