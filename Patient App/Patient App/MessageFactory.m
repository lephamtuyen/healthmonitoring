/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  MessageFactory.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "MessageFactory.h"
#import "Constants.h"

/**
 */

@implementation MessageFactory

/** 
 *  @param
 *  @return messageString
 */
+ (NSString *)createLocationMessageWithLatitude:(double)lat
                                     longtitude:(double)lon
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_LAT: @(lat),
                                                JSON_LON: @(lon)
                                                }
    };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createEmergencyMessage:(NSString *)text
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_EMERGENCY: text
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createHeartbeatMessage:(NSString *)text
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_HEARTBEAT: text
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}
@end