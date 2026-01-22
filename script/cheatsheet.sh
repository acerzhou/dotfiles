#!/usr/bin/env bash

languages=$(echo "golang c cpp typescript ruest" | tr " " "\n")
core_util=$(echo "find xargs sed awk" | tr " " "\n")

echo -e "$languages\n$core_util" | fzf
