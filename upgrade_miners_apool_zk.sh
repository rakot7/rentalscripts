#!/bin/bash
cd /root/qub/
rm apoolminer_linux_autoupdate_v2.6*
rm leo_prover-v0.2.5.*
wget https://github.com/apool-io/apoolminer/releases/download/v2.6.6/apoolminer_linux_autoupdate_v2.6.6.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.5/aleo_prover-v0.2.5_cuda_full.tar.gz
tar -xf apoolminer_linux_autoupdate_v2.6.6.tar.gz
tar -xf aleo_prover-v0.2.5_cuda_full.tar.gz aleo_prover/aleo_prover
rm ./ap/aleo_prover
rm ./ap/apoolminer
pkill -f 'run.sh'
pkill -f 'apoolminer'
pkill -f 'aleo_prover'
cp ./aleo_prover/aleo_prover ./ap/
cp ./apoolminer_linux_autoupdate_v2.6.6/apoolminer ./ap/
rm -R apoolminer_linux_autoupdate_v2.6.6
rm -R aleo_prover
cd ap
screen -dmS qub ./run.sh
screen -r
