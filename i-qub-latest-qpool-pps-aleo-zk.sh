#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
mkdir qli
wget https://github.com/qubic-li/hiveos/releases/download/beta/qubminer.beta-latest.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.4/aleo_prover-v0.2.4_cuda_full.tar.gz
tar -C qli -xf qubminer.beta-latest.tar.gz
cp ./qli/qubminer.beta/* ./qli/
tar -xf aleo_prover-v0.2.4_cuda_full.tar.gz aleo_prover/aleo_prover
cp ./aleo_prover/aleo_prover ./qli/aleo_prover
rm -R aleo_prover
rm -R ./qli/qubminer.beta
cd qli
rm appsettings.json
cat <<EOF > appsettings.json
{
  "Settings": {
    "baseUrl": "https://wps.qubic.li",
    "alias": "$1",
    "trainer": {
      "cpu": true,
      "gpu": true,
      "gpuVersion": "CUDA12",
      "cpuVersion": "avx512",
      "cpuThreads": 0
    },
    "isPps": false,
    "useLiveConnection": true,
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY5MTJkOTEwLWRiNDAtNDZmMS04MmI2LTY4OTc5MDQ3ODJmZCIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNzU2MTYxMSwiZXhwIjoxNzU5MDk3NjExLCJpYXQiOjE3Mjc1NjE2MTEsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.GtVw1cTrW7_D7EDOyebbtuHo0Xdpy93ZP0S_6aSswVN0BmSiwHCNA9-s2qSottV_RWpAysz_yrHks5iWcuN3yOsbvpMZwWA44HelEdV7dtSUmbaO6tsZtVVmrNL_MCDcFaYVlVjp4nLccJtmUnYfidYsjZog0apFj4t-Ub7HdB313iCoohNRBiFmoGKQg6pSp4xQtTKfI9i6oGJXEVhZyYV_KHCCA2mBL6e5-KhtyuSh6-t0GRrhy_wro5FcdkAZq1si6O_-R86SedVE3O1u64gQPRJbIzPzgimY9yZ56bZYh5StCDJMENU79KkRT3ErL_PsIJ612Bou5HIQg-KHbA",
    "idleSettings": {
      "command": "/root/qub/qli/aleo_prover",
      "arguments": "--pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"
    }
  }
}
EOF
chmod +x ./qli-Client
screen -dmS qub ./qli-Client
echo "" >> /etc/supervisor/conf.d/supervisord.conf
echo "[program:qub]" >> /etc/supervisor/conf.d/supervisord.conf
echo "command=/bin/bash -c 'cd /root/qub/qli/ && screen -dmS qub ./qli-Client && sleep infinity'" >> /etc/supervisor/conf.d/supervisord.conf
