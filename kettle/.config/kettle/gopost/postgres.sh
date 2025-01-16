#!/bin/bash

# Pull the official PostgreSQL image
docker pull postgres

# Run PostgreSQL container
docker run --name mypostgres \
    --network host \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -e POSTGRES_USER=myuser \
    -e POSTGRES_DB=mydatabase \
    -p 5432:5432 \
    -d postgres
