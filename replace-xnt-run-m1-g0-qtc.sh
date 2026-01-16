#!/bin/bash
cd /hive/miners/custom/xntprover/ 
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.3/onezerominer-linux-1.7.3.tar.gz
tar -xf onezerominer-linux-1.7.3.tar.gz
cp ./onezerominer-linux/onezerominer ./onezerominer
mv h-run.sh h-run.sh.orig
cat <<EOF > h-run.sh
#!/bin/bash

source h-manifest.conf
source \$CUSTOM_CONFIG_FILENAME
APPNMAE=\$CUSTOM_NAME
APP_PATH=.\$APPNMAE

pkill -9 \$APPNMAE


./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname) -m 1 -g 0 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610' >>\${CUSTOM_LOG_BASENAME}.log 2>&1
echo "./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname) -m 1 -g 0 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610' >> \${CUSTOM_LOG_BASENAME}.log 2>&1"
EOF
chmod +x ./h-run.sh 
