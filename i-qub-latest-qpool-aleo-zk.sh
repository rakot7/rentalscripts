#!/bin/bash
pkill -f 'ore.sh'
pkill -f 'run.sh'
pkill -f 'apoolminer'
pkill -f 'aleo_prover'
pkill -f 'gpool'
pkill -f 'qli-Client'
apt update -y 
apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
mkdir qpool
wget --continue --tries=0 https://dl.qubic.li/downloads/qli-Client-3.2.0-Linux-x64.tar.gz
wget --continue --tries=0 https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix2/aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz
tar -C ./qpool/ -xf qli-Client-3.2.0-Linux-x64.tar.gz
tar -xf aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qpool/aleo_prover
rm -R aleo_prover
cd qpool 
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
    "poolAddress": "wss://wps.qubic.li/ws",
    "alias": "$1",
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczNzQwNzU2NSwiZXhwIjoxNzY4OTQzNTY1LCJpYXQiOjE3Mzc0MDc1NjUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.mp5eY6HZPxasbyyKSEDv8Ye-F7DP1Xt6WlCGhPVWdauqpqPLQD4GIURhc42sFF6xA5_lNkppH9v0p3lGrthmCc8CAi3DnvQiiBrUZFFXxFy1pKPLeNQcbqPQPWBX7hxSf51zX4Rqvqz1cSmYfI2LT1RZeNZQ3w7Yo3t3hqFRy1EoxkJB4mgY3_efJZrj8HagnwDpQ5a2dxBTHcF4RoEZ0jM6ggUmncIRnQihcvkMLMut-eVTVY0pvpJVTelaS0ovvnXdd86Mf7_4GYyWAyXegFfZSd1GW0Joa88g5idJqpYed1HbTs3t80tWHb2QFV0f82kBkX6hENsgo-79qyLZWQ",
    "qubicAddress": null,
    "displayDetailedHashrates": true,
    "trainer": {
      "cpu": false,
      "gpu": true
    },
     "Idling": {
      "gpuOnly": true,
      "command": "./aleo_prover",
      "arguments": "--pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1",
      "preCommand": null,
      "preCommandArguments": null,
      "postCommand": null,
      "postCommandArguments": null
    }
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qpool/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
