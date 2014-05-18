#!/bin/sh

# Active/Backup構成のVIPに対してpingで死活監視して、
# 応答がない場合、自分に対してVIPを設定する

VIP="192.168.100.14"
DEV="wlp2s0"

# pingコマンドで死活監視
function heathcheck {
    ping -c 1 -w 1 $VIP > /dev/null
    return $?
}

function ip_takeover {
    # 正規表現でMACアドレスを抽出する
    MAC=`ip link show $DEV | egrep -o '([0-9a-f]{2}:){5}[0-9a-f]{2}' | head -n 1 | tr -d :`
    ip addr add $VIP/24 dev $DEV
    # install arp-scan package on archlinux: sudo pacman -S arp-scan
    arping -U -c 5 $VIP
}

# VIPの死活監視とVIPの割り当て
while heathcheck; do
    echo "heath ok!"
    sleep 1
done
echo "fail over!"
ip_takeover

ip addr show $DEV
