#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
#wget --continue --tries=0 https://github.com/qubic-li/hiveos/releases/download/latest/qubminer-latest.tar.gz
wget --continue --tries=0 https://dl.qubic.li/downloads/qli-Client-3.1.1-Linux-x64.tar.gz
wget --continue --tries=0 https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix2/aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz
mkdir qubminer 
tar -C ./qubminer/ -xf qli-Client-3.1.1-Linux-x64.tar.gz
tar -xf aleo_prover-v0.2.5_cuda_full_hotfix2.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qubminer/aleo_prover
rm -R aleo_prover
cd qubminer 
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
    "poolAddress": "wss://wps.qubic.li/ws",
    "alias": "$1",
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczNDEyNTU1MiwiZXhwIjoxNzY1NjYxNTUyLCJpYXQiOjE3MzQxMjU1NTIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.qrMZvd7wEn-DzzCGb2zmERd71GOUY6Ef5s9qV_mtw-F-3mO2IEFwgbToMd6sUligK4-XQvK0U6tno0_nxpv0B-7C0DowrIsjU5OZ_EyHDpxZZvXdJwhpqTQ6n7QNCNL_uAMi0aJ4JEmvrepzvIJ8956Y249BnUKOHTxMySXvqhEMTouAIPd23W4rI8OveA_fgFAbiXUogiRrXvSwD_kJ4ETM9gaRxnM0oWTFaDl-GgrY17-pBrxbUWV5CUpFdEjHVObIirt7usd9RjUC7CFWazQWrq8j_r2WqSms5Y-QRaLjHMsjDC2dParAWGqhjn09sDB-unV4613Nwb6fkQqnmQ",
    "qubicAddress": null,
    "displayDetailedHashrates": true,
    "trainer": {
      "cpu": false,
      "gpu": true
    },
    "Idling": {
      "gpuOnly": true,
      "command": "./aleo_prover",
      "arguments": "--pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1 ",
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
echo "command=/bin/bash -c 'cd /root/qub/qubminer/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
