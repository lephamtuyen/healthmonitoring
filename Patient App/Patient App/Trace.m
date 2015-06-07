/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

#import "Trace.h"

@implementation Trace

@synthesize traceLevel;
- (Trace *)initWithTraceLevel:(TraceLevel)level
{
    self = [super init];
    traceLevel = level;
    return self;
}

/** Emit a trace message at the TraceLevelDebug level.
 *  @param message A string value of the trace message
 */
- (void)traceDebug: (NSString*)message
{
    if (self.traceLevel <= TraceLevelDebug)
    {
        NSLog(@"[DEBUG]: %@", message);
    }
}

/** Emit a trace message at the TraceLevelLog level.
 *  @param message A string value of the trace message
 */
- (void)traceLog:   (NSString*)message
{
    if (self.traceLevel <= TraceLevelLog)
    {
        NSLog(@"[LOG]: %@", message);
    }
}

/** Emit a trace message at the TraceLevelInfo level.
 *  @param message A string value of the trace message
 */
- (void)traceInfo:  (NSString*)message
{
    if (self.traceLevel <= TraceLevelInfo)
    {
        NSLog(@"[INFO]: %@", message);
    }
}

/** Emit a trace message at the TraceLevelWarn level.
 *  @param message A string value of the trace message
 */
- (void)traceWarn:  (NSString*)message
{
    if (self.traceLevel <= TraceLevelWarning)
    {
        NSLog(@"[WARN]: %@", message);
    }
}

/** Emit a trace message at the TraceLevelError level.
 *  @param message A string value of the trace message
 */
- (void)traceError: (NSString*)message
{
    if (self.traceLevel <= TraceLevelError)
    {
        NSLog(@"[ERROR]: %@", message);
    }
}

@end
