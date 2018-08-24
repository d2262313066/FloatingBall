//
//  DDFloatingBall.h
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFloatButton.h"
#import "DDConfig.h"


@interface DDFloatingBall : NSObject

+ (instancetype)shareBallManager;

- (void)initBallWindow;

/** 自定义悬浮球,如不定义按默认处理 */
@property (nonatomic, strong) NSString *customImageName;
/** 展开样式,默认使用 DDUnFoldTypeRotate */
@property (nonatomic, assign) DDUnFoldType unfoldType;
/** 展开的背板颜色 */
@property (nonatomic, copy) UIColor *backColor;
/** 按钮的集合 */
@property (nonatomic, strong) NSArray<DDFloatButton *> *actions;
/** 展开速度,默认0.5s */
@property (nonatomic, assign) float expandDuration;



@end
