# healthmonitoring
- IBM Internet of Thing, turn your mobile device into a sensor.
- Existing Technologies:
  + MQTT: A machine-to-machine (M2M)/"Internet of Things" connectivity protocol designed as an extremely lightweight publish/subscribe messaging transport. I use free MQTT server iot.eclipse.org, port 1883
  + Measure heartbeat rate using iphone camera.
- There have 2 iOS Applications:
  + Patient application: is installed on patient's iphone. It allows:
    * measure heartbeat and sent it to doctor.
    * send GPS Coordinates to the doctor.
    * send a emergency call to the doctor.
    * receive recommendation from doctor.
  + Doctor application: is installed on doctor's iphone. It allows:
    * visualize heartbeat rate in a graph.
    * show location of patient on the map.
    * show a alert to doctor after patient make a emergency call.
- Supported iOS version: 8.3
- Supported iphone: iphone 5/5s
