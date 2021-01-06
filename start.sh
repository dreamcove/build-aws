#!/bin/sh

echo Initializing Container

docker-entrypoint.sh &

bash -c "`echo $@`"

while true; do
	sleep 10
done
