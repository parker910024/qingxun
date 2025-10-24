//
//  TTPersonBottomView.m
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonalBottomView.h"

#import <Masonry/Masonry.h>
//#import "BaseCore.h"
#import "UserInfo.h"
#import "XCTheme.h"
#import "PLTimeUtil.h"

@interface TTPersonalBottomView()
@property (nonatomic, strong) TTPersonalTopBottomButton  *familyBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *incomeBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *rechargeBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *dressupBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *nobileBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *settingBtn;
@property (strong , nonatomic) UILabel *expriLabel;
@end

@implementation TTPersonalBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    [self addSubview:self.familyBtn];
    [self addSubview:self.incomeBtn];
    [self addSubview:self.rechargeBtn];
    [self addSubview:self.dressupBtn];
    [self addSubview:self.nobileBtn];
    [self addSubview:self.settingBtn];
    [self addSubview:self.expriLabel];
    [self makeConstriants];
}

- (void)makeConstriants {
    CGFloat height = 80;
    CGFloat width = 88;
    [self.familyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self);
    }];
    [self.incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.centerX.top.mas_equalTo(self);
    }];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
    }];
    
    [self.dressupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self.familyBtn.mas_bottom);
    }];
    [self.nobileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.familyBtn.mas_bottom);

    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(self.familyBtn.mas_bottom);
        make.right.mas_equalTo(self).offset(-15);
    }];
     [self.expriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self);
         make.top.mas_equalTo(self.nobileBtn.mas_bottom);
     }];
}


#pragma mark - Event

- (void)onClickFunctionTypeAction:(FunctionType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFunctionType:)]) {
        [self.delegate onClickFunctionType:type];
    }
}

- (NSUInteger )getNowTimeDaySince:(NSInteger)second {
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:second/ 1000.0];
    NSDate *date = [NSDate new];
    NSTimeInterval time = [targetDate timeIntervalSinceDate:date];
    
    NSUInteger day = time/(3600*24);
    return day;
}
#pragma mark - Getter && Setter

- (void)setInfo:(UserInfo *)info {
    _info = info;
    if (info.nobleUsers.expire) {
//        _expriLabel.text = [NSString stringWithFormat:@"%@到期",[PLTimeUtil getDateWithYYMMDD:[NSString stringWithFormat:@"%ld",info.nobleUsers.expire]]];
        _expriLabel.text = [NSString stringWithFormat:@"剩余%ld天到期",[self getNowTimeDaySince:info.nobleUsers.expire]];
    }else {
        _expriLabel.text = @"";
    }
}

- (TTPersonalTopBottomButton *)familyBtn {
    if (!_familyBtn) {
        @weakify(self)
        _familyBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"我的家族" image:[UIImage imageNamed:@"person_famliy"] type:FunctionType_Family action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _familyBtn;
}

- (TTPersonalTopBottomButton *)incomeBtn {
    if (!_incomeBtn) {
        @weakify(self)
        _incomeBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"我的礼物" image:[UIImage imageNamed:@"person_income"] type:FunctionType_Income action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _incomeBtn;
}

- (TTPersonalTopBottomButton *)rechargeBtn {
    if (!_rechargeBtn) {
        @weakify(self)
        _rechargeBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"我的金币/充值" image:[UIImage imageNamed:@"person_recharge"] type:FunctionType_Recharge action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _rechargeBtn;
}

- (TTPersonalTopBottomButton *)dressupBtn {
    if (!_dressupBtn) {
        @weakify(self)
        _dressupBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"装扮商城" image:[UIImage imageNamed:@"person_dressup"] type:FunctionType_Dressup action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _dressupBtn;
}

- (TTPersonalTopBottomButton *)nobileBtn {
    if (!_nobileBtn) {
        @weakify(self)
        _nobileBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"贵族特权" image:[UIImage imageNamed:@"person_nobility"] type:FunctionType_Nobile action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _nobileBtn;
}

- (TTPersonalTopBottomButton *)settingBtn {
    if (!_settingBtn) {
        @weakify(self)
        _settingBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"person_setting"] type:FunctionType_Setting action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionTypeAction:type];
        }];
    }
    return _settingBtn;
}

- (UILabel *)expriLabel {
    if (!_expriLabel) {
        _expriLabel = [[UILabel alloc] init];
        _expriLabel.textColor = [XCTheme getTTMainColor];
        _expriLabel.font = [UIFont systemFontOfSize:11];
    }
    return _expriLabel;
}

@end
