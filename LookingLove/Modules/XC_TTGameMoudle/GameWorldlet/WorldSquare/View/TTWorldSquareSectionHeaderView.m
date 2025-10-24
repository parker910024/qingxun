//
//  TTWorldSquareSectionHeaderView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareSectionHeaderView.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

@interface TTWorldSquareSectionHeaderView ()
@property (nonatomic, strong) UIButton *bgActionButton;
@end

@implementation TTWorldSquareSectionHeaderView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Event Responses
- (void)didClickActionButton {
    !self.moreActionBlock ?: self.moreActionBlock();
}

- (void)didClickBgActionButton:(UIButton *)sender {
    !self.moreActionBlock ?: self.moreActionBlock();
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.bgActionButton = [[UIButton alloc] init];
    [self.bgActionButton addTarget:self action:@selector(didClickBgActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgActionButton];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.actionButton];
}

- (void)initConstraints {
    [self.bgActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - Getters and Setters
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTMainTextColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIButton *)actionButton {
    if (_actionButton == nil) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"discover_arrow_more"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(didClickActionButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_actionButton setEnlargeEdgeWithTop:10 right:15 bottom:10 left:15];
    }
    return _actionButton;
}

@end
