#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
wget https://github.com/qubic-li/hiveos/releases/download/beta/qubminer.beta-latest.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5-hotfix/aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz
tar -xf qubminer.beta-latest.tar.gz
tar -xf aleo_prover-v0.2.5_cuda_full_hotfix.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qubminer.beta/aleo_prover
rm -R aleo_prover
cd qubminer.beta 
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
      "poolAddress": "wss://wps.qubic.li/ws",
      "alias": "$1",
      "trainer":{"cpu":false,"gpu":true},
      "pps":true,
      "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTczMDk4OTI5NSwiZXhwIjoxNzYyNTI1Mjk1LCJpYXQiOjE3MzA5ODkyOTUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.NE1NAUKP11sUJtpigTBEnWNlFfovMYWTwysPbV1fL0wVexUmyDlPUMYugoQJj8d0g5luYgviCPnx3IS01DYzrqKh7j8FEQ5kYt1AblgXJtKFA8Z7hfw8_sc4JIA62fjdv7MVPJmdPoY3i2ang7gvIOBWvG32mj8Avtm32MKMrZfB0yKFX1QDpHBXvnsLtSszPbWz5kFFgO_mAk5qs7p4u7AgNqkSbF4-_S2JzFpo_5XIGOm-_609ifnz14EOlU41j3utUyl09xD394inJAGDPY8oLsuYhwfyDDA8tbSfyEwb2ck1qHlE5gM86uSWlceyTpLHwDB9BsQdCTPtylNaaQ",
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
