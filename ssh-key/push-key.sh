# add password in ''
for X in `cat hosts`
do
	sshpass -p '' ssh-copy-id root@${X}
done
