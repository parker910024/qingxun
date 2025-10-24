//
//  XCCountdownView.m
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCCountdownView.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface XCCountdownView ()
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic ,strong) dispatch_source_t countdownTimer;
@property (nonatomic, assign) int timeLeft; // 暴击倒计时的剩余时间
@end
@implementation XCCountdownView

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
        self.layer.cornerRadius = 12.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

- (void)dealloc{
    NSLog(@"XCCountdownView dealloc");
}

#pragma mark - Public Method

- (void)updateTimeLeft:(int)timeLeft {
    self.timeLeft = timeLeft;
    self.countdownLabel.attributedText = [self createAttributeString:timeLeft];
    [self openCountdownWith:timeLeft];
}

- (void)stopCountdown {
    if (_countdownTimer != nil) {
        dispatch_source_cancel(_countdownTimer);
    }
}

#pragma mark - Private Method

- (void)setupSubviews {
    [self addSubview:self.countdownLabel];
}

- (void)setupSubviewsConstraints {
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
}

- (NSAttributedString *)createAttributeString:(int )time {
    NSDictionary *defaultAttribute = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *valueAttribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFFC909)};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"暴击倒计时:" attributes:defaultAttribute]];
    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@" %02d分%02d秒", time / 60, time % 60]] attributes:valueAttribute]];
    return attributedString;
}

- (void)openCountdownWith:(int)time {
    __block int timeLeft = time;
    if (self.countdownTimer != nil) {
        dispatch_source_cancel(self.countdownTimer);
    }
    //creat timer
    self.countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //每秒执行
    dispatch_source_set_timer(self.countdownTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    //handler
    @KWeakify(self);
    dispatch_source_set_event_handler(self.countdownTimer, ^{
        @KStrongify(self);
        if(timeLeft <= 0){//倒计时结束
            dispatch_source_cancel(self->_countdownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countdownLabel.attributedText = [self createAttributeString:0];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countdownLabel.attributedText = [self createAttributeString:timeLeft];
                timeLeft--;
            });
            
        }
    });
    dispatch_resume(self.countdownTimer);
}


#pragma mark - Getter

- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.font = [UIFont systemFontOfSize:12];
        _countdownLabel.attributedText = [self createAttributeString:0];
    }
    return _countdownLabel;
}


@end
