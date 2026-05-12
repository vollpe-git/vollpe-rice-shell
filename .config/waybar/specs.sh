#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
#RAM=$(free -m | awk '/Mem:/ { printf "%.1f", $3/$2*100 }')
#RAM=$(free -m | awk '/Mem:/ { printf "%.1fGB/%.1fGB", $3/1024, $2/1024}')
RAM=$(free -m | awk '/Mem:/ { printf "%.1fGB", $3/1024}')
TEMP=$(( $(cat /sys/class/thermal/thermal_zone0/temp)/1000 ))°C

echo "{\"tooltip\": \"CPU: ${CPU}%\\nRAM: ${RAM}\\nTEMP: ${TEMP}\"}"
