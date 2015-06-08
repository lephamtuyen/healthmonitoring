Health monitoring application
- IBM Internet of Thing, turn your mobile device into a sensor.
- Existing Technologies:
  + MQTT: A machine-to-machine (M2M)/"Internet of Things" connectivity protocol designed as an extremely lightweight publish/subscribe messaging transport. I use free MQTT server iot.eclipse.org, port 1883
  + Measure heartbeat rate using iPhone camera.
- There have 2 iOS Applications:
  + Patient application is installed on patient's iPhone. It allows:
    * measure heartbeat and sent it to a doctor.
    * send GPS Coordinates to the doctor.
    * send an emergency call to the doctor.
    * receive recommendations from the doctor.
  + Doctor application is installed on doctor's iPhone. It allows:
    * visualize heartbeat rate in a graph.
    * show location of the patient on the map.
    * show an alert to doctor after patient made an emergency call.
- Supported iOS version: 8.3
- Supported iPhone: iPhone 5/5s
