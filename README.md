# MQTT Stats

Container to export CPU and Memory usage to a MQTT topic

## Running it:
```bash
docker run -d --name=mqtt-stats --restart=always \
-e "MQTT_HOST=test.mosquitto.org" \
-e "MQTT_PORT=1883" \
-e "MQTT_TOPIC=/test/telemetry" \
-e "INTERVAL_SEC=5" \
asavie/mqtt-stats:1
```

After this, the docker container will be exporting the cpu and memory usage to test.mosquitto.org on the topic `/test/telemetry` every 5 seconds.  

You can subscribe to that topic from any other computer:
```bash
mosquitto_sub -d -h test.mosquitto.org  -t "/test/telemetry"
```


## Build
```bash
docker build . -t asavie/mqtt-stats:1
```