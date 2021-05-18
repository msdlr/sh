#!/usr/bin/env sh
httpdate="$(wget --no-cache -S -O /dev/null google.com 2>&1 | sed -n -e 's/  *Date: *//p' -eT -eq)"
[ -n "$httpdate" ] && sudo date -s "$httpdate"
