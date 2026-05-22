#!/usr/bin/env bash

if systemctl is-active --quiet thermald; then
    TEMP=$(cat /sys/class/thermal/thermal_zone2/temp)
    TEMP_C=$((TEMP / 1000))
    echo " $TEMP_C°C"
else
    echo " off"
fi
