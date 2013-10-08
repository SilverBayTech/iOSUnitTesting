//
//  SBTestObserver.m
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 10/8/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SBTestObserver : SenTestLog
@end

static id mainSuite = nil;

@implementation SBTestObserver
+ (void)initialize
{
    [[NSUserDefaults standardUserDefaults] setValue:@"SBTestObserver" forKey:SenTestObserverClassKey];

    [super initialize];
}

+ (void)testSuiteDidStart:(NSNotification*)notification {
    [super testSuiteDidStart:notification];

    SenTestSuiteRun* suite = notification.object;

    if (mainSuite == nil)
    {
        mainSuite = suite;
    }
}

+ (void)testSuiteDidStop:(NSNotification*)notification {
    [super testSuiteDidStop:notification];

    SenTestSuiteRun* suite = notification.object;

    if (mainSuite == suite)
    {
        UIApplication* application = [UIApplication sharedApplication];
        [application.delegate applicationWillTerminate:application];
    }
}

@end
