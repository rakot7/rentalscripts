#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
#echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
#apt update
#apt install libc6 -y
#apt install -y g++-11 -y
cd /
cd root
mkdir nock
cd nock
mv golden-miner-pool-prover golden-miner-pool-prover.bkp
wget --continue --tries=0 https://github.com/GoldenMinerNetwork/golden-miner-nockchain-gpu-miner/releases/download/v0.3.1/golden_miner_hiveos-0.3.1.tar.gz
tar -xf golden_miner_hiveos-0.3.1.tar.gz
cp ./golden_miner_hiveos/golden-miner-pool-prover ./
chmod +x ./golden-miner-pool-prover
cat <<EOF > nock.sh
while true; do
./golden-miner-pool-prover --pubkey=8X3NNWQEATKCd1YRQmPCnX8ADkR5ohh2D4AKcfzDgckNu4EkCGtaS3s --name $(hostname) --threads-per-card=4
done;
EOF
rm /etc/supervisor/conf.d/supervisord.conf
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:sshd]
command=/usr/sbin/sshd -D

[program:jupyter]
command=/bin/bash -c 'jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser'

[program:delegated_entrypoint]
command=/bin/bash /etc/delegated-entrypoint.sh

[program:nock]
command=/bin/bash -c 'cd /root/nock/ && screen -dmS nock ./nock.sh && sleep infinity'
EOF
chmod +x ./*
screen -dmS nock ./nock.sh
screen -r
