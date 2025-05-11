#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install -y libc6
apt install -y g++-11
cd ~
mkdir qub
cd qub
mkdir qlab
wget --continue --tries=0 https://poolsolution.s3.eu-west-2.amazonaws.com/QLAB.XA.tar.gz
wget --continue --tries=0 https://github.com/tari-project/glytex/releases/download/v0.2.26/glytex-opencl-linux-x86_64-mainnet-0.2.26-78e833f.zip
tar -C qlab -xf QLAB.XA.tar.gz
unzip glytex-opencl-linux-x86_64-mainnet-0.2.26-78e833f.zip
cp ./glytex/* qlab/QLAB.XA
cd qlab/QLAB.XA
rm appsettings.json
cat <<EOF > appsettings.json
{
  "ClientSettings": {
    "poolAddress": "wss://pps.minerlab.io/ws/kotklgd",
    "alias": "$1",
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImQzNzMyODc2LTY5ZDctNGI1OC1hNmUzLWM2MzZkMGQ4ZDE0NiIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNTM3NjkyOSwiZXhwIjoxNzU2OTEyOTI5LCJpYXQiOjE3MjUzNzY5MjksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.sregOyk2PEyXv8ssdQDBtTps1JFBLghcJCzDFvaD6hWoVA_T-crfQZbiV0E_atqd6sxNHYKGmeVCOoU9crLU4mnojZdF1vyp3VttB3ZIqo3qIgr0R4jWnwZ95bGN1c6NE3zb9y7ZWor5-4ttLkR_5moxiZZvaKG2WWSxFJ-7kk6SVSw7z8iaYyVpPX1Tdu6pBWxDStYYaoVvgNzx6RShU_r2AVCB1JGfv16vKvAIGmPcluvS-ayKwfgOpY1uEbsH6Lswd_KGbB1aJC7g8AI1CUoYiUUl_CJUBZfG0FbBgtGDRhfPUcYM5z8BEyIrm6bfKhMHuJmIF86NJYydRUHgow",
    "qubicAddress": null,
    "displayDetailedHashrates": true,
    "trainer": {
      "cpu": true,
      "gpu": true
    },
    "pps":true,
    "Idling": {
      "gpuOnly": true,
      "command": "./glytex",
      "arguments": "--engine opencl --tari-node-url http://ninjaraider.com:55392 --grid-size 128 --tari-address 122FazuS26C89B8eLvsjPTTFYxYvX7XNs8YUN4tvbvZBHJmY2Lz2v5cCWcxi5Y97thGPqEhXdL3cAaQ99LwjSMJmxsy --coinbase-extra tari-universe --p2pool-enabled",
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
echo "command=/bin/bash -c 'cd /root/qub/qlab/QLAB.Xminer/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
