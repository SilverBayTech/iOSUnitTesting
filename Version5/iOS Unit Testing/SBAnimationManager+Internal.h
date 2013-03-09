//
//  SBAnimationManager+Internal.h
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 3/8/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

@interface SBAnimationManager()
@property (assign, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSArray *animationSegments;
@property (assign, nonatomic) unsigned int currentSegmentIndex;
@property (weak, nonatomic) UIView *viewBeingAnimated;
- (void) playBounceSound;
- (void) beginAnimations:(NSArray *) segments;
- (void) beginCurrentAnimationSegment;
- (void) currentAnimationSegmentEnded:(BOOL) complete;
@end

