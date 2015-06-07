/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  ViewController.m
//  IoTstarter
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@import AVFoundation;
@import MapKit;

@interface LocationViewController () <MKMapViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *sattelite;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refresh;
@property (nonatomic, weak) IBOutlet UILabel *addresses;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) BOOL focus;

@end

@implementation LocationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.locationViewController = self;
        _focus = YES;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initilizeAudioPlayer];

    _navigationBar.topItem.leftBarButtonItem = _sattelite;
    _navigationBar.topItem.rightBarButtonItem = _refresh;
    
    _addresses.layer.borderColor = [UIColor blackColor].CGColor;
    _addresses.layer.borderWidth = 1.0;
    
    _map.layer.borderColor = [UIColor blackColor].CGColor;
    _map.layer.borderWidth = 1.0;
    
    _currentCoordinate = CLLocationCoordinate2DMake(-1, -1);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = NAVIGATE;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/*************************************************************************
 * Other standard iOS methods
 *************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Audio Support

- (void)initilizeAudioPlayer
{
    [self setSessionActiveWithMixing:NO];
    
    NSURL *heroSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Hero" ofType:@"aiff"]];
    assert(heroSoundURL);
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:heroSoundURL error:nil];
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (self.audioPlayer && (self.audioPlayer.isPlaying == NO) && appDelegate.currentView == NAVIGATE)
    {
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (MKCoordinateRegion)coordinateRegionWithCenter:(CLLocationCoordinate2D)centerCoordinate approximateRadiusInMeters:(CLLocationDistance)radiusInMeters
{
    // Multiplying by MKMapPointsPerMeterAtLatitude at the center is only approximate, since latitude isn't fixed
    //
    double radiusInMapPoints = radiusInMeters*MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints,radiusInMapPoints};
    
    MKMapPoint regionOrigin = MKMapPointForCoordinate(centerCoordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared}; //origin is the top-left corner
    
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    
    // clamp the rect to be within the world
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(regionRect);
    return region;
}

- (IBAction)focusPatient {
    if (_currentCoordinate.latitude != -1 && _currentCoordinate.longitude != -1) {
        _focus = YES;
        [self focusToUserLocation:_currentCoordinate];
    }
}

- (IBAction)changeMapType:(id)sender {
    if (self.map.mapType != MKMapTypeSatellite) {
        self.map.mapType = MKMapTypeSatellite;
    } else {
        self.map.mapType = MKMapTypeStandard;
    }
}

- (void)focusToUserLocation:(CLLocationCoordinate2D) coordinate {
    if (_focus == YES) {
        // default -boundingMapRect size is 1km^2 centered on coord
        MKCoordinateRegion region = [self coordinateRegionWithCenter:coordinate approximateRadiusInMeters:2500];
        [self.map setRegion:region animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = @"Patient here!";
        [self.map addAnnotation:annotation];
        [self.map selectAnnotation:annotation animated:YES];
        NSLog(@"Not call");
        _focus = NO;
    }
}

- (void)updateLocationWithLatitude:(double)lat lon:(double)lon {
    [self setSessionActiveWithMixing:YES]; // YES == duck if other audio is playing
    [self playSound];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    _currentCoordinate = location.coordinate;
    [self focusToUserLocation:_currentCoordinate];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *address = [[NSString alloc]initWithString:locatedAt];
             NSString *country = [[NSString alloc]initWithString:placemark.country];
             
             self.addresses.text = [NSString stringWithFormat:@"%@, %@", address, country];
         }
     }];

}

@end
