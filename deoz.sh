
#!/bin/bash

srv=$1

while true; do

echo $srv

curl -XPOST -H 'auth: B8u_l8xhBMeB3RIaMXp1MWMm9YBUfgNO' -H "Content-type: application/json" -d '
{
    "currency":"CLORE-Blockchain",
    "image":"cloreai/jupyter:ubuntu24.04-v1",
    "renting_server":'"$srv"',
    "type":"on-demand",
    "ports":{
        "22":"tcp",
        "8888":"http"
    },
    "ssh_password":"q12we34rt56y",
    "command":"#!/bin/sh\napt update -y && apt install htop"
}' 'https://api.clore.ai/v1/create_order'


sleep 5s;
#price=$(echo "$price + $step" | bc)

#echo rig:$0 " "oder:$order" "price:$price
echo -e "\n"
done
