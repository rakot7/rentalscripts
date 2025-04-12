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
wget --continue --tries=0 https://poolsolution.s3.eu-west-2.amazonaws.com/QLAB.Xminer-latest.tar.gz
tar -C qlab -xf QLAB.Xminer-latest.tar.gz
cp /root/qub/qlab/QLAB.Xminer/* /root/qub/qlab/
rm -R QLAB.Xminer
wget --continue --tries=0 https://github.com/gpool-cloud/gpool-cli/releases/download/v2025.15.1/gpool
cp /root/qub/gpool /root/qub/qlab/gpool
chmod +x /root/qub/qlab/gpool
cd qlab
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
      "command": "./gpool",
      "arguments": "--pubkey Ao6eDhKg24gVBjFxxWpBB6yJJQXEQ4S4uSYbkz9zPfAt --worker $1 --pool 78.47.222.171:10475",
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
