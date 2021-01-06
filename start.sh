#!/bin/sh

echo Initializing Container

localstack start --host
bash -c "`echo $@`"