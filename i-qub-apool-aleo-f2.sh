#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
wget --continue --tries=0 wget https://github.com/apool-io/apoolminer/releases/download/v2.7.4/apoolminer_linux_autoupdate_v2.7.4.tar.gz
wget --continue --tries=0 wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.14.tar.gz
mkdir ap
tar -xf apoolminer_linux_autoupdate_v2.7.4.tar.gz
tar -xf aleominer-3.0.14.tar.gz
cp ./apoolminer_linux_autoupdate_v2.7.4/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.7.4
cd ap
rm miner.conf
rm run.sh
cd ..
cp ./aleominer/aleominer ./ap/
rm -R aleominer
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

third_miner = "aleominer"
third_cmd = "./aleominer -u stratum+ssl://aleo-asia.f2pool.com:4420 -w rakot0707.$1"
EOF
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
chmod +x ./run.sh
screen -dmS qub ./run.sh

