#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
cd /root/
mkdir xnt
cd xnt
wget --continue --tries=0 https://pub-7c2f8935763c410d8897cc0d6379670e.r2.dev/ubuntu_20-dr_xnt_prover-1.2.0.tar.gz
tar -xf ubuntu_20-dr_xnt_prover-1.2.0.tar.gz
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.4/onezerominer-linux-1.7.4.tar.gz
tar -xf onezerominer-linux-1.7.4.tar.gz
cp ./onezerominer-linux/onezerominer ./dr_xnt_prover/
cd dr_xnt_prover
rm inner_guesser.sh
cat <<EOF > inner_guesser.sh
#!/bin/bash

# set your own drpool accountname
#accountname="golden0707.O-1475391"
accountname="kotklgd.$(hostname)"

pids=$(ps -ef | grep dr_xnt_prover | grep -v grep | awk '{print $2}')
if [ -n "$pids" ]; then
    echo "$pids" | xargs kill
    sleep 5
fi

while true; do
    target=$(ps aux | grep dr_xnt_prover | grep -v grep)
    if [ -z "$target" ]; then
        ./dr_xnt_prover --pool stratum+tcp://xnt.drpool.io:30120 --worker \$accountname -g 0,1,2 -m 1 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610'
        sleep 5
    fi
    sleep 60
done
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

[program:xnt]
command=/bin/bash -c 'cd /root/xnt/dr_xnt_prover/ && screen -dmS xnt ./inner_guesser.sh && sleep infinity'
EOF
chmod +x ./inner_guesser.sh
screen -dmS xnt ./inner_guesser.sh

#==============================================

#/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
cd /root/
mkdir xmr
cd xmr
wget --continue --tries=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/3.0.9/SRBMiner-Multi-3-0-9-Linux.tar.gz
tar -xf SRBMiner-Multi-3-0-9-Linux.tar.gz
cd SRBMiner-Multi-3-0-9
#========================================================
CPU_CORES=$(nproc)
MINER_THREADS=$((CPU_CORES /4))
#=========================================================
cat <<EOF > xmr.sh
#!/bin/sh
export GPU_MAX_HEAP_SIZE=100
export GPU_MAX_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100
export GPU_MAX_SINGLE_ALLOC_PERCENT=100
export GPU_ENABLE_LARGE_ALLOCATION=100
export GPU_MAX_WORKGROUP_SIZE=1024

while true;do
./SRBMiner-MULTI --algorithm randomx --wallet 4DSQMNzzq46N1z2pZWAVdeA6JvUL9TCB2bnBiA3ZzoqEdYJnMydt5akCa3vtmapeDsbVKGPFdNkzqTcJS8M8oyK7WGkCoEKV3Sq8opAfNK.$(hostname) --pool pool.supportxmr.com:3333 --disable-gpu --cpu-threads $MINER_THREADS --keepalive true
sleep 15s
done;
EOF
#===============================
echo "141.95.72.59 pool.supportxmr.com" >> /etc/hosts

#=================================
chmod +x ./xmr.sh
screen -dmS xmr ./xmr.sh
