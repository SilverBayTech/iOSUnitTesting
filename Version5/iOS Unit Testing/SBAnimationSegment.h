//
//  SBAnimationSegment.h
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 3/8/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAnimationSegment : NSObject
@property (readonly, nonatomic) CGPoint destCenter;
@property (readonly, nonatomic) BOOL playSoundAtEnd;
- (id) initWithPoint:(CGPoint) destCenter playSoundAtEnd:(BOOL) playSoundAtEnd;
@end
