/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  Constants.h
//  IoTstarter
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

typedef enum _views {
    LOGIN,
    HEARTBEAT,
    NAVIGATE,
    EMERGENCY,
} views;

/** MQTT Constants */

extern NSString * const IOTServerAddress;
extern int        const IOTServerPort;
extern NSString * const IOTClientID;
extern NSString * const IOTEventTopic;

/** IoT Events and Commands */
extern NSString * const IOTHeatbeatEvent;
extern NSString * const IOTLocationEvent;
extern NSString * const IOTRecomendEvent;
extern NSString * const IOTEmergencyEvent;
extern NSString * const IOTColorEvent;
extern NSString * const IOTTouchMoveEvent;
extern NSString * const IOTSwipeEvent;
extern NSString * const IOTLightEvent;
extern NSString * const IOTTextEvent;
extern NSString * const IOTAlertEvent;
extern NSString * const IOTDirectionEvent;
extern NSString * const IOTGamepadEvent;
extern NSString * const IOTStatusEvent;

// Login View button and placeholder text
extern NSString * const IOTOrgPlaceholder;
extern NSString * const IOTDevicePlaceholder;
extern NSString * const IOTAuthPlaceholder;
extern NSString * const IOTShowTokenLabel;
extern NSString * const IOTHideTokenLabel;
extern NSString * const IOTActivateLabel;
extern NSString * const IOTDeactivateLabel;

extern double     const IOTSensorFreqDefault;
extern double     const IOTSensorFreqFast;

/** JSON Property names for messages */
extern NSString * const JSON_SCREEN_X;
extern NSString * const JSON_SCREEN_Y;
extern NSString * const JSON_DELTA_X;
extern NSString * const JSON_DELTA_Y;
extern NSString * const JSON_ENDED;

extern NSString * const JSON_TEXT;
extern NSString * const JSON_RECOMMEND;
extern NSString * const JSON_HEARTBEAT;
extern NSString * const JSON_EMERGENCY;

extern NSString * const JSON_LAT;
extern NSString * const JSON_LON;

/** Extra Strings */
extern NSString * const YES_STRING;
extern NSString * const NO_STRING;
extern NSString * const CANCEL_STRING;
extern NSString * const SUBMIT_STRING;
extern NSString * const OK_STRING;

@end
