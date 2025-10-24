//
//  CTInputAudioRecordIndicatorView.m
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CTInputAudioRecordIndicatorView.h"
#import "UIImage+NIMKit.h"

#define CTKit_ViewWidth 160
#define CTKit_ViewHeight 110

#define CTKit_TimeFontSize 30
#define CTKit_TipFontSize 15

@interface CTInputAudioRecordIndicatorView(){
    UIImageView *_backgrounView;
    UIImageView *_tipBackgroundView;
}

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation CTInputAudioRecordIndicatorView
- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = CGRectMake(0, 0, CTKit_ViewWidth, CTKit_ViewHeight);
        _backgrounView = [[UIImageView alloc] initWithImage:[UIImage nim_imageInKit:@"icon_input_record_indicator"]];
        [self addSubview:_backgrounView];
        
        _tipBackgroundView = [[UIImageView alloc] initWithImage:[UIImage nim_imageInKit:@"icon_input_record_indicator_cancel"]];
        _tipBackgroundView.hidden = YES;
        _tipBackgroundView.frame = CGRectMake(0, CTKit_ViewHeight - CGRectGetHeight(_tipBackgroundView.bounds), CTKit_ViewWidth, CGRectGetHeight(_tipBackgroundView.bounds));
        [self addSubview:_tipBackgroundView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:CTKit_TimeFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:CTKit_TipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];
        
        self.phase = CTAudioRecordPhaseEnd;
    }
    return self;
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger minutes = (NSInteger)recordTime / 60;
    NSInteger seconds = (NSInteger)recordTime % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
}

- (void)setPhase:(CTAudioRecordPhase)phase {
    if(phase == CTAudioRecordPhaseStart) {
        [self setRecordTime:0];
    } else if(phase == CTAudioRecordPhaseCancelling) {
        _tipLabel.text = @"松开手指，取消发送";
        _tipBackgroundView.hidden = NO;
    } else {
        _tipLabel.text = @"手指上滑，取消发送";
        _tipBackgroundView.hidden = YES;
    }
}

- (void)layoutSubviews {
    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(CTKit_ViewWidth, MAXFLOAT)];
    _timeLabel.frame = CGRectMake(0, 36, CTKit_ViewWidth, size.height);
    size = [_tipLabel sizeThatFits:CGSizeMake(CTKit_ViewWidth, MAXFLOAT)];
    _tipLabel.frame = CGRectMake(0, CTKit_ViewHeight - 10 - size.height, CTKit_ViewWidth, size.height);
}


@end
