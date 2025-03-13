#!/bin/bash
cd ~
mkdir quai
cd quai
wget --continue --tries=0 https://github.com/rigelminer/rigel/releases/download/1.21.2/rigel-1.21.2-linux.tar.gz
tar -xf rigel-1.21.2-linux.tar.gz
cd rigel-1.21.2-linux
rm quai.sh
cat <<EOF > quai.sh
#!/bin/bash
./rigel -a quai -o stratum+tcp://eu.quai.k1pool.com:3333 -u KrTNcwsTe9exc7z9PBbThE533vEJzpfjDGb -w $1
EOF
chmod +x ./quai.sh
screen -dmS quai ./quai.sh
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:quai]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/quai/rigel-1.21.2-linux && screen -dmS quai ./quai.sh && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
