//
//  TTVoiceMyView.m
//  XC_TTGameMoudle
//
//  Created by Macx on 2019/5/31.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceMyView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTVoiceMyView ()
/** bg */
@property (nonatomic, strong) UIImageView *bgImageView;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTVoiceMyView

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

#pragma mark - private method

- (void)initView {
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - getters and setters

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"voice_my_bg"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的声音";
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.layer.shadowColor = RGBACOLOR(18, 218, 224, 0.3).CGColor;
    }
    return _titleLabel;
}

@end
