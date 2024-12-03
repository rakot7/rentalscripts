#!/bin/bash
cd ~
mkdir phi
cd phi
wget --continue --tries=0 https://github.com/andru-kun/wildrig-multi/releases/download/0.41.5/wildrig-multi-linux-0.41.5.tar.xz
tar -xf wildrig-multi-linux-0.41.5.tar.xz
cat <<EOF > phi.sh
#!/bin/bash
while true; do
if pgrep -f "wildrig-multi" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  wildrig-multi is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No wildrig-multi , running wildrig-multi"
        ./wildrig-multi -a phihash  -o stratum+tcps://stratum-eu.rplant.xyz:17134 -u PZMm2W83TncQr65QfkE2cDWm5V3wRmc3NU -p m=solo
fi
done
EOF
chmod +x ./phi.sh
screen -dmS ore ./phi.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:phi]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/phi/ && screen -dmS phi ./phi.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
