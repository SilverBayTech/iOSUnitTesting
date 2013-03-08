//
//  SBViewController.m
//  iOS Unit Testing
//
//  Copyright 2012 Kevin Hunter
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

#import "SBViewController.h"

@implementation SBViewController
{
    CGPoint         _ballHome;  // ball's home position
}

- (id) init
{
    self = [super initWithNibName:@"SBViewController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self)
    {
        self.animationManager = [[SBAnimationManager alloc] init];
        self.animationManager.delegate = self;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _ballHome = self.ballImageView.center;
}

// start bounce toward bottom
- (IBAction)onVerticalButtonPressed:(id)sender
{
    // Destination is bottom edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(_ballHome.x, viewSize.height - ballSize.height / 2);
    [self bounceBallTo:dest];
}

// start bounce toward top.  
- (IBAction)onHorizontalButtonPressed:(id)sender
{
    // Destination is right edge of screen minus radius of ball
    CGSize ballSize = self.ballImageView.bounds.size;
    CGSize viewSize = self.view.bounds.size;
    CGPoint dest = CGPointMake(viewSize.width - ballSize.width / 2, _ballHome.y);
    [self bounceBallTo:dest];
}

- (void) bounceBallTo:(CGPoint) dest
{
    self.verticalButton.hidden = YES;
    self.horizontalButton.hidden = YES;
    
    [self.animationManager bounceView:self.ballImageView to:dest];
}

- (void) animationComplete
{
    self.verticalButton.hidden = NO;
    self.horizontalButton.hidden = NO;
}
@end
