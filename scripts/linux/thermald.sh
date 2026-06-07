#!/usr/bin/env bash

# Check if thermald is running
if systemctl is-active --quiet thermald; then
    # Grab the CPU temperature from the thermal zone (adjust thermal_zone0 if needed)
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
    # Convert from millidegrees to Celsius
    TEMP_C=$((TEMP / 1000))
    echo " $TEMP_C°C (TA)" # TA indicates thermald is Active
else
    echo " off"
fi
