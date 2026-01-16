#!/bin/bash
cd /hive/miners/custom/xntprover/ 
wget --continue --tries=0 https://github.com/voodoo-vecno/vecnopool-de-miner/releases/latest/download/vecnominer-de-latest.tar.gz
tar -xf vecnominer-de-latest.tar.gz
mv onezerominer onezerominer.orig
mv vecnominer-de/vecno-miner-cuda ./onezerominer
mv h-run.sh h-run.sh.orig
cat <<EOF > h-run.sh
#!/bin/bash

source h-manifest.conf
APPNMAE=\$CUSTOM_NAME
APP_PATH=.\$APPNMAE

pkill -9 \$APPNMAE


./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname) -m 1 -g 0,1,2,3,4 --extra 'onezerominer;-a;vecno:qpj3f0tzvwdgw3r5ute43j9j7lrukg0rzw0mwfv8lptq7qxfgs7k7l3g8uthy;--stratum-worker;$(hostname)' >> /hive/miners/custom/xntprover/xntprover.log 2>&1
echo "./xntprover -p stratum+tcp://xnt.drpool.io:30120 -w kotklgd.$(hostname) -m 1 -g 0,1,2,3,4 --extra 'onezerominer;-a;vecno:qpj3f0tzvwdgw3r5ute43j9j7lrukg0rzw0mwfv8lptq7qxfgs7k7l3g8uthy;--stratum-worker;$(hostname)' >> /hive/miners/custom/xntprover/xntprover.log 2>&1"
EOF
chmod +x ./h-run.sh 
