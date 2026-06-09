#!/bin/bash
apt update -y
apt install -y screen btop moreutils curl
echo 'root:Q!@We34rt56y' | chpasswd
cd /
cd root
mkdir pearl
cd pearl
wget -c -t=0 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.7/alpha-miner-1.7.7
mv alpha-miner-1.7.7 alpha-miner;
chmod +x alpha-miner
rm pearl.sh;
cat <<EOF > pearl.sh
#!/bin/bash
while true; do
        ./alpha-miner --pool stratum+tcp://ru1.alphapool.tech:5566 --address prl1pqyjpfkk3cexjdzt998necuce8m60ep7kc3aru4jard5067k9q88s0qrgse --worker $(hostname) --password "x;d=262144" &
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
screen -r p
