//
//  TTMasterTimeView.m
//  TTPlay
//
//  Created by Macx on 2019/2/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterTimeView.h"

#import "MentoringShipCore.h"
#import "MentoringShipCoreClient.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTMasterTimeView ()<MentoringShipCoreClient>
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** icon */
@property (strong, nonatomic) UIImageView *iconImageView;
/** time */
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation TTMasterTimeView

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
// 更新为"去送礼"状态
- (void)updateSendGiftStatus {
    self.timeLabel.text = @"免费送";
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.iconImageView.image = [UIImage imageNamed:@"room_master_gift_icon"];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75);
    }];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTimeView:)]];
}

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - MentoringShipCoreClient
/** 师徒任务3, 倒计时回调 */
- (void)mentoringShipCutdownOpen:(NSInteger)time {
    NSInteger minute = time / 60;
    NSInteger second = (time % 60);
    NSString *timeStr = [NSString stringWithFormat:@"%01zd:%02zd", minute, second];
    self.timeLabel.text = timeStr;
}

/** 师徒任务3, 倒计时结束, 消息页监听并上报任务 */
- (void)mentoringShipCutdownFinishWithMasterUid:(long long)masterUid apprenticeUid:(long long)apprenticeUid {
    [self updateSendGiftStatus];
}

#pragma mark - event response
- (void)didTapTimeView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterTimeView:didClickTimeView:)]) {
        [self.delegate masterTimeView:self didClickTimeView:tap.view];
    }
    
    GetCore(MentoringShipCore).countDownStatus = TTMasterCountDownStatusDefult;
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.iconImageView];
    [self.bgImageView addSubview:self.timeLabel];
    
    self.timeLabel.text = @"5:00";
    
    AddCoreClient(MentoringShipCoreClient, self);
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.bgImageView);
        make.width.height.mas_equalTo(13);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgImageView);
        make.left.mas_equalTo(25);
    }];
}

#pragma mark - getters and setters

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_master_time_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"room_master_time_icon"];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _timeLabel;
}

@end
