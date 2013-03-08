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
#import <AudioToolbox/AudioToolbox.h>
#import "SBAnimationManager+Internal.h"

@implementation SBAnimationManager
{
    UIView *        _view;      // view being animated
    CGPoint         _viewHome;  // where to return view after bounce
    SystemSoundID   _soundID;   // ID for bounce sound
}
@synthesize duration = _duration;

- (id) init
{
    self = [super init];
    if (self)
    {
        _duration = 2.0;        // default animation duration
        
        // load the sound
        NSString *soundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"bounce" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL, &_soundID);
        NSAssert(status == 0, @"unexpected status: %ld", status);
    }
    return self;
}

- (void) dealloc
{
    // unload the sound
    AudioServicesDisposeSystemSoundID(_soundID);
}

- (void) bounceView:(UIView *)view to:(CGPoint)dest
{
    _view = view;
    _viewHome = view.center;
    
    [UIView animateWithDuration:_duration
                     animations:^(void)
                     {
                         _view.center = dest;
                     }
                     completion:^(BOOL finished)
                     {
                         [self playBounceSound];
                         
                         [UIView animateWithDuration:_duration
                                          animations:^(void)
                                          {
                                              _view.center = _viewHome;
                                          }
                                          completion:^(BOOL finished)
                                          {
                                              [self.delegate animationComplete];
                                          }];
                     }];
}

- (void) playBounceSound
{
    AudioServicesPlaySystemSound(_soundID);
}
@end
