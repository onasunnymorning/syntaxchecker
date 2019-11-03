#!/bin/sh

die_func() {
        echo "oh no lets die"
        sleep 2
        exit 1
}
trap die_func TERM

echo "sleeping"
sleep 100000 &
wait