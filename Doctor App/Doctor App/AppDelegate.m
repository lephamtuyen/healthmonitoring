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

@interface AppDelegate() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *colorTimer;
@property (nonatomic, strong) NSTimer *popupTimer;
@property (nonatomic, strong) UIAlertView *popup;
@property (nonatomic, assign) BOOL color;
@end

@implementation AppDelegate

/** Initialize the application. Load stored settings. Set the appropriate
 *  storyboard.
 *  @return YES is returned in all cases
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    // Initialize some applicat
    self.sensorFrequency = IOTSensorFreqDefault;
    
    self.messageLog = [[NSMutableArray alloc] init];
    
    [self initilizeAudioPlayer];
    
    return YES;
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
    
    // Publish the message on the desired event
    [messenger publish:[TopicFactory getEventTopic:event] payload:message qos:0 retained:NO];
}

- (void)updateViewLabelsAndButtons
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if (self.loginViewController != nil) {
        [self.loginViewController updateViewLabels];
    }
}

- (void)updateHeartbeat:(NSString *)heartbeat
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    
    if (self.heartbeatViewController != nil) {
        [self.heartbeatViewController addPointToGraph:heartbeat];
    }
}

- (void)updateLocationWithLatitude:(double)lat lon:(double)lon
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    
    if (self.locationViewController != nil && self.currentView == NAVIGATE) {
        [self.locationViewController updateLocationWithLatitude:lat lon:lon];
    }
}

- (void)handleEmergencyCall {
    [self changeBackgroundColor];
    [self playEmergencySound];
    [self showPopUp];
}

- (void)changeBackgroundColor
{
    if (_colorTimer) {
        [_colorTimer invalidate];
    }
    self.colorTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                       target: self
                                                     selector:@selector(onTick)
                                                     userInfo: nil repeats:YES];
}

- (void)showPopUp
{
    if (!_popup) {
        _popup = [[UIAlertView alloc] initWithTitle:nil message:@"Emergency call from Patient !" delegate:self cancelButtonTitle:@"Ignored" otherButtonTitles:OK_STRING, nil];
        [_popup show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ignored"])
    {
        _popup = nil;
        if (_popupTimer) {
            [_popupTimer invalidate];
        }
        self.popupTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                           target: self
                                                         selector:@selector(showPopUp)
                                                         userInfo: nil repeats:YES];
        return;
    }
    
    _popup = nil;
    [_popupTimer invalidate];
    [_audioPlayer stop];
    [_colorTimer invalidate];
    [self.loginViewController.view setBackgroundColor:[UIColor whiteColor]];
    [self.heartbeatViewController.view setBackgroundColor:[UIColor whiteColor]];
    [self.locationViewController.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)onTick {
    if (_color == YES) {
        // Red
        [self.loginViewController.view setBackgroundColor:[UIColor redColor]];
        [self.heartbeatViewController.view setBackgroundColor:[UIColor redColor]];
        [self.locationViewController.view setBackgroundColor:[UIColor redColor]];
    } else {
        [self.loginViewController.view setBackgroundColor:[UIColor whiteColor]];
        [self.heartbeatViewController.view setBackgroundColor:[UIColor whiteColor]];
        [self.locationViewController.view setBackgroundColor:[UIColor whiteColor]];
    }
    _color = !_color;
}

- (void)playEmergencySound
{
    [self setSessionActiveWithMixing:YES];
    [self playSound];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"received notification.");
}



- (void)initilizeAudioPlayer
{
    [self setSessionActiveWithMixing:NO];
    
    NSURL *heroSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"]];
    assert(heroSoundURL);
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:heroSoundURL error:nil];
    _audioPlayer.numberOfLoops = -1;
}

- (void)setSessionActiveWithMixing:(BOOL)duckIfOtherAudioIsPlaying
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] && duckIfOtherAudioIsPlaying)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers error:nil];
    }
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)playSound
{
    assert(self.audioPlayer);
    if (self.audioPlayer && (self.audioPlayer.isPlaying == NO))
    {
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

@end
