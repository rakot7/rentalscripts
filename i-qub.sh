#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
wget https://github.com/rigelminer/rigel/releases/download/1.19.0/rigel-1.19.0-linux.tar.gz
tar -C qli -xf qli-Client-2.2.1-Linux-x64.tar.gz
tar -xf rigel-1.19.0-linux.tar.gz rigel-1.19.0-linux/rigel
cp ./rigel-1.19.0-linux/rigel ./qli/rigel
cd qli
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "amountOfThreads": 0,
    "payoutId": null,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjI1MDE4NiwiZXhwIjoxNzU3Nzg2MTg2LCJpYXQiOjE3MjYyNTAxODYsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.RjjAsctutwCdXsp_gsgBpt7EMyq5y4HZbcpe-ngdwodEI-BC0NKZdmL5HPvCd4-GKZlQwy3KX2xvZRB9aDVQNdMdSRX3-Bg3p1-oUuCLHz863cIYdXRg3Aqx5dVonVSLrsJsiUmtwdWpvEzMASwfjQeILr3w1TgUYxYdUnoBwdDp9Ex43MVDOuGnd2l5RaIc4F3p1iLo833fHmiBj-IZjWz7LHgBbCOKIKk2emqeXXex2Q_oZNMXVQm8R_DAOv-gZJxlBinZZ1LLPnVyllxNM10z5exztCKrR7-glhxmhxfLZIV1OdPw-HZ9DIv5mw21RTyjqMH_sZp48MQqkOU8aA",
    "alias": "%WORKER_NAME%",
    "trainer": {"gpu": true,"gpuVersion": "CUDA12","cpu": false},
    "idleSettings": {"command": "./rigel","arguments": "-a karlsenhashv2+pyrinhashv2+zil -o [1]stratum+tcp://ru.karlsen.herominers.com:1195 -u [1]karlsen:qqltw3p2cprratlfwxh4edf5txz7m7ungewhqf9fm39h4trpf9mrsv9ch6ge4 -o [2]stratum+tcp://ru.pyrin.herominers.com:1177 -u [2]pyrin:qzu9380zhth8wu37d7zjazv2xfnrv67p2m9t5eden03wgnvaf7kn7un0kfufx -o [3]stratum+tcp://eu.zil.k1pool.com:1111 -u [3]KrTNcwsTe9exc7z9PBbThE533vEJzpfjDGb --zil-countdown -w %WORKER_NAME%"}
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
