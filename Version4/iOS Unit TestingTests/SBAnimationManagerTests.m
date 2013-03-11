//
//  SBAnimationManager.m
//  iOS Unit Testing
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
