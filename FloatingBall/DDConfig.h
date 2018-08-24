//
//  DDConfig.h
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/22.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#ifndef DDConfig_h
#define DDConfig_h

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define BtnWH 55
#define Device_Is_iPhoneX [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO
#define ScreenW ([UIScreen mainScreen].bounds.size.width)
#define ScreenH ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSInteger,BallStatus) {
    BallStatusActivity,
    BallStatusLeftLock,
    BallStatusRightLock
};

#define BallWH 75

typedef NS_ENUM(NSInteger,DDUnFoldType) {
    DDUnFoldTypeRotate, //旋转
    DDUnFoldTypeShuttle //穿梭
};


#endif /* DDConfig_h */
