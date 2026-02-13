#!/bin/bash
cd /hive/miners/custom/nptprover/ 
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.4/onezerominer-linux-1.7.4.tar.gz
tar -xf onezerominer-linux-1.7.4.tar.gz
cp ./onezerominer-linux/onezerominer ./
mv h-run.sh h-run.sh.orig
cat <<EOF > h-run.sh
#!/bin/bash

source h-manifest.conf
APPNMAE=\$CUSTOM_NAME
APP_PATH=.\$APPNMAE

pkill -9 \$APPNMAE


./nptprover -p stratum+tcp://neptune.drpool.io:30127 -w kotklgd.$(hostname) -m 2 -g 0,1,2 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610' >> /hive/miners/custom/nptprover/nptprover.log 2>&1
echo "./nptprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname) -m 2 -g 0,1,2 --extra 'onezerominer;-a;qhash;-w;bc1qg4vaek7aqu9jkf0c7epf6lm6wsf8z5c0x9rz22.$(hostname);-o;stratum+tcp://qubitcoin.luckypool.io:8610' >> /hive/miners/custom/nptprover/nptprover.log 2>&1"
EOF
chmod +x ./h-run.sh 
