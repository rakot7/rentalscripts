#!/bin/bash
apt update && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir ore
cd ore
wget --continue --tries=0 https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool
chmod +x ./gpool
cat <<EOF > ore.sh
#!/bin/bash
while true; do
if pgrep -f "gpool" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  gpoolminer is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No gpoolminer , running gpoolminer"
        while true; do
                ./gpool --pubkey Ao6eDhKg24gVBjFxxWpBB6yJJQXEQ4S4uSYbkz9zPfAt --worker $1 &
                PID=\$!
                sleep 1h
                kill \$PID
                sleep 15s;
        done;
fi
done
EOF
chmod +x ./ore.sh
screen -dmS ore ./ore.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:ore]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/ore/ && screen -dmS ore ./ore.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
