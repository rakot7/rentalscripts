#!/bin/bash
cd ~
mkdir wala
cd wala
wget --continue --tries=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/2.7.4/SRBMiner-Multi-2-7-4-Linux.tar.gz
tar -xf SRBMiner-Multi-2-7-4-Linux.tar.gz
cd SRBMiner-Multi-2-7-4
cat <<EOF > wala.sh
#!/bin/bash
while true; do
if pgrep -f "gpool" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  srbminer is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No srbminer , running srbminer"
        while true; do
		./SRBMiner-MULTI --algorithm walahash --pool keeneticinternac5.keenetic.link:55555 --wallet waglayla:qqx0hxqwzck65e0mt9mxrl3kvm9s8fhpth0ak2rpatkjakksv3kuxykhlrggr --password x --cpu-threads -1 --log-file ./Logs/log-wala.txt --worker $1 &
                sleep 1h
                kill \$PID
                sleep 15s;
        done;
fi
done
EOF
chmod +x ./wala.sh
screen -dmS wala ./wala.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:wala]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/wala/SRBMiner-Multi-2-7-4/ && screen -dmS wala ./wala.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
