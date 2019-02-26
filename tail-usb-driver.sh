#!/bin/bash

capture() {
    sudo dtrace -p "$1" -qn '
        syscall::write*:entry
        /pid == $target && arg0 == 1/ {
            printf("%s", copyinstr(arg1, arg2));
        }
    '
}

while [ -z "$(ps -ef | grep 'MCT' | grep -v 'grep')" ]
do
echo 'Waiting...'
done
PROC_ID=$(ps -ef | grep 'MCT' | grep -v 'grep' | awk -F' ' '{ print $2 }')
capture $PROC_ID
