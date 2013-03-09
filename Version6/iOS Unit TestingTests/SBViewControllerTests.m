//
//  SBViewControllerTests.m
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
#import "SBViewController.h"

@interface SBViewControllerTests : SenTestCase
@end

@implementation SBViewControllerTests
{
    SBViewController *  _objUnderTest;
    id                  _mockAnimationManager;
}

- (void) setUp
{
    _objUnderTest = [[SBViewController alloc] init];
    [_objUnderTest view];
}

- (void) tearDown
{
    _objUnderTest = nil;
}

- (void) installMockAnimationManager
{
    _mockAnimationManager = [OCMockObject mockForClass:[SBAnimationManager class]];
    _objUnderTest.animationManager = _mockAnimationManager;
}

- (void) installNiceMockAnimationManager
{
    _mockAnimationManager = [OCMockObject niceMockForClass:[SBAnimationManager class]];
    _objUnderTest.animationManager = _mockAnimationManager;
}

- (void) sizeViewForiPhone
{
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 460);
}

- (void) sizeViewForiPhone5
{
    _objUnderTest.view.frame = CGRectMake(0, 0, 320, 548);
}

- (CGPoint) topRightCornerOfView
{
    CGRect viewFrame = _objUnderTest.view.frame;
    CGPoint topRight = CGPointMake(viewFrame.origin.x + viewFrame.size.width, 0);
    return topRight;
}

- (CGPoint) bottomLeftCornerOfView
{
    CGRect viewFrame = _objUnderTest.view.frame;
    CGPoint bottomLeft = CGPointMake(0, viewFrame.origin.y + viewFrame.size.height);
    return bottomLeft;
}

- (CGPoint) ballBottomLeftPosition
{
    CGSize ballSize = _objUnderTest.ballImageView.frame.size;
    CGPoint bottomLeft = [self bottomLeftCornerOfView];
    
    return CGPointMake(bottomLeft.x + ballSize.width / 2,
                       bottomLeft.y - ballSize.height / 2);
}

- (CGPoint) ballTopRightPosition
{
    CGSize ballSize = _objUnderTest.ballImageView.frame.size;
    CGPoint topRight = [self topRightCornerOfView];
    
    return CGPointMake(topRight.x - ballSize.width / 2, ballSize.height / 2);
}

- (void) test_onVerticalButtonPressed_callsAnimationManager
{
    [self sizeViewForiPhone];
    [self installMockAnimationManager];
    
    [[_mockAnimationManager expect] verticalBounce:_objUnderTest.ballImageView];
    
    [_objUnderTest onVerticalButtonPressed:_objUnderTest.verticalButton];
    
    [_mockAnimationManager verify];
}

- (void) test_onVerticalButtonPressed_hidesButtons
{
    [self installNiceMockAnimationManager];
    
    [_objUnderTest onVerticalButtonPressed:_objUnderTest.verticalButton];
    
    STAssertTrue(_objUnderTest.verticalButton.hidden, nil);
    STAssertTrue(_objUnderTest.horizontalButton.hidden, nil);
}

- (void) test_onHorizontalButtonPressed_callsAnimationManager
{
    [self sizeViewForiPhone];
    [self installMockAnimationManager];
    
    [[_mockAnimationManager expect] horizontalBounce:_objUnderTest.ballImageView];
    
    [_objUnderTest onHorizontalButtonPressed:_objUnderTest.horizontalButton];
    
    [_mockAnimationManager verify];
}

- (void) test_onHorizontalButtonPressed_hidesButtons
{
    [self installNiceMockAnimationManager];
    
    [_objUnderTest onHorizontalButtonPressed:_objUnderTest.horizontalButton];
    
    STAssertTrue(_objUnderTest.verticalButton.hidden, nil);
    STAssertTrue(_objUnderTest.horizontalButton.hidden, nil);
}

- (void) test_onFourCornerButtonPressed_callsAnimationManager
{
    [self sizeViewForiPhone];
    [self installMockAnimationManager];
    
    [[_mockAnimationManager expect] fourCornerBounce:_objUnderTest.ballImageView];
    
    [_objUnderTest onFourCornerButtonPressed:_objUnderTest.fourCornerButton];
    
    [_mockAnimationManager verify];
}

- (void) test_onFourCornerButtonPressed_hidesButtons
{
    [self installNiceMockAnimationManager];
    
    [_objUnderTest onFourCornerButtonPressed:_objUnderTest.fourCornerButton];
    
    STAssertTrue(_objUnderTest.verticalButton.hidden, nil);
    STAssertTrue(_objUnderTest.horizontalButton.hidden, nil);
}

- (void) test_animationComplete_showsButtons
{
    _objUnderTest.verticalButton.hidden = YES;
    _objUnderTest.horizontalButton.hidden = YES;
    
    [_objUnderTest animationComplete];
    
    STAssertFalse(_objUnderTest.verticalButton.hidden, nil);
    STAssertFalse(_objUnderTest.horizontalButton.hidden, nil);
}
@end
