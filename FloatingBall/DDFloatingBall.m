//
//  DDFloatingBall.m
//  FloatingBall
//
//  Created by Dahao Jiang on 2018/8/21.
//  Copyright © 2018年 Dahao Jiang. All rights reserved.
//

#import "DDFloatingBall.h"
#import "DDBackView.h"
#import "DDAnimation.h"

@interface DDFloatingBall()
/** 悬浮球的状态 */
@property (nonatomic, assign) BallStatus ballStatus;
/** 悬浮球的最后坐标 */
@property (nonatomic, assign) CGPoint lastPoint;
/** 是否打开 */
@property (nonatomic, assign) BOOL isOpen;
/** 悬浮窗 */
@property (nonatomic, strong) UIView *ballView;
/** 悬浮窗背版 */
@property (nonatomic, strong) DDBackView *backView;
/** 悬浮球 */
@property (nonatomic, strong) UIImageView *ballIgv;
/** 悬浮窗缩边定时器 */
@property (nonatomic, strong) NSTimer *pullOverTimer;

@property (nonatomic, strong) UIWindow *keyWindow;

@property (nonatomic, strong) UIWindow *cusWindow;

@end

@implementation DDFloatingBall
{
    NSString *ballName;
}

+(instancetype)shareBallManager {
    static DDFloatingBall *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[DDFloatingBall alloc] init];
    });
    return mgr;
}

-(void)initBallWindow {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    if (self.ballView) {
        return ;
    } else {
        self.ballView = [[UIView alloc] initWithFrame:CGRectMake(-BallWH/2, 50, BallWH, BallWH)];
        _lastPoint = self.ballView.center;
    }
    
    ballName = @"Ball7";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setBallUI];
    });
    

}

- (void)orientationDidChange {
    if (Device_Is_iPhoneX) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeRight) {
            self.ballView.center = CGPointMake(28, (ScreenH - BallWH) / 2);
        } else {
            self.ballView.center = CGPointMake(0, (ScreenH - BallWH / 2));
        }
    }
}

- (void)setBallUI {
    _ballStatus = BallStatusLeftLock;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.ballView addGestureRecognizer:tap];
    [self.ballView addGestureRecognizer:pan];
    
//    self.keyWindow = [[UIApplication sharedApplication] delegate].window;
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self.keyWindow addSubview:self.ballView];
    
    _ballIgv = [[UIImageView alloc] initWithFrame:self.ballView.bounds];
    if (_customImageName) {
        UIImage *img = [UIImage imageNamed:_customImageName];
        _ballIgv.image = img;
    } else {
        _ballIgv.image = [UIImage imageNamed:@"Ball7"];
    }
    _ballIgv.alpha = 0.6;
    [self.ballView addSubview:_ballIgv];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_isOpen) {
        //TODO::添加收回动画
        return;
    }
    
    _lastPoint = self.ballView.center;
    _ballIgv.alpha = 1;
    [self addBallAnimation];

    //悬浮窗背版
    DDBackView *backView = [[DDBackView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    if (self.backColor) {
        backView.backColor = self.backColor;
    }
    self.backView = backView;
    
    [self.ballView addSubview:self.backView];
    
    DDFloatButton *closeBtn = [DDFloatButton buttonWithTitle:@"收起" imageName:@"SQ" withAction:^{
        [self closeBallWindow];
        //TODO::收起
    }];
    closeBtn.tag = 101;
    
    for (DDFloatButton *btn in self.actions) {
        btn.frame = CGRectMake(0, 6, BtnWH, BtnWH);
        btn.alpha = 0;
        [self.backView addSubview:btn];
    }
    [self.backView addSubview:closeBtn];
    
    [UIView animateWithDuration:self.expandDuration?:0.5 animations:^{
        self.ballView.frame = CGRectMake(20, 20, (4 + self.actions.count) * BtnWH, BallWH);
        self.backView.frame = CGRectMake(0, 0, (4 + self.actions.count) * BtnWH, BallWH);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger i = 0;
        for (DDFloatButton *btn in self.backView.subviews) {
            if (btn.tag != 101) {
                btn.hidden = NO;
                btn.alpha = 1;
                btn.frame = CGRectMake(BtnWH/2 * 3 + i * (BtnWH + 3), 6, BtnWH, BtnWH);
                i ++;
            } else {
                btn.frame = CGRectMake(BtnWH/2 * 3 + self.actions.count * (BtnWH + 5), 6, BtnWH, BtnWH);
            }
        }
    });
    
    if (self.pullOverTimer != nil) {
        [self.pullOverTimer invalidate];
        self.pullOverTimer = nil;
    }
    
    _isOpen = YES;
    
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (_isOpen) {
        return;
    }
    CGPoint point = [pan translationInView:[UIApplication sharedApplication].keyWindow];
    [pan setTranslation:CGPointZero inView:[UIApplication sharedApplication].keyWindow];
    
    self.ballView.center = CGPointMake(self.ballView.center.x + point.x, self.ballView.center.y + point.y);
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self becomeMove];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        //记录移动完之后的位置
        _lastPoint = self.ballView.center;
        [self becomeDock];
    }
}

- (void)becomeMove {
    if (_isOpen) {
        return ;
    }
    if (_ballStatus == BallStatusLeftLock) { //靠左
        self.ballView.center = CGPointMake(BallWH/2, self.ballView.center.y);
    } else { //靠右
        self.ballView.center = CGPointMake([UIScreen mainScreen].bounds.size.width - BallWH /2 , self.ballView.center.y);
    }
    
    _ballStatus = BallStatusActivity;
    
    //移动的时候，取消缩回计时器
    if (self.pullOverTimer != nil) {
        [self.pullOverTimer invalidate];
        self.pullOverTimer = nil;
    }
}

- (void)becomeDock {
    if (_isOpen) {
        return ;
    }
    //判断当前位置
    float x = self.ballView.center.x;
    float y = self.ballView.center.y;
    
    //防止球无法点击
    if (y < 25) {
        y += 35;
    } else if (y + BallWH/2 > ScreenH) {
        y -= 35;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"currentScreenY"] = @(y);
    
    //球锁定状态
    _ballStatus =       (x > ScreenW / 2) ? BallStatusRightLock : BallStatusLeftLock;
    //判断球在左边还是右边
    float ballx =       _ballStatus == BallStatusRightLock ? (ScreenW - BallWH /2) : BallWH / 2;
    //iphoneX适配
    float adaptOffset = _ballStatus == BallStatusRightLock ? -28 : 28;

    [UIView animateWithDuration:.3 animations:^{
        if (Device_Is_iPhoneX) {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationLandscapeRight) {
                self.ballView.center = CGPointMake(ballx, y);
            } else {
                self.ballView.center = CGPointMake(ballx + adaptOffset, y);
            }
        } else {
            self.ballView.center = CGPointMake(ballx, y);
        }
    }];
    self.pullOverTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(pullDownAction:) userInfo:dic repeats:NO];
}

- (void)closeBallWindow {
    [self addBallAnimation];
    
    [UIView animateWithDuration:.5 animations:^{
        self.backView.frame = CGRectMake(0, 0, 0, BallWH);
        self.backView.alpha = 0;
        for (DDFloatButton *btn in self.backView.subviews) {
            btn.frame = CGRectMake(0, 6, BtnWH, BtnWH);
            btn.alpha = 0;
        }
    }];
    
    float x = self.lastPoint.x;
    float ballx = (x > ScreenW/2) ? (ScreenW - BallWH/2) : -BallWH/2;
    float adaptOffset = (x > ScreenW/2) ? -28 : 28;
    
    float y = self.lastPoint.y -BallWH/2;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5 animations:^{
        if (Device_Is_iPhoneX) {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationLandscapeRight) {
                self.ballView.frame = CGRectMake(ballx + adaptOffset, y, BallWH, BallWH);
            } else {
                self.ballView.frame = CGRectMake(ballx, y, BallWH, BallWH);
            }
        } else {
            self.ballView.frame = CGRectMake(ballx, y, BallWH, BallWH);
        }
        weakSelf.ballIgv.alpha = 0.6;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (DDFloatButton *btn in self.backView.subviews) {
            [btn removeFromSuperview];
        }
        [self.backView removeFromSuperview];
    });
    
    _isOpen = NO;
}



- (void)pullDownAction:(NSTimer *)timer {
    float currentScreenY = [timer.userInfo[@"currentScreenY"] floatValue];
    
    float adaptOffset = self.ballStatus == BallStatusLeftLock ? 28 : -28;
    float ballx = self.ballStatus == BallStatusLeftLock ? 0 : ScreenW;
    
    [UIView animateWithDuration:.3 animations:^{
        if (Device_Is_iPhoneX) {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationLandscapeRight) {
                self.ballView.center = CGPointMake(adaptOffset, currentScreenY);
            } else {
                self.ballView.center = CGPointMake(ballx, currentScreenY);
            }
        } else {
            self.ballView.center = CGPointMake(ballx, currentScreenY);
        }
        
    }];
}

- (void)addBallAnimation {
    CAAnimation *animate = [DDAnimation animationWithType:_unfoldType];
    [self.ballIgv.layer addAnimation:animate forKey:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}




@end
