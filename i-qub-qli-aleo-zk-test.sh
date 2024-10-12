#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://github.com/qubic-li/hiveos/releases/download/beta/qubminer.beta-latest.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.3-fix/aleo_prover-v0.2.3_full_fix.tar.gz
tar -C qli -xf qubminer.beta-latest.tar.gz
cd qli 
cp ./qubminer.beta/* ./
rm -R ./qubminer.beta/
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
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTcyODc2ODQ4NywiZXhwIjoxNzYwMzA0NDg3LCJpYXQiOjE3Mjg3Njg0ODcsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.EEN4F__Bz0hRqHlv0u3BV2SpXPYJVKNTUa-mI7LP5Zvb0Fzz1tEDszwpLTWZmPldkH4Ca742Gi2eeW49ysqy0JBVrj3Pw4VFgWdYXEC9XwaHyW36r5OJKMTOMy-M011YAb-r4ImHmubSI6a5C39-QYmj87dEm4c99G6n-CZq2GZFPacBOWzTiLZ-ULeoUGA1BLq-eGk-_dHlYufr05ZOkKzh5OgitIqpSn4pE2C3JEqJ3EByrT4TsQnV33zTnbq0sumdfyZmNqDihsN1oSqDz2F_7LTopWd2g-cvYWqjRXP1QKdS9JzyeOqqiZt6xxYd2J_nYYL8SA357qlHvCsnMg",
    "pps": false,
    "alias": "$1",
    "trainer": {"gpu": true,"gpuVersion": "CUDA12","cpu": false},
    "idleSettings": {"command": "./aleo_prover","arguments": "--pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"}
  }
}
AutoUpdate
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
