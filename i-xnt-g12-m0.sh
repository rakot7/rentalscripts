#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
cd /root/
mkdir xnt
cd xnt
wget --continue --tries=0 https://pub-7c2f8935763c410d8897cc0d6379670e.r2.dev/ubuntu_20-dr_xnt_prover-1.2.0.tar.gz
tar -xf ubuntu_20-dr_xnt_prover-1.2.0.tar.gz
cd dr_xnt_prover
rm inner_guesser.sh
cat <<EOF > inner_guesser.sh
#!/bin/bash
# set your own drpool accountname
#accountname="golden0707.O-1475391"
accountname="kotklgd.$(hostname)"
pids=\$(ps -ef | grep dr_xnt_prover | grep -v grep | awk '{print \$2}')
	if [ -n "\$pids" ]; then
		echo "\$pids" | xargs kill
		sleep 5
	fi
while true; do
target=\$(ps aux | grep dr_xnt_prover | grep -v grep)
if [ -z "\$target" ]; then
	./dr_xnt_prover --pool stratum+tcp://xnt.drpool.io:30120 --worker \$accountname -g 1,2 -m 0
	sleep 5
fi
sleep 60
done
EOF
chmod +x ./inner_guesser.sh
nohup /root/xnt/dr_xnt_prover/inner_guesser.sh &
