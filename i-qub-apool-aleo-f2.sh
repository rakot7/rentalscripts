#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
wget https://github.com/apool-io/apoolminer/releases/download/v2.4.3/apoolminer_linux_autoupdate_v2.4.3.tar.gz
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer+3.0.10.zip
mkdir ap
tar -xf apoolminer_linux_autoupdate_v2.4.3.tar.gz
tar -xf aleominer+3.0.10.zip
cp ./apoolminer_linux_autoupdate_v2.4.3/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.4.3
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

third_miner = "aleo_prover"
third_cmd = "./aleo_prover -pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"
EOF
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
chmod +x ./run.sh
screen -dmS qub ./run.sh

