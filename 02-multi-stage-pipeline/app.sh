#!/bin/bash
while read -r name; do
  echo "Hello, $name"
done < "$1"
