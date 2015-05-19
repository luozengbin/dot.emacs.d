#!/bin/sh

if [ ! $# -eq 1 ]; then
    echo "Usage ${0} <JVM PID>"
    exit 1
fi

printf "[ PID ]\t[StackSize]\t[GuardPages]\t[Thread Name]\n"

# jstackの出力結果からスレッドIDと名前を抽出する
jstack $1 | grep nid | sed -e "s/^\"\(.*\)\".*nid=\(0x[0-9|a-z]*\).*$/\2,\1/" | sort | while read line
do
    # スレッドIDを切り出す
    pid_hex=`echo "${line}" | awk -F"," '{print $1}'`

    # スレッド名を切り出す
    thread_name=`echo "${line}" | awk -F"," '{print $2}'`

    # スレッドIDを10進数に変換
    pid=`printf '%d\n' ${pid_hex}`

    # /proc/<pid>/smaps ファイルからスタックサイズ、ガードページサイズを取得する
    guard_page=`cat /proc/$1/smaps | grep -B15 "stack:${pid}"| head -1 | awk '{print $2}'`
    stack_page=`cat /proc/$1/smaps | grep -A1 "stack:${pid}" | tail -1 | awk '{print $2}'`
    stack_size=`expr ${guard_page} + ${stack_page}`
    printf "%7d\t%11s\t%12s\t%s\n" "${pid}" "${stack_size}Kb" "${guard_page}Kb" "${thread_name}"
done
