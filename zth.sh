#!/bin/bash

#################################
## Begin of user-editable part ##
#################################

pool=ru.e4pool.com:15108
wallet=0xE84079aF0d1b255a6F3392C12e247259858cD4d5.$1

#################################
##  End of user-editable part  ##
#################################


./lolMiner --algo ETHASH --pool $POOL --user $WALLET $@
while [ $? -eq 42 ]; do
    sleep 10s
    ./lolMiner --algo ETHASH --pool $POOL --user $WALLET $@
done
