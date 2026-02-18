#!/bin/bash
apt update -y 
apt install -y screen git curl cron nano mc btop iputils-ping
cd /root/
mkdir qubic
cd qubic
wget --continue --tries=0 https://github.com/apool-io/apoolminer/releases/download/v3.4.4/apoolminer_linux_qubic_autoupdate_v3.4.4.tar.gz
tar -xf apoolminer_linux_qubic_autoupdate_v3.4.4.tar.gz
mv apoolminer_linux_qubic_autoupdate_v3.4.4 apool
cd apool
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.4/onezerominer-linux-1.7.4.tar.gz
tar -xf onezerominer-linux-1.7.4.tar.gz
cp onezerominer-linux/onezerominer ./
rm miner.conf
cat <<EOF > miner.conf
algo=qubic_xmr
account=CP_3kv3xuwg6d
pool=qubic1.hk.apool.io:3334
accountname="kotklgd.$(hostname)"

worker = $(hostname)
#cpu-off = true
#thread = 1
#gpu-off = true
#gpu = 0,1,2
xmr-gpu-off = true
#xmr-cpu-off = true
#xmr-thread = 1
#xmr-1gb-pages = true
#no-cpu-affinity = true
mode = 1

third_miner = "onezerominer"
third_cmd = "./onezerominer -a qhash -w bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname) -o stratum+tcp://fr1.luckypool.io:8611"
EOF
rm run.sh
curl -OL https://raw.githubusercontent.com/rakot7/rentalscripts/main/run.sh
chmod +x ./run.sh
screen -dmS qub ./run.sh
echo "\n[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qubic/apool/ && screen -dmS q ./run.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
