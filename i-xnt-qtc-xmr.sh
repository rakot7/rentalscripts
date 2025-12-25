#!/bin/bash
apt update -y
apt install -y screen git curl cron nano mc htop iputils-ping
pkill -f npt
pkill -f qtc
pkill -f qub
cd /root/
mkdir xnt
cd xnt
