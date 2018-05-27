#!/bin/bash
for host in `cat hosts`
do
	ssh -q -o PreferredAuthentications=publickey -o connectTimeout=3 root@${host} "echo 2>&1" && echo SSH-ok-on $host  || echo SSH-NOT-OK-on $host
done
