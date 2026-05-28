#!/bin/bash
while pgrep -x "bluetoothctl" > /dev/null; do
	pid=$(pgrep -x "bluetoothctl")
	etime=$(ps -eo pid,etime | grep $pid | awk '{print $2}')
	devices=$(bluetoothctl devices | awk '{sub(/^Device /,""); print $1, " | ", substr($0, index($0,$2))}')
	choice=$(echo "$devices" | if pgrep -x "bluetoothctl" > /dev/null; then timeout 1 rofi -dmenu -theme ~/.config/rofi/bluetooth.rasi -mesg "Paired devices | Scanning... | Elapsed: $etime"; else rofi -dmenu -theme ~/.config/rofi/bluetooth.rasi -mesg "Paired devices"; fi)
	rofi_exit=$?
	if [ $rofi_exit -eq 1 ]; then
		kill "$pid"
		exit & ~/.config/rofi/scripts/blue.sh
	fi
done

devices=$(bluetoothctl devices | awk '{sub(/^Device /,""); print $1, " | ", substr($0, index($0,$2))}')
choice=$(echo "$devices" | rofi -dmenu -theme ~/.config/rofi/bluetooth.rasi -mesg "Paired devices")
id=$(echo "$choice" | awk '{print $1}')
case "$choice" in
	"") exit & ~/.config/rofi/scripts/blue.sh ;;
esac
~/.config/rofi/scripts/btaction.sh "$id"
