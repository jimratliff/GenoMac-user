#!/bin/zsh

############### WORK IN PROGRESS

function set_power_management_settings() {


report_start_phase_standard
report_action_taken "Implement Alan.app settings"

# Detects if this Mac is a laptop or not by checking for a built-in battery.
IS_LAPTOP=$(/usr/sbin/ioreg -c AppleSmartBattery -r | awk '/BatteryInstalled/ {print $3}')

if [[ "$IS_LAPTOP" = "Yes" ]]; then
	/usr/bin/pmset -b sleep 15 disksleep 10 displaysleep 5 halfdim 1
	/usr/bin/pmset -c sleep 0 disksleep 0 displaysleep 30 halfdim 1
else
	/usr/bin/pmset sleep 0 disksleep 0 displaysleep 30 halfdim 1
fi

report_end_phase_standard

}
