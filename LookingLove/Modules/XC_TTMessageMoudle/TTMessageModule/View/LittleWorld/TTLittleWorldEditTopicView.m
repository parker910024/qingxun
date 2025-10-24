//
//  TTLittleWorldEditTopicView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldEditTopicView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTLittleWorldEditTopicView ()

/** 背景图*/
@property (nonatomic,strong) UIImageView *backImageView;
/** 编辑的按钮*/
@property (nonatomic,strong) UIButton *editButton;


@end

@implementation TTLittleWorldEditTopicView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.editButton];
}

- (void)initContrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(308);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(76);
    }];
    

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backImageView);
        make.top.mas_equalTo(self.backImageView).offset(20);
        make.bottom.mas_lessThanOrEqualTo(self.backImageView.mas_bottom).offset(0);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 32));
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-18);
    }];
}

#pragma mark - setters and getters
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"编辑" forState:UIControlStateSelected];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_editButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
         [_editButton setBackgroundColor:[UIColor whiteColor]];
        _editButton.layer.masksToBounds = YES;
        _editButton.layer.cornerRadius = 16;
        _editButton.layer.borderWidth = 2;
        _editButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _editButton.hidden = YES;
    }
    return _editButton;
}


- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = NO;
        _backImageView.image = [UIImage imageNamed:@"littleworld_topic_bg"];
    }
    return _backImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
