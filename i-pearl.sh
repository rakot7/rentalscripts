#!/bin/bash
apt update -y
apt install -y screen btop
cd /
cd root
mkdir pearl
cd pearl
wget -c -tries=0 https://pearlhash.xyz/downloads/pearl-miner-v2
chmod +x ./pearl-miner-v2
cat <<EOF > pearl.sh
#!/bin/bash
	./pearl-miner-v2 --host 84.32.220.219:9000 --user prl1pqyjpfkk3cexjdzt998necuce8m60ep7kc3aru4jard5067k9q88s0qrgse --worker $(hostname)
EOF
chmod +x ./pearl.sh
screen -dmS p ./pearl.sh | tee miner.log
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
[program:pearl]
command=/bin/bash -c 'cd /root/pearl && screen -dmS pearl ./pearl.sh && sleep infinity'
EOF
