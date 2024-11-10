#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.4/aleo_prover-v0.2.4_cuda_full.tar.gz
tar -C qli -xf qli-Client-2.2.1-Linux-x64.tar.gz
tar -xf aleo_prover-v0.2.4_cuda_full.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qli/aleo_prover
rm -R aleo_prover
cd qli
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://wps.qubic.li/",
    "amountOfThreads": 0,
    "payoutId": null,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczMTIyNjAzNiwiZXhwIjoxNzYyNzYyMDM2LCJpYXQiOjE3MzEyMjYwMzYsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.RUhyNysvMNGd3agNfBtN5iVVmvbA2Cx9nEKv6WK5rNJFeW9WYAkxTbvN2RXN0F8bMmX7k6HC515UXyge9XbrrGvt-d0oPhGlZh7HHBKPCSAHmoK-LtTkJNCLYSV6vIhOUvH3xEthWg6Y313Ljx24qDGzmQF_DwF-77ETkbYYoWvDRbyjS8Zg3dEReEM7_S6lx7_SJqnYhJljDZ7CyVzHoPc_YRCMffdUbqlJH0JOwcanK5h8ibcIo0_pJ2Ep2frG36aVNmgFuiCQW-Oa_RyiZcEdTxsxbQc-tgucADxmpQK-_eviXRVukVCwstjfSroPsNfhZKM2fvPTZszqCQcrgA",
    "alias": "$1",
    "trainer": {"gpu": true,"gpuVersion": "CUDA12","cpu": false},
    "idleSettings": {"command": "./aleo_prover","arguments": "--pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"}
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
