//
//  EmergencyViewController.m
//  Patient App
//
//  Created by Tuyen on 5/26/15.
//  Copyright (c) 2015 khu. All rights reserved.
//

#import "EmergencyViewController.h"
#import "AppDelegate.h"
#import "DKCircleButton.h"

@interface EmergencyViewController ()

@property (nonatomic, strong) IBOutlet DKCircleButton *button;

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _button = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_button addTarget:self action:@selector(emergencyCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    _button.center = CGPointMake(160, 300);
    [_button setTitle:@"Send Help!" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:36];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*************************************************************************
 * IBAction methods
 *************************************************************************/

- (IBAction)emergencyCall:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate publishData:[MessageFactory createEmergencyMessage:@"SOS"] event:IOTEmergencyEvent];
}

@end
