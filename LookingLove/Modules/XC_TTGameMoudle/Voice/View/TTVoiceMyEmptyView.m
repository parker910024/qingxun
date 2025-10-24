//
//  TTVoiceMyEmptyView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/6/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMyEmptyView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>

@interface TTVoiceMyEmptyView ()
/** 空图片 */
@property (nonatomic, strong) UIImageView *emptyImageView;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** 去录制按钮 */
@property (nonatomic, strong) UIButton *recordButton;
@end

@implementation TTVoiceMyEmptyView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickRecordButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceMyEmptyView:didClickRecordButton:)]) {
        [self.delegate voiceMyEmptyView:self didClickRecordButton:button];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.emptyImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.recordButton];
}

- (void)initConstrations {
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(145);
        make.top.mas_equalTo(220 * KScreenWidth/375 + kSafeAreaTopHeight);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(4);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(52);
    }];
}

#pragma mark - getters and setters

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.image = [UIImage imageNamed:@"voice_my_empty"];
    }
    return _emptyImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = RGBACOLOR(255, 255, 255, 0.9);
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.text = @"你还没有录制声音哦，赶快去录制一个吧~";
    }
    return _tipLabel;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        _recordButton.layer.cornerRadius = 20;
        _recordButton.backgroundColor = [UIColor whiteColor];
        _recordButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_recordButton setTitle:@"去录制" forState:UIControlStateNormal];
        [_recordButton setTitleColor:RGBCOLOR(50, 236, 217) forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(didClickRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

@end
