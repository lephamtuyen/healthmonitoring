/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  Constants.m
//  IoTstarter
//

#import "Constants.h"

@implementation Constants

NSString * const IOTServerAddress     = @"iot.eclipse.org";
int        const IOTServerPort        = 1883;
NSString * const IOTClientID          = @"MQTTTest.%d";
NSString * const IOTEventTopic        = @"khu/%@";

// IoT Events and Commands
NSString * const IOTHeatbeatEvent     = @"heartbeat";
NSString * const IOTLocationEvent     = @"location";
NSString * const IOTRecomendEvent     = @"recommend";
NSString * const IOTEmergencyEvent    = @"emergency";

NSString * const IOTColorEvent        = @"color";
NSString * const IOTTouchMoveEvent    = @"touchmove";
NSString * const IOTSwipeEvent        = @"swipe";
NSString * const IOTLightEvent        = @"light";
NSString * const IOTTextEvent         = @"text";
NSString * const IOTAlertEvent        = @"alert";
NSString * const IOTDirectionEvent    = @"direction";
NSString * const IOTGamepadEvent      = @"gamepad";
NSString * const IOTStatusEvent       = @"status";

// Login View button and placeholder text
NSString * const IOTOrgPlaceholder    = @"Organization ID";
NSString * const IOTDevicePlaceholder = @"Device ID";
NSString * const IOTAuthPlaceholder   = @"Authorization Token";
NSString * const IOTShowTokenLabel    = @"Show Auth Token";
NSString * const IOTHideTokenLabel    = @"Hide Auth Token";
NSString * const IOTActivateLabel     = @"Connect";
NSString * const IOTDeactivateLabel   = @"Disconnect";

double const IOTSensorFreqDefault     = 1.0;
double const IOTSensorFreqFast        = 0.2;

// Extra strings
NSString * const YES_STRING           = @"Yes";
NSString * const NO_STRING            = @"No";
NSString * const CANCEL_STRING        = @"Cancel";
NSString * const SUBMIT_STRING        = @"Submit";
NSString * const OK_STRING            = @"OK";

// JSON Fields
NSString * const JSON_SCREEN_X        = @"screenX";
NSString * const JSON_SCREEN_Y        = @"screenY";
NSString * const JSON_DELTA_X         = @"deltaX";
NSString * const JSON_DELTA_Y         = @"deltaY";
NSString * const JSON_ENDED           = @"ended";

NSString * const JSON_TEXT            = @"text";

NSString * const JSON_HEARTBEAT       = @"heartbeat";

NSString * const JSON_RECOMMEND       = @"recommend";

NSString * const JSON_EMERGENCY       = @"emergency";

NSString * const JSON_COLOR_R         = @"r";
NSString * const JSON_COLOR_G         = @"g";
NSString * const JSON_COLOR_B         = @"b";
NSString * const JSON_ALPHA           = @"alpha";

NSString * const JSON_LAT             = @"lat";
NSString * const JSON_LON             = @"lon";

NSString * const JSON_BUTTON          = @"button";
NSString * const JSON_DPAD_X          = @"x";
NSString * const JSON_DPAD_Y          = @"y";
NSString * const JSON_DIRECTION_UP    = @"UP";
NSString * const JSON_DIRECTION_DOWN  = @"DOWN";
NSString * const JSON_DIRECTION_LEFT  = @"LEFT";
NSString * const JSON_DIRECTION_RIGHT = @"RIGHT";
NSString * const JSON_BUTTON_A        = @"A";
NSString * const JSON_BUTTON_B        = @"B";
NSString * const JSON_BUTTON_X        = @"X";
NSString * const JSON_BUTTON_Y        = @"Y";

@end

/*
 server = <org>.messaging.internetofthings.ibmcloud.com:1883
 username = "use-token-auth"
 password = token returned from registering device
 clientid = d:<org>:iPhone:<deviceid>
 
 topic = iot-2/evt/<event-type-id>/fmt/<format>
    <event-type-id> = ???
    <format> = json?
 
 topic = iot-2/cmd/<command-type-id>/fmt/<format>
 <command-type-id> = ???
 <format> = json?
 
 QoS=0
 No retained support
 
 JSON payload, top level = d
 {
 "d": {
 "name1": "stringvalue",
 "name2": intvalue,
 ...
 }
 }
 */

