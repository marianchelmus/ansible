for user in lista-useri.txt
do
    mkdir -p /home/${user}/.ssh
    cp /home/funstudy/.ssh/authorized_keys /home/${user}/.ssh/authorized_keys
    chown -R ${user}:${user} /home/$user/.ssh
    chmod 700 /home/${user}/.ssh
    chmod 600 /home/${user}/.ssh/authorized_keys
done
