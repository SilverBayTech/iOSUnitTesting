//
//  SBAnimationManagerTests.m
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 3/8/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock.h>
#import "SBAnimationManager.h"
#import "SBAnimationManager+Internal.h"

#define ANIMATION_DURATION  0.1

@interface SBAnimationManagerTests : SenTestCase
@end

@implementation SBAnimationManagerTests
{
    SBAnimationManager *    _objUnderTest;
    id                      _mockDelegate;
    UIView *                _parentView;
    UIView *                _viewBeingAnimated;
}

- (void) setUp
{
    _objUnderTest = [[SBAnimationManager alloc] init];
    _objUnderTest.duration = ANIMATION_DURATION;
    _mockDelegate = [OCMockObject mockForProtocol:@protocol(SBAnimationManagerDelegate)];
    _objUnderTest.delegate = _mockDelegate;
    _parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _viewBeingAnimated = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_parentView addSubview:_viewBeingAnimated];
}

- (void) tearDown
{
    _objUnderTest = nil;
    _parentView = nil;
    _viewBeingAnimated = nil;
    _mockDelegate = nil;
}

- (void) waitForAnimations
{
    NSTimeInterval timeout = ANIMATION_DURATION * 2 + 0.1;
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    while ([loopUntil timeIntervalSinceNow] > 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
}

- (void) test_viewReturnsHomeAfterAnimationsComplete
{
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    
    [[_mockDelegate expect] animationComplete];
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] playBounceSound];
    
    [wrapper bounceView:_viewBeingAnimated to:CGPointMake(5, 95)];
    
    [self waitForAnimations];
    
    CGPoint viewCenter = _viewBeingAnimated.center;
    
    STAssertEquals(viewCenter.x, originalViewCenter.x, nil);
    STAssertEquals(viewCenter.y, originalViewCenter.y, nil);
    [_mockDelegate verify];
    [wrapper verify];
}
@end
