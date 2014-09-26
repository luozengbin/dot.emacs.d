#!/bin/sh

# rootユーザの実行禁止
check_root() {
  if [ $(id -u) -eq 0 ]; then
    echo 'This script must not be run as root'
    exit 1
  fi
}

# シンボリックの参照パス
get_real_path() {
  path=$(readlink -e $1)
  echo ${path}
}

check_root

get_real_path /usr/lib/jvm/default
