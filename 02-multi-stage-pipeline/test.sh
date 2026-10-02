#!/bin/bash
out=$(./app.sh names.txt)
echo "$out"
[ "$(echo "$out" | wc -l)" -eq 3 ] && echo PASS || { echo FAIL; exit 1; }
