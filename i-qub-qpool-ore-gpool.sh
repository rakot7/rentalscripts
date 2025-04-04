#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
mkdir qpool
wget https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -C qpool -xf qli-Client-2.2.1-Linux-x64.tar.gz
wget --continue --tries=0 https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool
cp /root/qub/gpool /root/qub/qpool/gpool
chmod +x /root/qub/qpool/gpool
cd qpool
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://wps.qubic.li",
    "alias": "$1",
    "trainer": {
      "cpu": false,
      "gpu": true,
      "gpuVersion": "CUDA12",
      "cpuVersion": "",
      "cpuThreads": 0
    },
    "isPps": true,
    "useLiveConnection": true,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczMjEzNjAzNSwiZXhwIjoxNzYzNjcyMDM1LCJpYXQiOjE3MzIxMzYwMzUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.XSiV-hMVN9LPLS1KoiaqA2tNy-446MP8jOCCRhY33M3Qlj0TAvhOvT3wDgEgYpqXJEhco5ZquE0BB2_batfGWJm5LqjYD1HVDSPUk83tfTmDbrQFNmXLGw134r3dIrOtRd3HoD2D5KaYzivPSalrYwVyHU6eS6ww-lZKwoU5jmetgE8OU6n3aEmPAqpt2V0EPmtNKZr88AAxN-qJ2IDxGF08AuH7IzahERByAMflZKNxjI-dTu4vxYwGvHSSFztKb1QzKmMWAAvjrS4Kh0JvqYl6DPxZY_QFKBh8OXoc25uW240dmLWz-WUZXHiTM6Hj_3ZZzXfvCrX14d5Jh0DnFA",
    "idleSettings": {
      "command": "/root/qub/qli/aleo_prover",
      "arguments": "--pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"
    }
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qpool/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
