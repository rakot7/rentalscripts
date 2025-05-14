#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir tari
cd tari
wget https://github.com/tari-project/glytex/releases/download/v0.2.26/glytex-opencl-linux-x86_64-mainnet-0.2.26-78e833f.zip
unzip glytex-opencl-linux-x86_64-mainnet-0.2.26-78e833f.zip
chmod +x ./*
cat <<EOF > tari2.sh
#!/bin/bash
while true; do
if pgrep -f "glytex" > /dev/null; then
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  glytex is running , doing nothing"
else
        echo -e "$(date +"%Y-%m-%d %H:%M:%S")  ---  No glytex , running glytex"
        while true; do
                ./glytex --tari-node-url http://ninjaraider.com:55392 --grid-size 1024 --template-timeout-secs 5 --engine OpenCL --coinbase-extra v3,gBHAp7QDawX3nBS6LRovR54grUeM,1.0.0,J+UU1a80L+5hh5snSr7A23dRwp9gD7njuXVvO9fNY04 --p2pool-enabled
                PID=\$!
                sleep 6h
                kill \$PID
                sleep 15s;
        done;
fi
sleep 15s;
done
EOF
chmod +x ./tari2.sh
screen -dmS tari ./tari2.sh
