#!/bin/bash
function title-line() {
	NAME="vim-packages"
	VERSION="v0.0.1"
	TITLE_LINE="$NAME ($VERSION)"
	echo "$TITLE_LINE"
	echo "---"
}
COMMANDS=( "list" "install" "update" "init" "add" "rm" "clean" "info" )
LIST_CMD="${COMMANDS[0]}"
INSTALL_CMD="${COMMANDS[1]}"
UPDATE_CMD="${COMMANDS[2]}"
INIT_CMD="${COMMANDS[3]}"
ADD_CMD="${COMMANDS[4]}"
RM_CMD="${COMMANDS[5]}"
CLEAN_CMD="${COMMANDS[6]}"
INFO_CMD="${COMMANDS[7]}"
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
	title-line
	echo "No command defined"
	echo "Available commands:"
	for CMD in "${COMMANDS[@]}"; do
		echo -e "\t$CMD"
	done
	exit 1
fi
COMMAND="$1"
# validate command
if ! [[ "${COMMANDS[@]}" =~ "${COMMAND}" ]]; then
	title-line
	echo "Invalid command"
	echo "Available commands:"
	for CMD in "${COMMANDS[@]}"; do
		echo -e "\t$CMD"
	done
	exit 2
fi
PACKAGELESS_CMDS=( "$LIST_CMD" "$CLEAN_CMD" )
# make sure package is not blank if not list or clean
if ! [[ "${PACKAGELESS_CMDS[@]}" =~ "${COMMAND}" ]] && [ -z "$2" ]; then
	title-line
	if [ "$COMMAND" == "$ADD_CMD" ]; then
		echo "No git repo defined (author/package)"
	else
		echo "No package defined"
	fi
	exit 3
fi
TARGET="$2"
YN_VALS=( "y" "Y" "n" "N" )
# ADD
if [ "$COMMAND" == "$ADD_CMD" ]; then
	if [ -z "$3" ]; then
		title-line
		echo "No checkout point defined"
		exit 5
	fi
	CHECKOUT="$3"
	if [ -z "$4" ] || ! [[ "${YN_VALS[@]}" =~ "${4}" ]]; then
		title-line
		echo "Value <IS_LANG_SERV> must be withing (${YN_VALS[@]})"
		exit 6
	fi
	if [ "$4" == "${YN_VALS[0]}" ] || [ "$4" == "${YN_VALS[1]}" ]; then
		IS_LANG_SERV="1"
	else
		IS_LANG_SERV="0"
	fi
	IFS='/'; read -ra ITEMS <<< "$TARGET";
	AUTHOR="${ITEMS[0]}"
	PACKAGE="${ITEMS[1]}"
	INSTALL_PATH="$AUTHOR/start/$PACKAGE"
	if [ -f "$INSTALL_PATH" ]; then
		echo "Plugin $PACKAGE by $AUTHOR is already installed"
		exit 7
	fi
	echo "Adding new plugin:"
	echo -e "\tAuthor:  $AUTHOR"
	echo -e "\tPackage: $PACKAGE"
	if [ -d "$AUTHOR" ]; then
		AUTHOR_EXISTS="YES"
	else
		AUTHOR_EXISTS=""
	fi
	if [ -d "$AUTHOR/start" ]; then
		START_EXISTS="YES"
	else
		START_EXISTS=""
	fi
	if ! mkdir -p "$AUTHOR/start"; then
		exit 8
	fi
	GIT_URL="https://github.com/$AUTHOR/$PACKAGE"
	if ! git submodule add "$GIT_URL" "$INSTALL_PATH"; then
		echo "Failed to add submodule $GIT_URL"
		if [ -z "$START_EXISTS" ] && [ -d "$AUTHOR/start" ]; then
			echo "Removing new directory $AUTHOR/start"
			rmdir "$AUTHOR/start"
		fi
		if [ -z "$AUTHOR_EXISTS" ] && [ -d "$AUTHOR" ]; then
			echo "Removing new directory $AUTHOR"
			rmdir "$AUTHOR"
		fi
		exit 9
	fi
	if ! cd "$INSTALL_PATH"; then
		echo "Failed to cd into $INSTALL_PATH"
		exit 10
	fi
	if ! git checkout "$CHECKOUT"; then
		echo "Failed to checkout $CHECKOUT"
		if ! git rm "$INSTALL_PATH"; then
			echo "Failed to remove submodule $INSTALL_PATH"
			exit 11
		fi
		exit 12
	fi
	if ! cd "$PLUGINS_DIR"; then
		echo "Failed to cd into $PLUGINS_DIR"
		exit 13
	fi
	if ! git add "$INSTALL_PATH"; then
		echo "Failed to stage submodule changes"
		exit 14
	fi
	if ! git add "$PACKAGE_CSV"; then
		echo "Failed to stage $PACKAGE_CSV changes"
		exit 15
	fi
	if ! git commit -m "Added added plugin $PACKAGE by $AUTHOR"; then
		echo "Failed to commit changes"
		exit 16
	fi
	NEW_LINE="$AUTHOR,$PACKAGE,$IS_LANG_SERV,$CHECKOUT"
	if ! echo "$NEW_LINE" >> "$PACKAGE_CSV"; then
		echo "Failed to append new line to $PACKAGE_CSV"
		exit 17
	fi
	exit 0
elif [ "$COMMAND" == "$RM_CMD" ]; then
	IFS='/'; read -ra ITEMS <<< "$TARGET";
	AUTHOR="${ITEMS[0]}"
	PACKAGE="${ITEMS[1]}"
	if ! grep -q "^$AUTHOR,$PACKAGE" "$PACKAGE_CSV"; then
		title-line
		echo "Package $AUTHOR/$PACKAGE does not exist in plugins"
		exit 18
	fi
	INSTALL_PATH="$AUTHOR/start/$PACKAGE"
	if ! git rm "$INSTALL_PATH"; then
		echo "Failed to remove submodule"
		exit 19
	fi
	if ! sed -i "/$AUTHOR,$PACKAGE,.*/d" "$PACKAGE_CSV"; then
		echo "Failed to remove line from $PACKAGE_CSV"
		exit 20
	fi
	if ! git add "$PACKAGE_CSV"; then
		echo "Failed to stage changes to $PACKAGE_CSV"
		exit 21
	fi
	if ! git commit -m "Removed $PACKAGE by $AUTHOR"; then
		echo "Failed to commit removal"
		exit 22
	fi
	exit 0
fi
if [ "$COMMAND" == "$CLEAN_CMD" ]; then
	title-line
	echo "Clean command not yet implemented"
#	if [ -z "$2" ]; then
#		FORCE="0"
#	elif [ "$2" == "-f" ] || [ "$2" == "--force" ]; then
#		FORCE="1"
#	fi
#	IGNORE=( "bin" "utils" "node_modules" )
#	exit 0
#	for DIR in */; do
#		DIR=${DIR%*/} # remove trailing slash
#		if [[ "${IGNORE[@]}" =~ "${DIR}" ]]; then
#			echo "Directory $DIR is ignored"
#			continue
#		fi
#		if [ -z "$(ls -A "$DIR/start")" ]; then
#			echo "Removing $DIR/start bc it is empty"
#			if ! rmdir "$DIR/start"; then
#				echo "Failed to delete directory $DIR/start"
#				exit 23
#			fi
#			if [ -z "$(ls -A "$DIR")" ]; then
#				echo "Removing $DIR bc it is empty"
#				if ! rmdir "$DIR"; then
#					echo "Failed to delete directory $DIR"
#					exit 24
#				fi
#			fi
#			continue
#		fi
#	done
#	exit 0
fi
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
	FULL_NAME="${SUB_ARR[1]}"
	IS_LSP="${SUB_ARR[2]}"
	CHECKOUT_POINT="${SUB_ARR[3]}"
	NOTES="${SUB_ARR[4]}"
	NOTES="$(echo "$NOTES" | tr "_" " ")"
	SHORT_PATH="$AUTHOR/start/$FULL_NAME"
	PLUGIN_PATH="$PLUGINS_DIR/$SHORT_PATH"
	if [ "$COMMAND" == "$LIST_CMD" ]; then
		echo "$FULL_NAME: $SHORT_PATH";
	else
		# processing complete, perform command
		if [ "$TARGET" == "$FULL_NAME" ] || [ "$TARGET" == "all" ]; then
			# INSTALL
			if [ "$COMMAND" == "$INSTALL_CMD" ]; then
				if [ "$IS_LSP" == "0" ]; then
					echo "$FULL_NAME is not a language server, nothing to install"
					exit 0 # not an error
				fi
				echo "Installing $FULL_NAME: $PLUGIN_PATH"
				cd "$PLUGIN_PATH" &&
					yarn install --frozen-lockfile &&
					cd "$PLUGINS_DIR" &&
					echo "Installed $FULL_NAME"
					exit 0
			# UPDATE
			elif [ "$COMMAND" == "$UPDATE_CMD" ]; then
				echo "Updating $FULL_NAME: $PLUGIN_PATH"
				cd "$PLUGIN_PATH" &&
					git checkout "$CHECKOUT_POINT" &&
					cd "$PLUGINS_DIR" &&
					echo "Updated $FULL_NAME" &&
					exit 0
			# INIT
			elif [ "$COMMAND" == "$INIT_CMD" ]; then
				echo "Initializing $FULL_NAME: $PLUGIN_PATH"
				git submodule update --init "$PLUGIN_PATH" &&
					echo "Initialized $FULL_NAME" &&
					exit 0
			# INFO
			elif [ "$COMMAND" == "$INFO_CMD" ]; then
				if [ ! -z "$NOTES" ]; then
					title-line
					echo "$FULL_NAME: $NOTES"
					exit 0
				else
					title-line
					echo "$FULL_NAME: Plugin exists with no info"
					exit 0
				fi
			fi
		fi
	fi
done
title-line
echo "$TARGET did not match an existing plugin"
exit 99 # last exit code
