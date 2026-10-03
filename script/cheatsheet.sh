#!/usr/bin/env bash

languages=$(echo "golang c cpp typescript rust" | tr " " "\n")
core_util=$(echo "find xargs sed awk" | tr " " "\n")

printf "%s\n%s\n" "$languages" "$core_util" | fzf
