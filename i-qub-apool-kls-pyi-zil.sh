#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
wget https://github.com/apool-io/apoolminer/releases/download/v2.3.0/apoolminer_linux_autoupdate_v2.3.0.tar.gz
wget https://github.com/rigelminer/rigel/releases/download/1.19.1/rigel-1.19.1-linux.tar.gz
mkdir ap
tar -xf apoolminer_linux_autoupdate_v2.3.0.tar.gz
tar -xf rigel-1.19.1-linux.tar.gz rigel-1.19.1-linux/rigel
cp ./apoolminer_linux_autoupdate_v2.3.0/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.3.0
cp ./rigel-1.19.1-linux/rigel ./ap/rigel
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

third_miner = "aleo_prover"
third_cmd = "./aleo_prover --pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"
EOF
chmod +x ./run.sh
screen -dmS qub ./run.sh
echo "\n[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/ap/ && screen -dmS qub ./run.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
