#!/bin/bash

# goes to the saved project path
gop() {
	path=$(cat ~/.project)
	cd $path
	unset path
}

# saves the current path for quick access
setp() {
	echo $(pwd) >~/.project
}

# quick cd with zoxide
z() {
	path=$(zoxide query $2)
	if [test -z $path]; then
		echo "No such project"
	else
		cd $path
	fi
	unset path
}

# quick open a project with zoxide
o() {
	cur=$(pwd)
	z $1
    ts $1
	unset cur
}

oe() {
	cur=$(pwd)
	z $1
    epi $1
	unset cur
}

# init a c project quickly with kettle
cinit() {
	kettle use c_project .
	echo "Project Initialised ✅"
}

batdiff() {
	git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

gss() {
	echo "Untracked files:"
	git status --porcelain | grep '^??' | wc -l
	echo "Staged files:"
	git status --porcelain | grep '^[ MD]' | wc -l
	echo "Lines of code:"
	tokei --output yaml | yq '.Total.code'
}

gcs() {
	git clone "git@github.com:$argv.git"
}
