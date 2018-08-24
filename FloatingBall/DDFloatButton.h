//
//  DDFloatButton.h
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonAction)(void);

@interface DDFloatButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName withAction:(ButtonAction)action;

@end
