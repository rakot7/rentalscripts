#!/bin/bash
cd ~
mkdir rin
cd rin
wget --continue --tries=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/2.8.5/SRBMiner-Multi-2-8-5-Linux.tar.gz
tar -xf SRBMiner-Multi-2-8-5-Linux.tar.gz
cd SRBMiner-Multi-2-8-5 	
cat <<EOF > rin_rplant.sh
#!/bin/bash
reset

./SRBMiner-MULTI --algorithm rinhash --pool stratum+tcps://stratum-eu.rplant.xyz:17148 --wallet rin1qkun6rfkydm5c04q2wqwns4w5lgv7a9fk0ng2fu.$1 --password x --cpu-threads 14 --disable-gpu --log-file ./Logs/log-rin.txt
EOF
chmod +x ./rin_rplant.sh
screen -dmS rin ./rin_rplant.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:rin]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/rin/SRBMiner-Multi-2-8-5 && screen -dmS rin ./rin_rplant.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
