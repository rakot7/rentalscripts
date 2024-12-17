#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir wart
cd wart
wget --continue --tries=0 https://github.com/bzminer/bzminer/releases/download/v21.5.3/bzminer_v21.5.3_linux.tar.gz
tar -xf bzminer_v21.5.3_linux.tar.gz
cd bzminer_v21.5.3_linux
cat <<EOF > wart.sh
#!/bin/bash
while true; do
if pgrep -f "bzminer" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  bzminer is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No bzminer , running bzminer"
        ./bzminer -a warthog -p stratum+tcp://de.warthog.herominers.com:1143 -w 7312ede2edc7855873b3bb5acc6e13a80a1c1c3b1f22ddb9.$1 --nc 1 
pause
fi
done
EOF
chmod +x ./wart.sh
screen -dmS wart ./wart.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:wart]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/wart/bzminer_v21.5.3_linux/ && screen -dmS wart ./wart.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
