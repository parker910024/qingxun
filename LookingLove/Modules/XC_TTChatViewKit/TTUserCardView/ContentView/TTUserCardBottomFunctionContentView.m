//
//  TTUserCardBottomFunctionContentView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardBottomFunctionContentView.h"

#import "TTUserCardBottomOpeButton.h"

//theme
#import "XCTheme.h"

//tool
#import "NSArray+Safe.h"

//mas
#import <Masonry/Masonry.h>

@interface TTUserCardBottomFunctionContentView ()

@property (nonatomic,assign) UserID uid;

@property (strong, nonatomic) UIStackView *userOpeSatckView;

@property (strong, nonatomic) UIView *topLine;

@end

@implementation TTUserCardBottomFunctionContentView

- (instancetype)initWithFrame:(CGRect)frame actionUid:(UserID)actionUid {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        self.uid = actionUid;
    }
    return self;
}

- (void)initView {
    [self addSubview:self.topLine];
    [self addSubview:self.userOpeSatckView];
}

- (void)initConstrations {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.height.mas_equalTo(1);
    }];
    [self.userOpeSatckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.right.mas_equalTo(self).inset(20);
        make.top.mas_equalTo(self.topLine.mas_bottom);
    }];
}

#pragma mark - user respone

- (void)onClickOpeButton:(UIButton *)sender {
    TTUserCardFunctionItem *item = [self.opeButtonArray safeObjectAtIndex:sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    if (item.actionBolock) {
        item.actionBolock(self.uid, indexPath, item);
    }
    
    if (item.actionUserBlock) {
        item.actionUserBlock(self.currentInfor, indexPath, item);
    }
}

#pragma mark - getter & setter

- (void)setOpeButtonArray:(NSMutableArray<TTUserCardFunctionItem *> *)opeButtonArray {
    _opeButtonArray = opeButtonArray;
    
    for (UIView *view in self.userOpeSatckView.arrangedSubviews) {
        [self.userOpeSatckView removeArrangedSubview:view];
    }
    
    for (TTUserCardFunctionItem *item in opeButtonArray) {
        TTUserCardBottomOpeButton *ope = [[TTUserCardBottomOpeButton alloc]init];
        ope.tag = [opeButtonArray indexOfObject:item];
        if (item.isDisable) {
            ope.enabled = NO;
            
        }else {
            ope.enabled = YES;
        }
        
        [ope setTitle:item.normalTitle forState:UIControlStateNormal];
        [ope setTitle:item.disableTitle forState:UIControlStateDisabled];
        [ope setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [ope addTarget:self action:@selector(onClickOpeButton:) forControlEvents:UIControlEventTouchUpInside];
        [ope.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [self.userOpeSatckView addArrangedSubview:ope];
    }
    
    if (opeButtonArray.count > 3) {
        self.userOpeSatckView.distribution = UIStackViewDistributionEqualSpacing;
    } else {
        self.userOpeSatckView.distribution = UIStackViewDistributionFillEqually;
    }
}

- (UIStackView *)userOpeSatckView {
    if (!_userOpeSatckView) {
        _userOpeSatckView = [[UIStackView alloc]init];
        _userOpeSatckView.axis = UILayoutConstraintAxisHorizontal;
        _userOpeSatckView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _userOpeSatckView;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _topLine;
}

@end
