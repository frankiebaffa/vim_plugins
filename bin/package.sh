#!/bin/bash
VERSION="v0.0.1"
NAME="vim-packages"
TITLE_LINE="$NAME ($VERSION)"
COMMANDS=("list" "install" "update" "init")
# get current directory
CURR_DIR=$(pwd)
# get script directory
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# mark root directory of plugins
PLUGINS_DIR="$SCRIPT_DIR/.."
# get csv
PACKAGE_CSV="$PLUGINS_DIR/utils/plugins.csv"
# parse command
if [ -z "$1" ]; then
	echo "$TITLE_LINE"
	echo "---"
	echo "No command defined"
	echo "Available commands:"
	for CMD in "${COMMANDS[@]}"; do
		echo -e "\t$CMD"
	done
	exit 1
fi
COMMAND="$1"
if ! [[ "${COMMANDS[@]}" =~ "${COMMAND}" ]]; then
	echo "$TITLE_LINE"
	echo "---"
	echo "Invalid command"
	echo "Available commands:"
	for CMD in "${COMMANDS[@]}"; do
		echo -e "\t$CMD"
	done
	exit 2
fi
# make sure package is not blank if not list
if [ "$COMMAND" != "${COMMANDS[0]}" ] && [ -z "$2" ]; then
	echo "$TITLE_LINE"
	echo "---"
	echo "No package defined"
	exit 3
fi
TARGET="$2"
# parse csv
cd "$PLUGINS_DIR"
LINES="$(cat "$PACKAGE_CSV")"
NEWLINE="\n"
LINES=$LINES$NEWLINE
LINE_ARR=()
while [[ $LINES ]]; do
	LINE_ARR+=( "${LINES%%"$NEWLINE"*}" )
	LINES=${LINES#*"$NEWLINE"}
done
SKIP=$((1))
for LINE in ${LINE_ARR[@]}; do
	if [ $SKIP -eq 1 ]; then
		SKIP=$((0))
		continue
	fi
	COMMA=","
	LINE=$LINE$COMMA
	# split lines on comma and add to array
	SUB_ARR=()
	while [[ $LINE ]]; do
		SUB_ARR+=( "${LINE%%"$COMMA"*}" )
		LINE=${LINE#*"$COMMA"}
	done
	AUTHOR="${SUB_ARR[0]}"
	SHORT_NAME="${SUB_ARR[1]}"
	FULL_NAME="${SUB_ARR[2]}"
	IS_LSP="${SUB_ARR[3]}"
	CHECKOUT_POINT="${SUB_ARR[4]}"
	PLUGIN_PATH="$PLUGINS_DIR/$AUTHOR/start/$FULL_NAME"
	if [ "$COMMAND" == "${COMMANDS[0]}" ]; then # list
		echo "$SHORT_NAME: $PLUGIN_PATH";
	else
		# processing complete, perform installation tasks
		if [ "$TARGET" == "$SHORT_NAME" ] || [ "$TARGET" == "$FULL_NAME" ] || [ "$TARGET" == "all" ]; then
			if [ "$COMMAND" == "${COMMANDS[1]}" ]; then # install
				if [ "$IS_LSP" == "0" ]; then
					echo "$SHORT_NAME is not a language server, nothing to install"
				fi
				echo "Installing $SHORT_NAME: $PLUGIN_PATH"
				cd "$PLUGIN_PATH" &&
					yarn install --frozen-lockfile &&
					cd "$PLUGINS_DIR"
			elif [ "$COMMAND" == "${COMMANDS[2]}" ]; then # update
				echo "Updating $SHORT_NAME: $PLUGIN_PATH"
				cd "$PLUGIN_PATH" &&
					git checkout "$CHECKOUT_POINT" &&
					cd "$PLUGINS_DIR"
			elif [ "$COMMAND" == "${COMMANDS[3]}" ]; then # init
				echo "Initializing $SHORT_NAME: $PLUGIN_PATH"
				git submodule update --init "$PLUGIN_PATH"
			fi
		fi
	fi
done
