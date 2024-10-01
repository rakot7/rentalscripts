#!/bin/bash
apt update -y && apt install -y screen git curl cron nano mc htop iputils-ping
cd ~
mkdir qub
cd qub
wget https://github.com/apool-io/apoolminer/releases/download/v2.2.2/apoolminer_linux_autoupdate_v2.2.2.tar.gz
wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.3/aleo_prover-v0.2.3_full.tar.gz
mkdir ap
tar -xf /apoolminer_linux_autoupdate_v2.2.2.tar.gz
tar -xf aleo_prover-v0.2.3_full.tar.gz aleo_prover/aleo_prover
cp ./apoolminer_linux_autoupdate_v2.2.2/* ./ap/
rm -R apoolminer_linux_autoupdate_v2.2.2
rm -R aleo_prover
cd ap
rm miner.conf
rm run.sh
cd ..
cd ap
cat <<EOF > run.sh
#!/bin/bash

MINER_CONF="./miner.conf"

parse_conf() {
    local file=$1
    local key=$2

    awk -v key="$key" '
    BEGIN {
        FS="="
    }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
        if ($1 == key) {
            print $2
        }
    }
    ' "$file"
    
}

algo=$(parse_conf "$MINER_CONF" "algo")
account=$(parse_conf "$MINER_CONF" "account")
worker=$(parse_conf "$MINER_CONF" "worker")
pool=$(parse_conf "$MINER_CONF" "pool")
solo=$(parse_conf "$MINER_CONF" "solo")
gpu=$(parse_conf "$MINER_CONF" "gpu")
parallel=$(parse_conf "$MINER_CONF" "parallel")
thread=$(parse_conf "$MINER_CONF" "thread")
cpu_off=$(parse_conf "$MINER_CONF" "cpu-off")
gpu_off=$(parse_conf "$MINER_CONF" "gpu-off")
mode=$(parse_conf "$MINER_CONF" "mode")
log=$(parse_conf "$MINER_CONF" "log")
rest=$(parse_conf "$MINER_CONF" "rest")
port=$(parse_conf "$MINER_CONF" "port")
third_miner=$(parse_conf "$MINER_CONF" "third_miner"|sed 's/.*"\(.*\)".*/\1/')
third_cmd=$(parse_conf "$MINER_CONF" "third_cmd"|sed 's/.*"\(.*\)".*/\1/')

params=()

[ -n "$algo" ] && params+=(--algo "$algo")
[ -n "$account" ] && params+=(--account "$account")
[ -n "$worker" ] && params+=(--worker "$worker")

if [ -n "$gpu" ]; then
    gpu_args=()
    IFS=',' read -ra gpu_ids <<< "$gpu"
    for id in "${gpu_ids[@]}"; do
        gpu_args+=("-g" "$id")
    done
    params+=("${gpu_args[@]}")
fi

[ -n "$parallel" ] && params+=(-p "$parallel")
[ -n "$thread" ] && params+=(-t "$thread")
[ -n "$log" ] && params+=(--log "$log")
[ -n "$port" ] && params+=(--port "$port")
[ -n "$mode" ] && params+=(--mode "$mode")
[ "$cpu_off" == "true" ] && params+=(--cpu-off)
[ "$gpu_off" == "true" ] && params+=(--gpu-off)

if [ -n "$pool" ]; then
    params+=(--pool "$pool")
elif [ -n "$solo" ]; then
    params+=(--solo "$solo")
fi

if [ -z "$third_cmd" ]; then
	nohup ./apoolminer "${params[@]}" > $algo.log 2>&1 &
	exit 0
fi

while true; do
	now_time=$(date +%s)
	url="http://qubic1.hk.apool.io:8001/api/qubic/epoch_challenge"
	url_code=$(curl -s -o /dev/null -w '%{http_code}' "$url")
	if [ -e "$third_miner" ];then
		if [ "$url_code" -eq 200 ]; then
			res_url=$(curl -s "$url")
			mining_time=$(echo "$res_url"|grep -o '"timestamp":[0-9]*' | sed 's/.*"timestamp":\([0-9]*\).*/\1/')
			mining_seed=$(echo "$res_url"|grep -o '"mining_seed":"[^"]*"'|sed 's/.*"mining_seed":"\([^"]*\)".*/\1/')
			if [ -z "$mining_seed" ];then
				echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[31mERROR\033[0m Failed to check mining seed,will retry after 30 seconds"
				sleep 30
				continue
			elif [ "$mining_seed" = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" ];then
				if pgrep -f 'apoolminer' > /dev/null; then
					echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m No template available,kill apoolminer and run third_cmd"
					pkill -f 'apoolminer'
					nohup $third_cmd > third_cmd.log 2>&1 &
				else
					if pgrep -f "$third_miner" > /dev/null; then
						echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m No template available,third_cmd is already running"
					else
						echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m No template available,run third_cmd -  $third_cmd $third_miner"
						nohup $third_cmd > third_cmd.log 2>&1 &
					fi
				fi
			else
				if pgrep -f 'apoolminer' > /dev/null; then
					echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m Template is available,apoolminer is already running"
				else
					if pgrep -f "$third_miner" > /dev/null; then
						echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m Template is available,kill third_cmd and run apoolminer"
						pkill -f "$third_miner"
						nohup ./apoolminer "${params[@]}" > $algo.log 2>&1 &
					else
						echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m Template is available,run apoolminer"
						nohup ./apoolminer "${params[@]}" > $algo.log 2>&1 &
					fi
				fi
			fi
			time_diff=$((now_time - mining_time))
			if [ $time_diff -le 1800 ]; then
				sleep_time=120
			elif [ $time_diff -le 2700 ]; then
				sleep_time=20
			else
				sleep_time=10
			fi
			echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[32mINFO\033[0m Wait for $sleep_time seconds to check the template"
			sleep $sleep_time
		else
			echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[31mERROR\033[0m Failed to connect to the url,will retry after 30 seconds"
			sleep 30
			continue
		fi
	else
		echo -e "$(date +"%Y-%m-%d %H:%M:%S")     \033[31mERROR\033[0m $third_miner does not exist"
		sleep 5
	fi
done
EOF
cat <<EOF > miner.conf
algo=qubic
account=CP_3kv3xuwg6d
pool=qubic1.hk.apool.io:3334

worker = $1
cpu-off = true
#thread = 12
#gpu-off = false
#gpu = 0,1,2
mode = 1

third_miner = "aleo_prover"
third_cmd = "./aleo_prover -pool aleo.hk.zk.work:10003 --address aleo1p5063azmcd5ajzr3nmp9u6ezpta5e9wq7a0dnq5h75vm26x0h58st00ws2 --custom_name $1"
EOF
chmod +x ./run.sh
screen -dmS qub ./run.sh
