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

#import "SBAnimationManager.h"
#import "SBAnimationManager+Internal.h"
#import "SBAnimationSegment.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCallCenter.h>

@implementation SBAnimationManager
{
    AVAudioPlayer * _bouncePlayer;
    CTCallCenter *  _callCenter;
}
@synthesize duration = _duration;
@synthesize animationSegments;
@synthesize currentSegmentIndex;
@synthesize viewBeingAnimated;
@synthesize bouncePlayer = _bouncePlayer;

- (id) init
{
    self = [super init];
    if (self)
    {
        _duration = 2.0;        // default animation duration
        
        // load the sound
        NSString *soundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bounce" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        NSError *error = nil;
        _bouncePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
        NSAssert(_bouncePlayer != nil, [error localizedDescription]);
        [_bouncePlayer prepareToPlay];
        _callCenter = [[CTCallCenter alloc] init];
    }
    return self;
}

- (CGPoint) homeInParent:(UIView *)view
{
    CGSize viewSize = view.bounds.size;
    return CGPointMake(viewSize.width / 2, viewSize.height / 2);
}

- (CGPoint) lowerLeftInParent:(UIView *)view
{
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(viewSize.width / 2, parentSize.height - viewSize.height / 2);
}

- (CGPoint) lowerRightInParent:(UIView *)view
{
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(parentSize.width - viewSize.width / 2, parentSize.height - viewSize.height / 2);
}

- (CGPoint) upperRightInParent:(UIView *)view
{
    CGSize parentSize = view.superview.bounds.size;
    CGSize viewSize = view.bounds.size;
    return CGPointMake(parentSize.width - viewSize.width / 2, viewSize.height / 2);
}

- (void) verticalBounce:(UIView *)view
{
    self.viewBeingAnimated = view;
    
    SBAnimationSegment *seg1 = [[SBAnimationSegment alloc] initWithPoint:[self lowerLeftInParent:view] playSoundAtEnd:YES];
    SBAnimationSegment *seg2 = [[SBAnimationSegment alloc] initWithPoint:[self homeInParent:view] playSoundAtEnd:NO];
    
    [self beginAnimations:@[seg1, seg2]];
}

- (void) horizontalBounce:(UIView *)view
{
    self.viewBeingAnimated = view;
    
    SBAnimationSegment *seg1 = [[SBAnimationSegment alloc] initWithPoint:[self upperRightInParent:view] playSoundAtEnd:YES];
    SBAnimationSegment *seg2 = [[SBAnimationSegment alloc] initWithPoint:[self homeInParent:view] playSoundAtEnd:NO];
    
    [self beginAnimations:@[seg1, seg2]];
}

- (void) fourCornerBounce:(UIView *)view
{
    self.viewBeingAnimated = view;
    
    SBAnimationSegment *seg1 = [[SBAnimationSegment alloc] initWithPoint:[self lowerLeftInParent:view] playSoundAtEnd:YES];
    SBAnimationSegment *seg2 = [[SBAnimationSegment alloc] initWithPoint:[self lowerRightInParent:view] playSoundAtEnd:YES];
    SBAnimationSegment *seg3 = [[SBAnimationSegment alloc] initWithPoint:[self upperRightInParent:view] playSoundAtEnd:YES];
    SBAnimationSegment *seg4 = [[SBAnimationSegment alloc] initWithPoint:[self homeInParent:view] playSoundAtEnd:NO];
    
    [self beginAnimations:@[seg1, seg2, seg3, seg4]];
}

- (void) beginAnimations:(NSArray *) segments
{
    self.animationSegments = segments;
    self.currentSegmentIndex = 0;
    [self beginCurrentAnimationSegment];
}

- (void) beginCurrentAnimationSegment
{
    SBAnimationSegment *currentAnimationSegment = self.animationSegments[self.currentSegmentIndex];
    
    [UIView animateWithDuration:_duration
                     animations:^(void)
                     {
                         self.viewBeingAnimated.center = currentAnimationSegment.destCenter;
                     }
                     completion:^(BOOL finished)
                     {
                         [self currentAnimationSegmentEnded:finished];
                     }];
}

- (void) currentAnimationSegmentEnded:(BOOL) complete
{
    SBAnimationSegment *currentAnimationSegment = self.animationSegments[self.currentSegmentIndex];
    if (complete)
    {
        if (currentAnimationSegment.playSoundAtEnd)
        {
            [self playBounceSound];
        }
        
        if (self.currentSegmentIndex + 1 < [self.animationSegments count])
        {
            self.currentSegmentIndex = self.currentSegmentIndex + 1;
            [self beginCurrentAnimationSegment];
        }
        else
        {
            [self.delegate animationComplete];
        }
    }
    else
    {
        self.viewBeingAnimated.center = [self homeInParent:self.viewBeingAnimated];
        [self.delegate animationComplete];
    }
}

- (BOOL) callInProgress
{
    return _callCenter.currentCalls != nil;
}

- (void) playBounceSound
{
    if (![self callInProgress])
    {
        [self.bouncePlayer play];
    }
}
@end
