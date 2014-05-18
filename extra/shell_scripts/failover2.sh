#!/bin/sh

# DNSより負荷分散、各ノードにてVIPに対してL7ヘルスチェックを
# を行い、L7通らない場合、自分自分のVIP割り当てを確認する
# VIPが自分に割り当てた場合、IP解除を実施する
# VIPが他サーバに割り当てた場合、VIPを引き続きする

VIP="10.0.0.1 10.0.0.2"
DEV="wlp2s0"

function ip_takeover() {

    echo "takeover vip $1"

    # 引数から割り当てVIPを取り出す
    XVIP=$1

    # IP割り当てを行う
    ip addr add $1/24 dev $DEV

    # Gratuitous ARP更新
    arping -U -c 5 $XVIP
}

function ip_release {
    echo "release vip $1"
    ip addr del $1/24 dev $DEV
}

# curlとりhttpサービスのL7ヘルスチェックを行う
function heathcheck {
    for i in $VIP; do
        # L7ヘルスチェック
        if [ "200" != "`curl -s -I 'http://$i/' | head -n 1 | cut -f 2 -d ' '`" ]; then
            # 自分自分のVIP割り当て状況を確認する
            if [ -z "`ip addr show $DEV | fgrep $i`" ]; then
                ip_takeover $i
            else
                ip_release $i
            fi
        fi
        echo "-------------------------------------------------------"
        ip addr show $DEV
        echo "-------------------------------------------------------"
    done
}

while [ true ]; do
    heathcheck
    sleep 1
done
