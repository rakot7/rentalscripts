#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer-3.0.4.tar.gz
tar -C qli -xf qli-Client-2.2.1-Linux-x64.tar.gz
tar -xf aleominer-3.0.4.tar.gz aleominer/aleominer
cp ./aleominer/aleominer ./qli/aleominer
cd qli
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "amountOfThreads": 0,
    "payoutId": null,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjI1MDE4NiwiZXhwIjoxNzU3Nzg2MTg2LCJpYXQiOjE3MjYyNTAxODYsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.RjjAsctutwCdXsp_gsgBpt7EMyq5y4HZbcpe-ngdwodEI-BC0NKZdmL5HPvCd4-GKZlQwy3KX2xvZRB9aDVQNdMdSRX3-Bg3p1-oUuCLHz863cIYdXRg3Aqx5dVonVSLrsJsiUmtwdWpvEzMASwfjQeILr3w1TgUYxYdUnoBwdDp9Ex43MVDOuGnd2l5RaIc4F3p1iLo833fHmiBj-IZjWz7LHgBbCOKIKk2emqeXXex2Q_oZNMXVQm8R_DAOv-gZJxlBinZZ1LLPnVyllxNM10z5exztCKrR7-glhxmhxfLZIV1OdPw-HZ9DIv5mw21RTyjqMH_sZp48MQqkOU8aA",
    "alias": "$1",
    "trainer": {"gpu": true,"gpuVersion": "CUDA12","cpu": false},
    "idleSettings": {"command": "./aleominer","arguments": "-u stratum+tcp://aleo-asia.f2pool.com:4400 -w golden0707.$1"}
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
