#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
pkill -f npt
pkill -f qtc
pkill -f qub
cd /root/
mkdir npt
cd npt
wget --continue --tries=0 https://pub-e1b06c9c8c3f481d81fa9619f12d0674.r2.dev/image/v2/ubuntu_20-dr_neptune_prover-4.0.0.tar.gz
tar -xf ubuntu_20-dr_neptune_prover-4.0.0.tar.gz
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.4/onezerominer-linux-1.7.4.tar.gz
tar -xf onezerominer-linux-1.7.4.tar.gz
cp ./onezerominer-linux/onezerominer ./dr_neptune_prover/
cd dr_neptune_prover
rm inner_guesser.sh
cat <<EOF > inner_guesser.sh
#!/bin/bash

# set your own drpool accountname
#accountname="golden0707.$(hostname)"
accountname="kotklgd.$(hostname)"

pids=\$(ps -ef | grep dr_neptune_prover | grep -v grep | awk '{print \$2}')
if [ -n "\$pids" ]; then
    echo "\$pids" | xargs kill
    sleep 5
fi

while true; do
    target=\$(ps aux | grep dr_neptune_prover | grep -v grep)
    if [ -z "\$target" ]; then
        ./dr_neptune_prover --pool stratum+tcp://neptune.drpool.io:30127 --worker \$accountname -g 0 -m 2 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610'
        sleep 5
    fi
    sleep 60
done
EOF
chmod +x ./inner_guesser.sh
screen -dmS npt ./inner_guesser.sh
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
[program:npt]
command=/bin/bash -c 'cd /root/npt/dr_neptune_prover/ && screen -dmS npt ./inner_guesser.sh && sleep infinity'
EOF
