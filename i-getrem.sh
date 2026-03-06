#===================================================================
#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping wget bc
apt install sudo -y
apt install python3.12-venv -y
python3.12 -m venv ~/venv
apt update
apt install build-essential python3-dev -y
#==========================================
cd ~
mkdir dvm
cd dvm
wget --continue --tries=0 https://github.com/user-attachments/files/25696133/dvm-miner-linux-x64-v1.2.1.zip
unzip dvm-miner-linux-x64-v1.2.1.zip
cd dvm-miner-linux-x64-v1.2.0
chmod +x ./start.sh
#============================
TOTAL_MEM_MIB=$(free -m | grep Mem: | awk '{print $2}')
RAM_GB=$(expr $TOTAL_MEM_MIB / 1024 )
RAM_GB_BY2=$(expr $RAM_GB / 2 )
power=$(echo "l($RAM_GB_BY2) / l(2)" | bc -l)
TOUSE_RAM=$(echo "2^$(printf "%.0f" $power)" | bc)
#======================================
export T_RAM=$TOUSE_RAM && screen -dmS dvm bash -c 'printf "$T_RAM\n0x0a866fa021b9145001bb8c24f40b64fd9af33be77d91dff91a45e609446442c8\nd48f8023-cf8f-48a9-bb6a-e073071df4d0" | ./start.sh'
