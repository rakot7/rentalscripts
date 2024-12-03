#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir grypm
cd grypm
wget --continue --tries=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/2.7.0/SRBMiner-Multi-2-7-0-Linux.tar.gz
tar -xf SRBMiner-Multi-2-7-0-Linux.tar.gz
cd SRBMiner-Multi-2-7-0
cat <<EOF > grypm.sh
#!/bin/bash
while true; do
if pgrep -f "SRBMiner-MULTI" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  SRBMiner-MULTI is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No SRBMiner-MULTI , running SRBMiner-MULTI"
        ./SRBMiner-MULTI --algorithm memehash --pool stratum-eu.rplant.xyz:17074 --tls true --wallet UR4ap5nis3ybgxJdJ6kKf5ZttXedXLcuAS.$1 --keepalive true
fi
done
EOF
chmod +x ./grypm.sh
screen -dmS ore ./grypm.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:grypm]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/grypm/ && screen -dmS grypm ./grypm.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
