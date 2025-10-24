//
//  XCBoxCirtProgressView.m
//  XC_MSRoomMoudle
//
//  Created by KevinWang on 2019/4/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCBoxCirtProgressView.h"
#import "UIImage+Resize.h"
#import "UIView+NTES.h"
#import "XCTheme.h"
#import "XCMacros.h"


@interface XCBoxCirtProgressView ()

/**
 进度底图
 */
@property (nonatomic, strong) UIImageView *bgImageView;
/**
 更新进度
 */
@property (nonatomic, strong) UIImageView *updateImageView;
/**
 时间
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 活动总时长，单位秒（目前是30分钟）
 */
@property (nonatomic, assign) int totalTime;

/**
 活动已经开始的时间，单位秒
 */
@property (nonatomic, assign) int alreadyStartedTime;

/**
 计时器
 */
@property (nonatomic ,strong)dispatch_source_t progressTimer;

@end

@implementation XCBoxCirtProgressView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}


- (void)dealloc{
    if (_progressTimer != nil) {
        dispatch_source_cancel(_progressTimer);
    }
}


#pragma mark - puble method
- (void)startProgressWithTotalTime:(int)totalTime alreadyStartedTime:(int)alreadyStartedTime{
    self.totalTime = totalTime;
    self.alreadyStartedTime = alreadyStartedTime;

    [self openCountdown];
    
}

- (void)endTimer{
    if (_progressTimer != nil) {
        dispatch_source_cancel(_progressTimer);
    }
}

#pragma mark - Private

- (void)openCountdown{
    
    __block int time = self.totalTime-self.alreadyStartedTime; //倒计时时间 30-14
    if (_progressTimer != nil) {
        dispatch_source_cancel(_progressTimer);
    }
    //creat timer
    _progressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //每秒执行
    dispatch_source_set_timer(_progressTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    //handler
    @KWeakify(self);
    dispatch_source_set_event_handler(_progressTimer, ^{
        @KStrongify(self);
        if(time <= 0){//倒计时结束
            dispatch_source_cancel(self->_progressTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
            
                self.timeLabel.text = [NSString stringWithFormat:@"暴击倒计时：%02d分%02d秒",time / 60 ,time % 60];
                
                CGFloat width = (self.totalTime - time)*1.0 / self.totalTime * kProgressViewWidth;
                self.updateImageView.frame = CGRectMake(0, 0, width, 13);
                
                [UIView animateWithDuration:0.98 animations:^{
                    
                    [self layoutIfNeeded];
                }];
                time--;
            });
            
        }
    });
    dispatch_resume(_progressTimer);
}

- (void)setupSubviews{
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.updateImageView];
    [self addSubview:self.timeLabel];
}
- (void)setupSubviewsConstraints{
    
    
    self.bgImageView.frame = CGRectMake(0, 0, kProgressViewWidth, 13);
    
    self.timeLabel.frame = CGRectMake(0, 0, kProgressViewWidth, 12);
    self.timeLabel.top = self.bgImageView.bottom+6;
    
    self.updateImageView.frame = CGRectMake(0, 0, 0, 13);
}

#pragma mark - Getter
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"box_cirt_progress_bg"];
    }
    return _bgImageView;
}
- (UIImageView *)updateImageView{
    if (!_updateImageView) {
        _updateImageView = [[UIImageView alloc] init];
        _updateImageView.image = [UIImage resizeWithImage:[UIImage imageNamed:@"box_cirt_progress_update"]];
    }
    return _updateImageView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"暴击倒计时：30分00秒";
    }
    return _timeLabel;
}

@end
