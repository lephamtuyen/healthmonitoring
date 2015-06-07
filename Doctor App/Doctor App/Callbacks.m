/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  Callbacks.m
//  IoTstarter
//

#import "Callbacks.h"
#import "LocationViewController.h"

@implementation InvocationCallbacks

/** Is called when the function the protocol is assigned to completes successfully
 *  @param invocationContext A pointer to a variable or object that is to be made
 *  available to the onSuccess function, for example the MqttClient object
 */
- (void)onSuccess:(NSObject *)invocationContext
{
    NSLog(@"%s:%d - invocationContext=%@", __func__, __LINE__, invocationContext);
    if ([invocationContext isKindOfClass:[MqttClient class]])
    {
        // context is Mqtt Publish
    }
    else if ([invocationContext isKindOfClass:[NSString class]])
    {
        NSString *contextString = (NSString *)invocationContext;
        if ([contextString isEqualToString:@"connect"])
        {
            [self handleConnectSuccess];
        }
        else if ([contextString isEqualToString:@"disconnect"])
        {
            [self handleDisconnectSuccess];
        }
        else
        {
            NSArray *parts = [contextString componentsSeparatedByString:@":"];
            if ([parts[0] isEqualToString:@"subscribe"])
            {
                // Context is Mqtt Subscribe
                NSLog(@"Successfully subscribed to topic: %@", parts[1]);
            }
            else if ([parts[0] isEqualToString:@"unsubscribe"])
            {
                // Context is Mqtt Unsubscribe
                NSLog(@"Successfully unsubscribed from topic: %@", parts[1]);
            }
        }
    }
}

/** Is called when the function the protocol is assigned to fails to complete
 *  successfully
 *  @param invocationContext A pointer to a variable or object that is to be made
 *  available to the onSuccess function, for example the MqttClient object
 *  @param errorCode An error code indicating the reason for the failure (this may
 *  not always be available)
 *  @param errorMessage An error message indicating the reason for the failure (this
 *  may not always be available)
 */
- (void)onFailure:(NSObject *)invocationContext
        errorCode:(int)errorCode
     errorMessage:(NSString *)errorMessage
{
    NSLog(@"%s:%d - invocationContext=%@  errorCode=%d  errorMessage=%@", __func__, __LINE__, invocationContext, errorCode, errorMessage);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate updateViewLabelsAndButtons];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [NSString stringWithFormat:@"Failed to connect to IoT. Reason Code: %d", errorCode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect Failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
        [alert show];
    });
}

/** Called upon successful connection to the server. Start the iOS motion manager and
 *  update the views to indicate that the application is now connected. Subscribe to
 *  the wildcard command topic for this device.
 */
- (void)handleConnectSuccess
{
    // context is Mqtt Connect
    // Enable publishing of sensor data
    NSLog(@"Successfully connected to IoT Messaging Server");
    dispatch_async(dispatch_get_main_queue(), ^{
        // Launch timer for publishing accelerometer data
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.isConnected = YES;
        [appDelegate updateViewLabelsAndButtons];
        
        Messenger *messenger = [Messenger sharedMessenger];
        [messenger subscribe:[TopicFactory getEventTopic:IOTHeatbeatEvent] qos:0];
        [messenger subscribe:[TopicFactory getEventTopic:IOTLocationEvent] qos:0];
        [messenger subscribe:[TopicFactory getEventTopic:IOTEmergencyEvent] qos:0];
    });
}

/** Called upon successful disconnect from the server. Stop the iOS motion manager
 *  and update views to indicate that the application is no longer connected.
 */
- (void)handleDisconnectSuccess
{
    // Context is Mqtt Disconnect
    // Disable publishing of sensor data
    NSLog(@"Successfully disconnected from IoT Messaging Server");
    dispatch_async(dispatch_get_main_queue(), ^{
        // Kill the timer to stop publishing accelerometer data
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.isConnected = NO;
        [appDelegate updateViewLabelsAndButtons];
    });
}

@end

@implementation GeneralCallbacks

/** Called when the MQTT Client detects that the connection to the server was lost.
 *  @param invocationContext An NSString object with contents "connect"
 *  @param errorMessage The message indicating what failure occurred
 */
- (void)onConnectionLost:(NSObject *)invocationContext
            errorMessage:(NSString *)errorMessage
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    dispatch_async(dispatch_get_main_queue(), ^{
        // Kill the timer to stop publishing accelerometer data
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.isConnected = NO;
        [appDelegate updateViewLabelsAndButtons];
    });
}

/** Called when an MQTT message arrives at the client.
 *  @param invocationContext A pointer to a variable or object that is to be made
 *   available to the onSuccess function, for example the MqttClient object
 *  @param message The message that was received.
 */
- (void)onMessageArrived:(NSObject *)invocationContext
                 message:(MqttMessage *)message
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    NSString *payload = [[NSString alloc] initWithBytes:message.payload length:message.payloadLength encoding:NSASCIIStringEncoding];
    NSString *topic = message.destinationName;
    
    [self routeMessage:topic payload:payload];
}

/** If the client publishes a message to an MQTT topic,
 *  this method is executed upon successful delivery of that message to
 *  the MQTT server.
 *  @param invocationContext A pointer to a variable or object that is to be made
 *  available to the onMessageDelivered function, for example the MqttClient object
 *  @param msgId the message identifier of the delivered message (no value
 *  if the delivered message was QoS0)
 */
- (void)onMessageDelivered:(NSObject *)invocationContext
                 messageId:(int)msgId
{
}

/** Parse the message topic and call the appropriate method based on the command type.
 *  @param topic The topic string the message was received on
 *  @param payload The message payload
 */
- (void)routeMessage:(NSString *)topic payload:(NSString *)payload
{
    NSArray *topicParts = [topic componentsSeparatedByString:@"/"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([topicParts[1] isEqualToString:IOTHeatbeatEvent])
        {
            [self processHeartbeatMessage:payload];
        }
        else if ([topicParts[1] isEqualToString:IOTLocationEvent])
        {
            [self processLocationMessage:payload];
        }
        else if ([topicParts[1] isEqualToString:IOTEmergencyEvent])
        {
            [self processEmergencyMessage:payload];
        }
    });
}

/** Return the contents of the "d" JSON object from the message payload.
 *  @param payload The message payload
 *  @return An NSDictionary object containing the JSON contents of the "d" JSON object.
 */
- (NSDictionary *)getMessageBody:(NSString *)payload
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]
                          options:NSJSONReadingMutableContainers
                          error:&error];
    
    if (!json)
    {
        NSLog(@"Error parsing JSON: %@", error);
        return nil;
    }
    
    NSDictionary *body = [json objectForKey:@"d"];
    if (body == nil)
    {
        NSLog(@"Error in JSON: \"d\" object not found");
        return nil;
    }
    return body;
}

- (void)processHeartbeatMessage:(NSString *)payload
{
    NSDictionary *body;
    body = [self getMessageBody:payload];
    if (body == nil)
    {
        return;
    }
    
    NSString *hearbeat = [body objectForKey:JSON_HEARTBEAT];
    if (hearbeat) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate updateHeartbeat:hearbeat];
    }
}

- (void)processLocationMessage:(NSString *)payload
{
    NSDictionary *body;
    body = [self getMessageBody:payload];
    if (body == nil)
    {
        return;
    }
    
    double lat = [[body objectForKey:JSON_LAT] doubleValue];
    double lon = [[body objectForKey:JSON_LON] doubleValue];
    if (lat && lon) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate updateLocationWithLatitude:lat lon:lon];
    }
}


- (void)processEmergencyMessage:(NSString *)payload
{
    NSDictionary *body;
    body = [self getMessageBody:payload];
    if (body == nil)
    {
        return;
    }
    
    NSString *textValue = [body objectForKey:JSON_EMERGENCY];
    if (textValue) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate handleEmergencyCall];
    }
}

@end
