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

@interface LocationViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lat;
@property (strong, nonatomic) IBOutlet UILabel *lon;

@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *area;
@property (strong, nonatomic) IBOutlet UILabel *country;

@property (strong, nonatomic) IBOutlet UIImageView *borderImage;

@end

@implementation LocationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.locViewController = self;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _address.layer.borderColor = [UIColor blackColor].CGColor;
    _address.layer.borderWidth = 1.0;
    
    _area.layer.borderColor = [UIColor blackColor].CGColor;
    _area.layer.borderWidth = 1.0;
    
    _country.layer.borderColor = [UIColor blackColor].CGColor;
    _country.layer.borderWidth = 1.0;
}

- (void)updateLocationAddress:(NSString *)address area:(NSString *)area country:(NSString *)country lat:(float)lat lon:(float)lon {
    self.address.text = address;
    self.area.text = area;
    self.country.text = country;
    
    self.lat.text = [NSString stringWithFormat:@"lat: %.1f", lat];
    self.lon.text = [NSString stringWithFormat:@"lon: %.1f", lon];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = NAVIGATE;
    
    int r = self.borderImage.layer.frame.size.height;
    self.borderImage.layer.cornerRadius = r/2;
    self.borderImage.layer.masksToBounds = YES;
    self.borderImage.layer.borderWidth = 2;
    self.borderImage.layer.borderColor = [UIColor blackColor].CGColor;
}

/*************************************************************************
 * Other standard iOS methods
 *************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
