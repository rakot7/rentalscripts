#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir grypm
cd grypm
wget --continue --tries=0 https://github.com/andru-kun/wildrig-multi/releases/download/0.41.5/wildrig-multi-linux-0.41.5.tar.xz
tar -xf wildrig-multi-linux-0.41.5.tar.xz
cat <<EOF > grypm.sh

#!/bin/bash
while true; do
if pgrep -f "wildrig-multi" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  wildrig-multi is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No wildrig-multi , running wildrig-multi"
        ./wildrig-multi -a memehash  -o stratum+tcps://stratum-eu.rplant.xyz:17074 -u Gcm9XtNr8mGmcS123atzkhAHjEgtNMzbHa.$1
fi
done
EOF
chmod +x ./grypm.sh
screen -dmS ore ./grypm.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:grypm]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/grypm/ && screen -dmS grypm ./grypm.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
