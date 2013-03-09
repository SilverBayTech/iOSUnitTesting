//
//  SBAnimationSegment.m
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 3/8/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

#import "SBAnimationSegment.h"

@implementation SBAnimationSegment
@synthesize destCenter = _destCenter;
@synthesize playSoundAtEnd = _playSoundAtEnd;

- (id) initWithPoint:(CGPoint) destCenter playSoundAtEnd:(BOOL) playSoundAtEnd
{
    self = [super init];
    if (self)
    {
        _destCenter = destCenter;
        _playSoundAtEnd = playSoundAtEnd;
    }
    return self;
}

@end
