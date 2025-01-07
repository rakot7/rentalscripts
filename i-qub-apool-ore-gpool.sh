#!/bin/bash
apt update -y 
apt install -y screen git curl cron nano mc htop iputils-ping
cd /root/
mkdir qub
cd qub
wget --continue --tries=0 https://github.com/apool-io/apoolminer/releases/download/v2.7.9/apoolminer_linux_autoupdate_v2.7.9.tar.gz
wget --continue --tries=0 https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool
rm -R /root/qub/ap
mkdir ap
tar -xf apoolminer_linux_autoupdate_v2.7.9.tar.gz
cp gpool ./ap/
chmod +x ./ap/gpool
cp ./apoolminer_linux_autoupdate_v2.7.9/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.7.9
cd ap
rm miner.conf
rm run.sh
cd ..
cd ap
curl -OL https://raw.githubusercontent.com/rakot7/rentalscripts/main/run.sh
cat <<EOF > miner.conf
algo=qubic
account=CP_3kv3xuwg6d
pool=qubic1.hk.apool.io:3334

worker = $1
cpu-off = true
#thread = 12
#gpu-off = false
#gpu = 0,1,2
mode = 1

third_miner = "gpool"
third_cmd = "./gpool --pubkey Ao6eDhKg24gVBjFxxWpBB6yJJQXEQ4S4uSYbkz9zPfAt --worker $1"
EOF
chmod +x ./run.sh
screen -dmS qub ./run.sh
echo "\n[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/ap/ && screen -dmS qub ./run.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
