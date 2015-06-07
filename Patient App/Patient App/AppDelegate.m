/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  AppDelegate.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "LogMessage.h"

@interface AppDelegate() <CLLocationManagerDelegate>
@end

@implementation AppDelegate


- (void)clearLog
{
    Messenger *messenger = [Messenger sharedMessenger];
    [messenger clearLog];
    [self reloadLog];
}

- (void)reloadLog
{
    // must do this on the main thread, since we are updating the UI
    dispatch_async(dispatch_get_main_queue(), ^{
        Messenger *messenger = [Messenger sharedMessenger];
        NSString *badge = [NSString stringWithFormat:@"%lu", (unsigned long)[messenger.logMessages count]];
        if ([badge isEqualToString:@"0"]) {
            badge = nil;
        }
        self.heartbeatViewController.navigationController.tabBarItem.badgeValue = badge;
        
        if (self.currentView == HEARTBEAT) {
            [self.heartbeatViewController.tableView reloadData];
        }
    });
}

/** Initialize the application. Load stored settings. Set the appropriate
 *  storyboard.
 *  @return YES is returned in all cases
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    // Initialize some application settings
    self.isConnected = NO;
    self.sensorFrequency = IOTSensorFreqDefault;
        
    return YES;
}

- (void)startNavigation
{
    if (!self.locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        assert(self.locationManager);
        
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Observe the application going in and out of the background, so we can toggle location tracking.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUIApplicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleUIApplicationWillEnterForegroundNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)handleUIApplicationDidEnterBackgroundNotification:(NSNotification *)note
{
    [self.locationManager stopUpdatingLocation];
}

- (void)handleUIApplicationWillEnterForegroundNotification :(NSNotification *)note
{
    [self.locationManager startUpdatingLocation];
}

/** Disable the accelerometer and motion detector.
 */
- (void)stopNavigation
{
    [self.locationManager stopUpdatingLocation];
}

/** Publish an MQTT Message with data message for IoT Event event
 *  @param message The data to be sent
 *  @param event The event to publish the data to
 */
- (void)publishData:(NSString *)message event:(NSString *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    Messenger *messenger = [Messenger sharedMessenger];
    if (messenger.client.isConnected == NO)
    {
        NSLog(@"Mqtt Client not connected. Swipes will be ignored");
        return;
    }

    [messenger publish:[TopicFactory getEventTopic:event] payload:message qos:0 retained:NO];
}

- (void)updateViewLabelsAndButtons
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if (self.loginViewController != nil) {
        [self.loginViewController updateViewLabels];
    }
}

/** Add received text messages to the log view table. Update the tab bar badge for the log
 *  view to indicate a new unread message has arrived.
 *  @param textValue The content of the text message
 */
- (void)addLogMessage:(NSString *)textValue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.currentView != HEARTBEAT)
        {
            Messenger *messenger = [Messenger sharedMessenger];
            NSString *badge = [NSString stringWithFormat:@"%lu", (unsigned long)[messenger.logMessages count]];
            if ([badge isEqualToString:@"0"]) {
                badge = nil;
            }
            self.heartbeatViewController.navigationController.tabBarItem.badgeValue = badge;
        }
        
        [self.heartbeatViewController reloadData];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Store application data to be saved.
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations != nil && locations.count > 0)
    {
        CLLocation *newLocation = locations[0];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 NSString *address = [[NSString alloc]initWithString:locatedAt];
                 NSString *area = [[NSString alloc]initWithString:placemark.locality];
                 NSString *country = [[NSString alloc]initWithString:placemark.country];
                 
                 if (self.currentView == NAVIGATE) {
                     [self.locViewController updateLocationAddress:address area:area country:country lat:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];
                 }
             }
         }];
        
        NSString *messageData = [MessageFactory createLocationMessageWithLatitude:newLocation.coordinate.latitude longtitude:newLocation.coordinate.longitude];
        [self publishData:messageData event:IOTLocationEvent];
    }
}

@end
