#!/bin/bash
cd ~
mkdir quai
cd quai
wget --continue --tries=0 https://github.com/rigelminer/rigel/releases/download/1.21.2/rigel-1.21.2-linux.tar.gz
tar -xf rigel-1.21.2-linux.tar.gz
cd rigel-1.21.2-linux
rm quai.sh
cat <<EOF > quai-rigel-hm.sh
#!/bin/bash

./rigel -a quai -o stratum+tcp://de.quai.herominers.com:1185 -u 0x006488D627194903F50B515c4F21762C378fa04B -w $1 --log-file logs/miner.log

EOF
chmod +x ./quai-rigel-hm.sh
screen -dmS quai ./quai-rigel-hm.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:quai]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/quai/rigel-1.21.2-linux && screen -dmS quai ./quai-rigel-hm.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
