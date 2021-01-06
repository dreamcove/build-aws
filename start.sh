#!/bin/sh

echo Initializing Container

localstack start --host &

bash -c "`echo $@`"

while true; do
	sleep 10
done
