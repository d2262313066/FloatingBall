//
//  DDBackView.m
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import "DDBackView.h"
#import "DDConfig.h"


@interface DDBackView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DDBackView

-(void)drawRect:(CGRect)rect {
    
    UIColor *color = RGB(235, 235, 235);
    [color set];
    if (self.backColor) {
        [self.backColor set];
    }
    float radius = BallWH/2 + 5;
    /** center：弧线圆心坐标                  M_PI -> 理解为180度,坐标系
     radius：弧线半径                        0          -> (1  ,0)
     startAngle：弧线起始角度                 M_PI/2     -> (0  ,-1)
     endAngle：弧线结束角度                   M_PI       -> (-1 ,0)
     clockwise：是否顺时针绘制                M_PI * 1.5 -> (0  ,1);
     */
    //右弧
    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(BallWH/2, BallWH/2) radius:radius startAngle:M_PI/4 endAngle:M_PI * 7 / 4 clockwise:NO];
//
    [_path addLineToPoint:CGPointMake(self.frame.size.width - BallWH/2 * sin(M_PI/4), BallWH/2 - radius * sin(M_PI/4))];
    [_path addArcWithCenter:CGPointMake(self.frame.size.width - radius - 1, BallWH/2) radius:radius startAngle:M_PI * 7/4 endAngle:M_PI/4 clockwise:YES];
    
    [_path closePath];
    [_path stroke];
    [_path fill];
}

@end
