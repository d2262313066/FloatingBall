//
//  DDAnimation.m
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/22.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import "DDAnimation.h"

@implementation DDAnimation

+ (CAAnimation *)animationWithType:(DDUnFoldType)type {
    
    switch (type) {
        case DDUnFoldTypeRotate: {
            return [self getRotateAnimation];
            break;
        }
        case DDUnFoldTypeShuttle: {
            return [self getShuttleAnimation];
            break;
        }
        default:
            break;
    }
    return [self getRotateAnimation];
}

static int direction = 1;

+ (CAAnimation *)getRotateAnimation {
    
    CABasicAnimation *basicAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimate.duration = 0.5;
    basicAnimate.fromValue = [NSNumber numberWithFloat:0];
    basicAnimate.toValue = [NSNumber numberWithFloat:M_PI/180 * 720 * direction];
    
    direction = direction * -1;
    return basicAnimate;
}

+ (CAAnimation *)getShuttleAnimation {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObjectsFromArray:@[@1,@0,@1]];
    animate.duration = 0.5;
    animate.repeatCount = 1;
    animate.values = arr;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    return animate;
}

@end

