#!/usr/bin/env sh

# Checking if variables exists and setting defaults if they don't
[  -z "$MQTT_HOST" ] && MQTT_HOST="test.mosquitto.org"
[  -z "$MQTT_TOPIC" ] && MQTT_TOPIC="/test/telemetry"
[  -z "$MQTT_PORT" ] && MQTT_PORT=1883
[  -z "$INTERVAL_SEC" ] && INTERVAL_SEC=5


# Logging out the variables
echo "Sending MQTT messages to host: $MQTT_HOST - port: $MQTT_PORT - topic: $MQTT_TOPIC - every $INTERVAL_SEC seconds"

while true
do
    # Getting CPU usage
	CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')

	# Getting Memory usage
	MEM_USAGE=$(free | awk 'FNR == 3 {print $3/($3+$4)*100}')

	DATA="{\"cpu\":$CPU_USAGE, \"memory\": $MEM_USAGE}"

	# Logging
	echo $DATA

	# Publishing it to the topic
    mosquitto_pub -d -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC -q 1 -m "$DATA"
    sleep $INTERVAL_SEC
done