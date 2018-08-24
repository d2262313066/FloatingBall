//
//  ViewController.m
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import "ViewController.h"
#import "DDFloatingBall.h"
#import "DDBackView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDFloatingBall *ball = [DDFloatingBall shareBallManager];
    DDFloatButton *btn = [DDFloatButton buttonWithTitle:@"title1" imageName:@"YH" withAction:^{
        NSLog(@"click");
    }];

    DDFloatButton *btn2 = [DDFloatButton buttonWithTitle:@"title2" imageName:@"YH" withAction:^{
        NSLog(@"click2");
    }];
    
    ball.actions = @[btn,btn2];
    ball.unfoldType = DDUnFoldTypeShuttle;
    
    [ball initBallWindow];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


- (void)getShuttle:(UIView *)view {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObjectsFromArray:@[@1,@0,@1]];
    animate.duration = 0.5;
    animate.repeatCount = 1;
    animate.values = arr;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    [view.layer addAnimation:animate forKey:nil];
}


@end
