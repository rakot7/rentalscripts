#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
wget --continue --tries=0 https://github.com/qubic-li/hiveos/releases/download/latest/qubminer-latest.tar.gz
wget --continue --tries=0 https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
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
      "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczMjYyMzc1MCwiZXhwIjoxNzY0MTU5NzUwLCJpYXQiOjE3MzI2MjM3NTAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.b1d3qCeYtCkeue76n-QMH_KaCNxfrCooX_4w-mvfrRg6KumwMe3iO912cYeLEmO-5nlSxcUvo1JmBuQ7cE_5ftEmapPezQB1HDs-gpa6Qc7D3dHqOj6zKsBwPTiy56M4YonQkRhl3hWRVX9MWGEigmh3HROjsOJ8X2W5XH3ZHsFT43UOLFGbzJwqmMtZ9aCC4uLvlCrhpElegGIw9m-PEC0mOBcUn6CEcohv1xHauTk8O_JommqhtU_FgXiAGHtnDiPQa4ZI147XRQGhaXam4tVU72d1idC0Uyalesnfx0yHKcFsz5tmTjdrJE1YdCW5Asd-BIRMoiciHMRi2yQxhA",
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
