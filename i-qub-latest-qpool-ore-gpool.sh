#!/bin/bash
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
#wget --continue --tries=0 https://github.com/qubic-li/hiveos/releases/download/latest/qubminer-latest.tar.gz
wget --continue --tries=0 https://dl.qubic.li/downloads/qli-Client-3.1.1-Linux-x64.tar.gz
tar -C ./qpool/ -xf qli-Client-3.1.1-Linux-x64.tar.gz
wget --continue --tries=0 https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool
cp /root/qub/gpool /root/qub/qpool/gpool
chmod +x /root/qub/qpool/gpool
cd qpool 
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
      "command": "./gpool",
      "arguments": "--pubkey Ao6eDhKg24gVBjFxxWpBB6yJJQXEQ4S4uSYbkz9zPfAt --worker $1 ",
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
