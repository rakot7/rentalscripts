#!/bin/bash
cd /hive/miners/custom/xntprover/ 
wget --continue --tries=0 https://github.com/OneZeroMiner/onezerominer/releases/download/v1.7.3/onezerominer-linux-1.7.3.tar.gz
tar -xf onezerominer-linux-1.7.3.tar.gz
cp ./onezerominer-linux/onezerominer ./onezerominer
mv h-run.sh h-run.sh.orig
cat <<EOF > h-run.sh
#!/bin/bash

source h-manifest.conf
source $CUSTOM_CONFIG_FILENAME
APPNMAE=$CUSTOM_NAME
APP_PATH=.$APPNMAE

pkill -9 $APPNMAE


./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname)  -m 1 -g 0 --extra 'onezerominer;-a;vecno:qpj3f0tzvwdgw3r5ute43j9j7lrukg0rzw0mwfv8lptq7qxfgs7k7l3g8uthy;--stratum-worker;$(hostname)' >>${CUSTOM_LOG_BASENAME}.log 2>&1
echo "./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname)  -m 1 -g 0 --extra 'onezerominer;-a;vecno:qpj3f0tzvwdgw3r5ute43j9j7lrukg0rzw0mwfv8lptq7qxfgs7k7l3g8uthy;--stratum-worker;$(hostname)' >> ${CUSTOM_LOG_BASENAME}.log 2>&1"
EOF
chmod +x ./h-run.sh 
