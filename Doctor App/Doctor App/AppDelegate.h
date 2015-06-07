/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  AppDelegate.h
//  IoTstarter
//

#ifndef AppDelegate_h
#define AppDelegate_h

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "Messenger.h"
#import "LoginViewController.h"
#import "LocationViewController.h"
#import "HeartbeatViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// UI views
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) LocationViewController *locationViewController;
@property (strong, nonatomic) HeartbeatViewController *heartbeatViewController;

@property (nonatomic) views currentView;

// Device specific properties
@property (nonatomic) BOOL isConnected;

@property double sensorFrequency;

// Store received "text" command messages for log view
@property (strong, nonatomic) NSMutableArray *messageLog;

- (void)publishData:(NSString *)message event:(NSString *)event;

- (void)updateViewLabelsAndButtons;

- (void)updateHeartbeat:(NSString *)heartbeat;
- (void)updateLocationWithLatitude:(double)lat lon:(double)lon;
- (void)handleEmergencyCall;
@end

#endif
