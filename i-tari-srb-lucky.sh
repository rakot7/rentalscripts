#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir tari
cd tari
wget --continue --tries=0 https://github.com/doktor83/SRBMiner-Multi/releases/download/2.8.8/SRBMiner-Multi-2-8-8-Linux.tar.gz
tar -xf SRBMiner-Multi-2-8-8-Linux.tar.gz
cd SRBMiner-Multi-2-8-8
cat <<EOF > tari.sh
#!/bin/bash
while true; do
	./SRBMiner-MULTI --algorithm sha3x --pool de-eu.luckypool.io:6118,pl-eu.luckypool.io:6118,sg.luckypool.io:6118,ca.luckypool.io:6118 --wallet 122FazuS26C89B8eLvsjPTTFYxYvX7XNs8YUN4tvbvZBHJmY2Lz2v5cCWcxi5Y97thGPqEhXdL3cAaQ99LwjSMJmxsy.$1
        sleep 15s;
done;
EOF
chmod +x ./tari.sh
screen -dmS tari ./tari.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:tari]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/tari/SRBMiner-Multi-2-8-8 && screen -dmS tari ./tari.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
