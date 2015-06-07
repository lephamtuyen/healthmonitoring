//
//  LogMessage.h
//  MQTTTest
//
//  Created by Bryan Boyd on 12/8/13.
//  Copyright (c) 2013 Bryan Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogMessage : NSObject

@property NSString *timestamp;
@property NSString *data;
@property NSString *type;

@end
