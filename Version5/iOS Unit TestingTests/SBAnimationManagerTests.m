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
#import "SBAnimationSegment.h"

#define ANIMATION_DURATION  0.1

@interface SBAnimationManagerTests : SenTestCase
@end

@implementation SBAnimationManagerTests
{
    SBAnimationManager *    _objUnderTest;
    id                      _mockDelegate;
    UIView *                _parentView;
    UIView *                _viewBeingAnimated;
    NSArray *               _savedSegments;
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

- (void) saveAnimationSegments:(NSArray *) segments
{
    _savedSegments = segments;
}

- (void) test_verticalBounce_startsAnimationToLowerLeftCenter
{
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint lowerLeftCenter = CGPointMake(_viewBeingAnimated.bounds.size.width / 2,
                                          parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] beginAnimations:OCMOCK_ANY];
    
    [wrapper verticalBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (unsigned int)2, nil);
    
    SBAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, lowerLeftCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, lowerLeftCenter.y, nil);
    STAssertTrue(seg1.playSoundAtEnd, nil);
    
    SBAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg2.playSoundAtEnd, nil);
}

- (void) test_horizontalBounce_startsAnimationToUpperRight
{
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint upperRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                          _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] beginAnimations:OCMOCK_ANY];
    
    [wrapper horizontalBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (unsigned int)2, nil);
    
    SBAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, upperRightCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, upperRightCenter.y, nil);
    STAssertTrue(seg1.playSoundAtEnd, nil);
    
    SBAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg2.playSoundAtEnd, nil);
}

- (void) test_fourCenterBounce_startsAnimationToFourCenters
{
    CGSize parentSize = _parentView.frame.size;
    CGPoint originalViewCenter = _viewBeingAnimated.center;
    CGPoint lowerLeftCenter = CGPointMake(_viewBeingAnimated.bounds.size.width / 2,
                                          parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    CGPoint lowerRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                           parentSize.height - _viewBeingAnimated.bounds.size.height / 2);
    CGPoint upperRightCenter = CGPointMake(parentSize.width - _viewBeingAnimated.bounds.size.width / 2,
                                           _viewBeingAnimated.bounds.size.height / 2);
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[[wrapper expect] andCall:@selector(saveAnimationSegments:) onObject:self] beginAnimations:OCMOCK_ANY];
    
    [wrapper fourCornerBounce:_viewBeingAnimated];
    
    [_mockDelegate verify];
    [wrapper verify];
    
    STAssertEquals([_savedSegments count], (unsigned int)4, nil);
    
    SBAnimationSegment *seg1 = _savedSegments[0];
    STAssertEquals(seg1.destCenter.x, lowerLeftCenter.x, nil);
    STAssertEquals(seg1.destCenter.y, lowerLeftCenter.y, nil);
    STAssertTrue(seg1.playSoundAtEnd, nil);
    
    SBAnimationSegment *seg2 = _savedSegments[1];
    STAssertEquals(seg2.destCenter.x, lowerRightCenter.x, nil);
    STAssertEquals(seg2.destCenter.y, lowerRightCenter.y, nil);
    STAssertTrue(seg2.playSoundAtEnd, nil);
    
    SBAnimationSegment *seg3 = _savedSegments[2];
    STAssertEquals(seg3.destCenter.x, upperRightCenter.x, nil);
    STAssertEquals(seg3.destCenter.y, upperRightCenter.y, nil);
    STAssertTrue(seg3.playSoundAtEnd, nil);
    
    SBAnimationSegment *seg4 = _savedSegments[3];
    STAssertEquals(seg4.destCenter.x, originalViewCenter.x, nil);
    STAssertEquals(seg4.destCenter.y, originalViewCenter.y, nil);
    STAssertFalse(seg4.playSoundAtEnd, nil);
}

- (void) test_beginAnimations_setsUpAndStarts
{
    SBAnimationSegment *seg1 = [[SBAnimationSegment alloc] initWithPoint:CGPointMake(10,10) playSoundAtEnd:YES];
    SBAnimationSegment *seg2 = [[SBAnimationSegment alloc] initWithPoint:CGPointMake(0,0) playSoundAtEnd:NO];
    
    _objUnderTest.currentSegmentIndex = 99; // make sure it gets reset

    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] beginCurrentAnimationSegment];
    
    [wrapper beginAnimations:@[seg1,seg2]];
    
    [wrapper verify];
    STAssertEquals([wrapper currentSegmentIndex], (unsigned int)0, nil);
    
    NSArray *segments = [wrapper animationSegments];
    
    STAssertEquals([segments count], (unsigned int) 2, nil);
    STAssertEquals(segments[0], seg1, nil);
    STAssertEquals(segments[1], seg2, nil);
}

- (void) test_beginCurrentAnimationSegment_animatesAndCallsback
{
    SBAnimationSegment *seg1 = [[SBAnimationSegment alloc] initWithPoint:CGPointMake(10,20) playSoundAtEnd:YES];
    _objUnderTest.animationSegments = @[seg1];
    _objUnderTest.viewBeingAnimated = _viewBeingAnimated;
    
    id wrapper = [OCMockObject partialMockForObject:_objUnderTest];
    [[wrapper expect] currentAnimationSegmentEnded:NO];

    [wrapper beginCurrentAnimationSegment];
    
    [self waitForAnimations];
    
    [wrapper verify];
    
    CGPoint viewCenter = _viewBeingAnimated.center;
    STAssertEquals(viewCenter.x, 10.0F, nil);
    STAssertEquals(viewCenter.y, 20.0F, nil);
}
@end
