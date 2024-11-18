#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd /root/
mkdir qub
cd qub
wget https://github.com/apool-io/apoolminer/releases/download/v2.6.6/apoolminer_linux_autoupdate_v2.6.6.tar.gz
wget https://github.com/gpool-cloud/gpool-cli/raw/refs/heads/main/gpool
rm -R /root/qub/ap
mkdir ap
tar -xf apoolminer_linux_autoupdate_v2.6.6.tar.gz
cp gpool ./ap/
chmod +x ./ap/gpool
cp ./apoolminer_linux_autoupdate_v2.6.6/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.6.6
cd ap
rm miner.conf
rm run.sh
cat <<EOF > qub.sh
#!/bin/bash
while true; do
if pgrep -f "apooliner" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  apoolminer is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No apoollminer , running apoolminer"
        ./apoolminer --account CP_3kv3xuwg6d --pool qubic1.hk.apool.io:3334 --cpu-off --worker $1
fi
done
EOF
cat <<EOF > ore.sh
#!/bin/bash
while true; do
if pgrep -f "gpool" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  gpoolminer is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No gpoolminer , running gpoolminer"
        ./gpool --pubkey Ao6eDhKg24gVBjFxxWpBB6yJJQXEQ4S4uSYbkz9zPfAt
fi
done
EOF
chmod +x ./qub.sh
screen -dmS qub ./qub.sh
chmod +x ./ore.sh
screen -dmS ore ./ore.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/ap/ && screen -dmS qub ./qub.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:ore]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/ap/ && screen -dmS ore ./ore.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
