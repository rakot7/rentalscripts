#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
wget https://github.com/qubic-li/hiveos/releases/download/latest/qubminer-latest.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
tar -xf qubminer-latest.tar.gz
tar -xf aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qubminer/aleo_prover
rm -R aleo_prover
cd qubminer 
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
      "poolAddress": "wss://wps.qubic.li/ws",
      "alias": "$1",
      "trainer":{"cpu":false,"gpu":true},
      "pps":true,
      "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczMjMwMzk0OSwiZXhwIjoxNzYzODM5OTQ5LCJpYXQiOjE3MzIzMDM5NDksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.fv9KJY4_z4mvSmbXZvWSBV-US7ZTeuRRqu2--_sNZintfgtFhmQoWS235OqY9Z5N0W_b-fEaNZNXWO1SIfT1nC7X76fHija5JJZH6d0j9ZK9pcmD6JOBvcU2udFkH3awD0rUaU31QGPFab8R8Z69pu-Gpg_n_mE4UkZWzIHV8gh4YRE09_aWmoWS-UOKht5HMmX50_lBjdMHYI70E4NfCdoENv34JAvcfm6cfP7Qz_Mh3vlzklV4Z3uPYayn8rDyVDO0bomCU2SHm_-j17Xcd7wb3vaDl_oPklAEHXcz7XCBYxFC-neAe6C1n3Y0O_M3XIjbzE1U2vg-GRaSdNyDMQ",
      "qubicAddress": null,
      "displayDetailedHashrates": true,
      "idling":{"command":"./aleo_prover","arguments":"--pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"}

  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
