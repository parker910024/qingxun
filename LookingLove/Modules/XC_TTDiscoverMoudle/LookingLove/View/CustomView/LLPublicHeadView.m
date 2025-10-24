//
//  LLPublicHeadView.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLPublicHeadView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCMacros.h"

@interface LLPublicHeadView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIView *separateLineView;
@end

@implementation LLPublicHeadView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraints];
        
        self.titleLabel.text = @"公聊大厅";
        [self.actionButton setImage:[UIImage imageNamed:@"discover_arrow_more"] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - event response
- (void)actionButtonTapped:(UIButton *)sender {
    !self.clickHandle ?: self.clickHandle();
}

#pragma mark - private method
- (void)initView {
    self.clipsToBounds = YES;
    self.backgroundColor = UIColor.whiteColor;
    
    /// 此句解决约束报错：width == 0 的问题
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.separateLineView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(15);
    }];
    
    [self.separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self);
    }];

    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
    }];
    
    [self.actionButton layoutIfNeeded];
    
    [self.actionButton setEnlargeEdgeWithTop:20 right:150 bottom:30 left:30];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
    }
    return _titleLabel;
}

- (UIButton *)actionButton {
    if (_actionButton == nil) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_actionButton setTitleColor:[XCTheme getMSThirdTextColor] forState:UIControlStateNormal];
        [_actionButton setImage:[UIImage imageNamed:@"discover_arrow_more"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _actionButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _actionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _actionButton;
}

- (UIView *)separateLineView {
    if (_separateLineView == nil) {
        _separateLineView = [[UIView alloc] init];
        _separateLineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _separateLineView;
}

@end
