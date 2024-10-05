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

third_miner = "rigel"
third_cmd = "./rigel -a karlsenhashv2+pyrinhashv2+zil -o [1]stratum+tcp://ru.karlsen.herominers.com:1195 -u [1]karlsen:qqltw3p2cprratlfwxh4edf5txz7m7ungewhqf9fm39h4trpf9mrsv9ch6ge4 -o [2]stratum+tcp://ru.pyrin.herominers.com:1177 -u [2]pyrin:qzu9380zhth8wu37d7zjazv2xfnrv67p2m9t5eden03wgnvaf7kn7un0kfufx -o [3]stratum+tcp://eu.zil.k1pool.com:1111 -u [3]KrTNcwsTe9exc7z9PBbThE533vEJzpfjDGb --zil-countdown -w $1"
EOF
chmod +x ./run.sh
screen -dmS qub ./run.sh
echo "\n[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/ap/ && screen -dmS qub ./run.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
