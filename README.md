# MQTT Stats

Container to export CPU and Memory usage to a MQTT topic

## Running it:
```bash
docker run -d \
-e "MQTT_HOST=test.mosquitto.org" \
-e "MQTT_PORT=1883" \
-e "MQTT_TOPIC=/test/telemetry" \
-e "INTERVAL_SEC=10" \
mqtt-stats:1
```

## Build
```bash
docker build . -t mqtt-stats:1
```