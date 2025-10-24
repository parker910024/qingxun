//
//  TTRedListItemView.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTRedListItemView.h"

#import "RoomRedListItem.h"

#import "UIButton+EnlargeTouchArea.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTRedListItemView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *shareButton;
@end

@implementation TTRedListItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutUI];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(88, 130);
}

- (void)setupUI {
    [self addSubview:self.bgImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.shadowImageView];
    [self addSubview:self.nickLabel];
    [self addSubview:self.shareButton];
}

- (void)layoutUI {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(73);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView).offset(46);
        make.left.right.mas_equalTo(self.bgImageView).inset(4);
    }];;
    
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(-5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(19);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.bgImageView);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(2);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(77.5);
        make.height.mas_equalTo(33.5);
    }];
}

/// 通过时间戳返回分秒
- (NSString *)timeWithStamp:(NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

#pragma mark - Action
- (void)didTapView {
    if ([self.delegate respondsToSelector:@selector(didSelectedItemView:)]) {
        [self.delegate didSelectedItemView:self];
    }
}

- (void)didClickShareButton {
    if ([self.delegate respondsToSelector:@selector(shareItemView:)]) {
        [self.delegate shareItemView:self];
    }
}

#pragma mark - Public
/// 已分享成功
- (void)hadShareSuccess {
    self.model.canShare = NO;
    self.shareButton.hidden = YES;
}

#pragma mark - Lazy Load
- (void)setModel:(RoomRedListItem *)model {
    _model = model;
    
    self.hidden = !model;
    
    self.timeLabel.text = [self timeWithStamp:model.startTime];;
    self.nickLabel.text = model.nick;
    self.shareButton.hidden = !model.canShare;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_item_ico"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)shadowImageView {
    if (_shadowImageView == nil) {
        _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_item_shadow"]];
        _shadowImageView.userInteractionEnabled = YES;
    }
    return _shadowImageView;
}

- (UILabel *)nickLabel {
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:12];
        _nickLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.6];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = UIColorFromRGB(0xFFBF48);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"room_red_list_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(didClickShareButton) forControlEvents:UIControlEventTouchUpInside];
        
        _shareButton.hidden = YES;
    }
    return _shareButton;
}

@end
