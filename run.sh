#!/bin/bash -eux

NAME=vm-kmm
UD=$(mktemp)
cat >$UD <<EOF
#cloud-config
runcmd:
- pro attach YOUR_PRO_TOKEN --no-auto-enable
- pro enable realtime-kernel --assume-yes
- curl -fsSL https://get.docker.com | sh
EOF

lxc delete -f $NAME &> /dev/null|| true
lxc init ubuntu-daily:jammy $NAME --vm --config user.user-data="$(cat "$UD")"
lxc config device add $NAME src disk source=$PWD path=/src
lxc start $NAME

wait_instance() {
	until lxc exec $NAME -- cloud-init status; do
		echo waiting
		sleep 1
	done
	lxc exec $NAME -- cloud-init status --wait
}

wait_instance
# restart on realtime-kernel
lxc restart $NAME
wait_instance

lxc exec $NAME -- bash -c 'uname -r | grep realtime'
lxc exec $NAME --cwd /src -- ./run-inside.sh

lxc delete -f $NAME &> /dev/null|| true