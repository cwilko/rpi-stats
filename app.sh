#!/usr/bin/env sh

# Checking if variables exists and setting defaults if they don't
[  -z "$PROC_PATH" ] && PROC_PATH="/proc"
[  -z "$MQTT_HOST" ] && MQTT_HOST="test.mosquitto.org"
[  -z "$MQTT_TOPIC" ] && MQTT_TOPIC="/test/telemetry"
[  -z "$MQTT_PORT" ] && MQTT_PORT=1883
[  -z "$INTERVAL_SEC" ] && INTERVAL_SEC=5


# Logging out the variables
echo "Sending MQTT messages to host: $MQTT_HOST - port: $MQTT_PORT - topic: $MQTT_TOPIC - every $INTERVAL_SEC seconds"

while true
do
    # Getting CPU usage
    CPU_USAGE=$(
        awk -v stats_path="${PROC_PATH}/stat" 'BEGIN {
          prev_total = 0
          prev_idle = 0
          loops = 0
          while (getline < stats_path) {
            close(stats_path)
            idle = $5
            total = 0
            for (i=2; i<=NF; i++)
              total += $i
            if (loops >= 2){
              print (1-(idle-prev_idle)/(total-prev_total))*100
              break
            }
            prev_idle = idle
            prev_total = total
            system("sleep 1")
            loops += 1
          }
        }'
    )

    # Getting Memory usage
    MEM_TOTAL=$(cat $PROC_PATH/meminfo | grep MemTotal | awk '{print $2}')
    MEM_AVAILABLE=$(cat $PROC_PATH/meminfo | grep MemAvailable | awk '{print $2}')

    MEM_USED=`expr $MEM_TOTAL - $MEM_AVAILABLE`
    MEM_USAGE=`expr $MEM_USED \* 100 / $MEM_TOTAL`

    # Getting Disk Usage
    DISK_USAGE=`awk "BEGIN {print "$(df -P | awk 'NR>2 && /^\/dev\//{sum+=$3}END{print sum}')/$(df -P | awk 'NR>2 && /^\/dev\//{sum+=$2}END{print sum}')*100"}";`

    # Get uptime
    UPTIME=`awk '{print $1*1000}' /proc/uptime`


    # Get temperatures
    CPU_TEMP=`awk "BEGIN { print "$(cat /sys/class/thermal/thermal_zone0/temp)/1000" };"`
    GPU_TEMP=`vcgencmd measure_temp | sed "s/[^0-9.]//g"`
    PMIC_TEMP=`vcgencmd measure_temp pmic | sed "s/[^0-9.]//g"`

    DATA="{\"cpu\":$CPU_USAGE,\
      \"memory\": $MEM_USAGE,\
      \"disk\": $DISK_USAGE,\
      \"uptime\": $UPTIME,\
      \"cpu_temp\": $CPU_TEMP,\
      \"gpu_temp\": $GPU_TEMP,\
      \"pmic_temp\": $PMIC_TEMP,\
      }"

    # Logging
    echo $DATA

    # Publishing it to the topic
    cmd="mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC $MQTT_EXTRA_ARGS -q 1 -m \"$DATA\""
    echo $cmd
    eval $cmd
    sleep $INTERVAL_SEC
done