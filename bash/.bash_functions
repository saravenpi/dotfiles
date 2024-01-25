#!/bin/bash

gop() {
	path=$(cat ~/.project)
	cd $path
	unset path
}

setp() {
    echo $(pwd) > ~/.project
}
