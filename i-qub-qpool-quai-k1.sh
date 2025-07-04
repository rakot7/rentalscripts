#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget --continue --tries=0 https://dl.qubic.li/downloads/qli-Client-3.3.8-Linux-x64.tar.gz
wget --continue --tries=0 https://github.com/rigelminer/rigel/releases/download/1.22.1/rigel-1.22.1-linux.tar.gz
tar -C qli -xf qli-Client-3.3.8-Linux-x64.tar.gz
tar -C qli -xf rigel-1.22.1-linux.tar.gz
cd qli 
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
    "poolAddress": "wss://wps.qubic.li/ws",
    "alias": "$(hostname)",
    "trainer": {
      "cpu": false,
      "gpu": true,
      "gpuVersion": "CUDA",
      "cpuVersion": "",
      "cpuThreads": 0
    },
    "pps": true,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTc1MTAzOTIwMywiZXhwIjoxNzgyNTc1MjAzLCJpYXQiOjE3NTEwMzkyMDMsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.aXwbnoJqiGe1R9Mf5MzejSxwSGNLI3EEnHsl3mBJqGzk5Civ92eMGxy--P4jy9orVgiaoCZmKdIj_B1akNrLV83hR_X4UR57A8eQwMq4kLV8RQesJpMd49Py6l66nI9OMWkf8JvDdEr337AaTMP15D_ME-gWWqIzm_mJxEUf0CbMpZiT_Xf-cM3kUbrN4Ffy-X948KAzLsIQY4w9BZBeqS0DprPcVmixOUXd8TyIFT3tbXSXi-mP_iDTW_7lm1w5h0YMmwgZUrLUZU47Z9i9A4zzCSzxxqEZG3ulgI0nf6jSTpmqzV_qEuRTHH7MmKvTUaLgbEau1eHjyIABUWVm3Q",
    "qubicAddress": null,
    "idling": {
      "command": "./rigel",
      "arguments": "./rigel -a quai -o stratum+tcp://eu.quai.k1pool.com:3333 -u KrTNcwsTe9exc7z9PBbThE533vEJzpfjDGb -w $(hostname)"
    }
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
