#!/bin/sh

#
# $1 -- incoming bandwidth
# $2 -- outgoing bandwidth
#
# bandwidth.sh init -- modprobe && ip up
# bandwidth.sh x y  -- set incoming bandwidth to x, outgoing to y
# bandwidth.sh      -- remove limits
# bandwidth.sh - y  -- remove incoming limits, set outgoing limit
#

# init
# modprobe ifb numifbs=1
# ip link set dev ifb0 up # repeat for ifb1, ifb2, ...

PHY=eth0
VIR=ifb0
IN=$1
OUT=$2

function go() {
    echo "$*"
    eval "$*"
    return $?
}

if [ $# -eq 1 ]; then
    if [ $1 == "init" ]; then
        echo "Initializing"
        go modprobe ifb numifbs=1
        go ip link set dev ifb0 up
        exit 0
    fi
fi

[ "$IN" == "-" ] && IN=
[ "$OUT" == "-" ] && OUT=

go tc qdisc del dev $PHY root       # clear outgoing
go tc qdisc del dev $PHY ingress    # clear incoming
go tc qdisc del dev $VIR root       # clean incoming

[ $# -eq 0 ] && exit 0

go tc qdisc add dev $PHY handle ffff: ingress
go tc filter add dev $PHY parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0

if [ -n "$IN" ]; then
    # incoming
    go tc qdisc add dev $VIR root handle 1: htb default 10
    go tc class add dev $VIR parent 1: classid 1:1 htb rate $IN
    go tc class add dev $VIR parent 1:1 classid 1:10 htb rate $IN
fi

if [ -n "$OUT" ]; then
    # outgoing
    go tc qdisc add dev $PHY root handle 1: htb default 10
    go tc class add dev $PHY parent 1: classid 1:1 htb rate $OUT
    go tc class add dev $PHY parent 1:1 classid 1:10 htb rate $OUT
fi
