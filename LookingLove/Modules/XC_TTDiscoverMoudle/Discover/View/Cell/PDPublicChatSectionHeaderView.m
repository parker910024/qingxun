//
//  PDPublicChatSectionHeaderView.m
//  TuTu
//
//  Created by lvjunhang on 2018/12/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "PDPublicChatSectionHeaderView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"

@interface PDPublicChatSectionHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIView *separateLineView;
@end

@implementation PDPublicChatSectionHeaderView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraints];
        
        self.titleLabel.text = @"交友大厅";
        
        self.subTitleLabel.text = @"目光所致都是你";
        self.separateLineView.hidden = YES;
        
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
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.separateLineView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    [self.separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(12);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.separateLineView.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(self.actionButton.mas_left).offset(-12);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
    }];
    
    [self.actionButton layoutIfNeeded];
    
    [self.actionButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
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

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = [XCTheme getMSThirdTextColor];
        _subTitleLabel.hidden = YES;
    }
    return _subTitleLabel;
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
        _separateLineView.backgroundColor = [XCTheme getLineDefaultGrayColor];
        _separateLineView.hidden = YES;
    }
    return _separateLineView;
}

@end
