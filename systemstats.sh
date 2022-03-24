#!/bin/sh
file="/mnt/ramdisk/stats.txt"

if [ -f $file ]; then
	echo "stats.txt exits"
else
	touch $file
	echo "stats.txt was created"
fi


while true; do
	# Datum
	echo "<date>" > $file
	echo "$(date)" >> $file
	echo "</date>" >> $file
	
	# Netzwerktraffic am Wireguard Interface
	networkdata_wg0_Bytes_RX=$(ifconfig wg0 | grep "RX" | head -1 | awk '{print $5}')
	networkdata_wg0_Bytes_TX=$(ifconfig wg0 | grep "TX" | head -1 | awk '{print $5}')
	echo "<network_wg0>" >> $file
	echo "RX_Data_Bytes: $networkdata_wg0_Bytes_RX" >> $file
	echo "TX_Data_Bytes: $networkdata_wg0_Bytes_TX" >> $file
	echo "</network_wg0>" >> $file

	# Netzwerktraffix Wireguard per Host
	wireguard_data=$(wg | grep transfer)
	networkdata_wg0_Bytes_RX_peer1=$(echo $wireguard_data | awk '{print $2" "$3}')
	networkdata_wg0_Bytes_TX_peer1=$(echo $wireguard_data | awk '{print $5" "$6}')
	networkdata_wg0_Bytes_RX_peer2=$(echo $wireguard_data | awk '{print $9" "$10}')
        networkdata_wg0_Bytes_TX_peer2=$(echo $wireguard_data | awk '{print $12" "$13}')
	echo "<network_wireguard>" >> $file
	echo "<Peer1>" >> $file
	echo "<RX_Data>" >> $file
	echo "$networkdata_wg0_Bytes_RX_peer1" >> $file
	echo "</RX_Data>" >> $file
	echo "<TX_Data>" >> $file
	echo "$networkdata_wg0_Bytes_TX_peer1" >> $file
        echo "</TX_Data>" >> $file
	echo "</Peer1>" >> $file
        echo "<Peer2>" >> $file
        echo "<RX_Data>" >> $file
        echo "$networkdata_wg0_Bytes_RX_peer2" >> $file
        echo "</RX_Data>" >> $file
        echo "<TX_Data>" >> $file
        echo "$networkdata_wg0_Bytes_TX_peer2" >> $file
        echo "</TX_Data>" >> $file  
        echo "</Peer2>" >> $file
	echo "</network_wireguard>" >> $file

	# Netzwerktraffix am Ethernet Interface
        networkdata_eth0_Bytes_RX=$(ifconfig eth0 | grep "RX" | grep "RX" | head -1 | awk '{print $5}')
        networkdata_eth0_Bytes_TX=$(ifconfig eth0 | grep "TX" | grep "TX" | head -1 | awk '{print $5}')
	echo "<network_eth0>" >> $file 
	echo "RX_Data_Bytes: $networkdata_eth0_Bytes_RX" >> $file
	echo "TX_Data_Bytes: $networkdata_eth0_Bytes_TX" >> $file
	echo "</network_eth0>" >> $file 

	# Temperatur des SoC
	SOC_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
	SOC_temp="$(($SOC_temp / 1000))"
	echo "<temp_soc>" >> $file
	echo "$SOC_temp" >> $file
	echo "</temp_soc>" >> $file
	
	# Uptime
	x=0
	SOC_uptime=$(awk '{print $1}' /proc/uptime)
	echo "<uptime_soc>" >>$file
 	echo "$SOC_uptime" >> $file
	echo "</uptime_soc>" >>$file




 	sleep 2;
done

