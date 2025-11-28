#!/bin/bash

# Initialize the go module
if [ ! -f go.mod ]; then
  go mod init webserver
fi

# Install the required go packages
./packages.sh
go mod tidy
