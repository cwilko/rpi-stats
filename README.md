# RPi Stats

Container to export various Raspberry Pi statistics to an MQTT topic

## Running it:
```bash
docker run -d --name=mqtt-stats --restart=always \
-v /proc:/prochost:ro \
-e "MQTT_HOST=test.mosquitto.org" \
-e "MQTT_PORT=1883" \
-e "MQTT_TOPIC=/test/telemetry" \
-e "PROC_PATH=/prochost" \
-e "INTERVAL_SEC=5" \
cwilko/rpi-stats
```

After this, the docker container will be exporting the stats to test.mosquitto.org on the topic `/test/telemetry` every 5 seconds.  

You can subscribe to that topic from any other computer:
```bash
mosquitto_sub -d -h test.mosquitto.org  -t "/test/telemetry"
```


## Build
```bash
docker build . -t cwilkio/rpi-stats
```
