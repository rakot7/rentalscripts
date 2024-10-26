#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.3-fix/aleo_prover-v0.2.3_full_fix.tar.gz
tar -C qli -xf qli-Client-2.2.1-Linux-x64.tar.gz
tar -xf aleo_prover-v0.2.3_full_fix.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qli/aleo_prover
rm -R aleo_prover
cd qli
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "amountOfThreads": 0,
    "payoutId": null,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTcyOTk1NDI1MiwiZXhwIjoxNzYxNDkwMjUyLCJpYXQiOjE3Mjk5NTQyNTIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.U7G2c0E5Vdc7I5fEwq7gzGvK2aF4FUkltNU3S6BUuv_aF9Gf3kCqQBGsO5GZihbKeZG_Jssv_mldLhI44TBDD1oxP0jbXqLESfbbC4Qw8ihNNF6WxoKDhA6CrUSXcoT_PWB24bXtuOGbWuWCnM4M-bU2ZbwnAUpwrL1BVxd-1gI88iajCxcBJN_WP6ARAjjSN_Ih42OCZ1yOF0bcu-kU0t1GdtkYQEuk3gMmFXJkZo6xobD1jMjO3Pfq0ubM1KIzGUfE6GuXRxYLLph1z1S6W_6avTizSsoJhPL98ZsNBOEjOACou1qp7DA3m7GvyPrguyqF5p2H-G0E1FtfRnAvhA",
    "alias": "$1",
    "trainer": {"gpu": true,"gpuVersion": "CUDA12","cpu": false},
    "idleSettings": {"command": "./aleo_prover","arguments": "--pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"}
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
