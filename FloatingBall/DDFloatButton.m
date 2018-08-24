//
//  DDFloatButton.m
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import "DDFloatButton.h"

@interface DDFloatButton ()

@property (nonatomic, copy) ButtonAction cusAction;

@end

@implementation DDFloatButton

+ (instancetype)shareBtn {
    return [DDFloatButton buttonWithType:UIButtonTypeCustom];
}

+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName withAction:(ButtonAction)action {
    
    DDFloatButton *btn = [self shareBtn];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.cusAction = action;
    [btn addTarget:btn action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)btnAction:(DDFloatButton *)btn {
    if (btn.cusAction) {
        btn.cusAction();
    }
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect =  contentRect;
    CGFloat spacing = rect.size.width * 0.1;
    CGFloat titleHeight = rect.size.height * 0.25;
    
    return CGRectMake(spacing, rect.size.height - titleHeight, rect.size.width * 0.8, titleHeight);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGRect rect =  contentRect;
    CGFloat spacing = rect.size.height * 0.25 * 0.5;
    CGFloat titleHeight = rect.size.height * 0.75;
    
    return CGRectMake(spacing, 0, titleHeight, titleHeight);
}

@end
