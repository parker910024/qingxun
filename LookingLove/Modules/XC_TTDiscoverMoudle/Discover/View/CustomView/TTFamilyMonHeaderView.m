//
//  TTFamilyMonHeaderView.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMonHeaderView.h"
#import "TTFamilyCutonLabel.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSString+Utils.h"
#import "FamilyCore.h"
#import "TTFamilyMemberViewController.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"

@interface TTFamilyMonHeaderView ()
/** 底部的背景*/
@property (nonatomic, strong) UIImageView * backImageView;
/** 总的*/
@property (nonatomic, strong) TTFamilyCutonLabel * totalMonLabel;
/** 收入*/
@property (nonatomic, strong) TTFamilyCutonLabel * incomeMonLabel;
/** 支出*/
@property (nonatomic, strong) TTFamilyCutonLabel * expenseMonLabel;
/** 流水*/
@property (nonatomic, strong) UILabel * waterLabel;
/** 分割线*/
@property (nonatomic, strong) UIView * sepView;
/** 贡献*/
@property (nonatomic, strong) UIButton * contriButton;
/** 问题*/
@property (nonatomic, strong) UIButton * questButton;

@property (nonatomic, strong) XCFamily * familyModel;
@end

@implementation TTFamilyMonHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - response
- (void)contriButtonAction:(UIButton *)sender{
    if (self.currentController) {
        TTFamilyMemberViewController * memListVC = [[TTFamilyMemberViewController alloc] init];
        if (self.familyModel.position == FamilyMemberPositionOwen) {
            if (self.familyModel) {
                memListVC.listType = FamilyMemberListMoneyTransfer;
                memListVC.familyInfor = self.familyModel;
                [self.currentController.navigationController pushViewController:memListVC animated:YES];
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(contriMonToOwner:)]) {
                [self.delegate contriMonToOwner:sender];
            }
        }
        
    }
}

- (void)questButtonAction:(UIButton *)sender{
    TTWKWebViewViewController *webviewVC = [[TTWKWebViewViewController alloc] init];
    webviewVC.urlString = HtmlUrlKey(kFamilyMoneyRule);
    [self.currentController.navigationController pushViewController:webviewVC animated:YES];
}

#pragma mark - public method
- (void)configFamilyMoneyHeaderWithFamily:(XCFamily *)model{
    if (model) {
        self.familyModel = model;
        NSString * title = @"";
        NSString * totalStr= @"0000";
        NSString * incomeStr = @"总收入";
        NSString * costStr = @"总支出";
        if (self.monType == FamilyMoneyOwnerMe) {
            incomeStr = @"总收入";
            if (model.position == FamilyMemberPositionOwen) {
                title = [NSString stringWithFormat:@"转让%@",model.moneyName];
            }else{
                title = [NSString stringWithFormat:@"贡献%@",model.moneyName];
            }
            totalStr =[NSString stringWithFormat:@"我的%@余额", model.moneyName];
        }else if (self.monType == FamilyMoneyOwnerGroup){
            title = @"";
            incomeStr = @"总流水";
            totalStr =[NSString stringWithFormat:@"本周%@流水", [GetCore(FamilyCore) getFamilyModel].moneyName];
        }else if (self.monType == FamilyMoneyOwnerManager || self.monType == FamilyMoneyOwnerMoney){
            title = [NSString stringWithFormat:@"%@转让",model.moneyName];
            totalStr =[NSString stringWithFormat:@"我的%@余额", model.moneyName];
        }
        [self.contriButton setTitle:title forState:UIControlStateNormal];
        self.totalMonLabel.titleLabel.text = totalStr;
        self.totalMonLabel.subTitleLabel.text = [NSString changeAsset:[NSString stringWithFormat:@"%.2f", model.totalAmount]] ;
        self.incomeMonLabel.titleLabel.text = incomeStr;
        if (self.monType == FamilyMoneyOwnerGroup) {
            if (model.weekAmount > 0) {
                self.waterLabel.text = [NSString stringWithFormat:@"总流水：%@%@",[NSString changeAsset:[NSString stringWithFormat:@"%.2f", model.weekAmount]]  , [GetCore(FamilyCore) getFamilyModel].moneyName];
            }else{
                self.waterLabel.text = [NSString stringWithFormat:@"总流水：0%@", [GetCore(FamilyCore) getFamilyModel].moneyName];
            }
        }else{
            if (model.incomeAndCost.income > 0) {
                self.incomeMonLabel.subTitleLabel.text = [NSString stringWithFormat:@"%@%@",[NSString changeAsset:[NSString stringWithFormat:@"%.2f", model.incomeAndCost.income]]  , model.moneyName];
            }else{
                self.incomeMonLabel.subTitleLabel.text = @"0";
            }
            
            self.expenseMonLabel.titleLabel.text = costStr;
            if (model.incomeAndCost.cost > 0) {
                self.expenseMonLabel.subTitleLabel.text = [NSString stringWithFormat:@"%@%@",[NSString changeAsset:[NSString stringWithFormat:@"%.2f", model.incomeAndCost.cost]]  , model.moneyName];
            }else{
                self.expenseMonLabel.subTitleLabel.text = @"0";
            }
        }
    }
}

#pragma mark - private method
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backImageView];
    [self addSubview:self.totalMonLabel];
    [self addSubview:self.questButton];
    [self addSubview:self.contriButton];
    [self addSubview:self.incomeMonLabel];
    [self addSubview:self.expenseMonLabel];
    [self addSubview:self.waterLabel];
    [self addSubview:self.sepView];
}

- (void)initContrations{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(202);
    }];
    
    [self.totalMonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(self).offset(27);
    }];
    
    [self.questButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.mas_equalTo(self).offset(26);
        make.right.mas_equalTo(self).offset(-26);
    }];
    
    [self.contriButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.totalMonLabel.mas_bottom).offset(13);
    }];
    
    [self.incomeMonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.contriButton.mas_bottom).offset(21);
        make.height.mas_equalTo(40);
    }];
    
    [self.expenseMonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.contriButton.mas_bottom).offset(21);
        make.height.mas_equalTo(40);
    }];
    
    [self.waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.totalMonLabel.mas_bottom).offset(23);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self.incomeMonLabel);
    }];
    
}

#pragma mark - setters and getters
- (void)setMonType:(FamilyMoneyOwnerType)monType{
    _monType = monType;
    if (_monType == FamilyMoneyOwnerGroup) {
        self.questButton.hidden = YES;
        self.expenseMonLabel.hidden = YES;
        self.incomeMonLabel.hidden = YES;
        self.contriButton.hidden = YES;
        self.waterLabel.hidden = NO;
    }else{
        self.questButton.hidden = NO;
        self.expenseMonLabel.hidden = NO;
        self.incomeMonLabel.hidden = NO;
        self.contriButton.hidden = NO;
        self.waterLabel.hidden = YES;
    }
}

- (TTFamilyCutonLabel *)totalMonLabel{
    if (!_totalMonLabel) {
        _totalMonLabel = [[TTFamilyCutonLabel alloc] init];
        _totalMonLabel.subTitleLabel.font = [UIFont systemFontOfSize:30];
    }
    return _totalMonLabel;
}

- (TTFamilyCutonLabel *)incomeMonLabel{
    if (!_incomeMonLabel) {
        _incomeMonLabel = [[TTFamilyCutonLabel alloc] init];
        _incomeMonLabel.subTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _incomeMonLabel;
}


- (TTFamilyCutonLabel *)expenseMonLabel{
    if (!_expenseMonLabel) {
        _expenseMonLabel = [[TTFamilyCutonLabel alloc] init];
        _expenseMonLabel.subTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _expenseMonLabel;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"family_mon_headback"];
    }
    return _backImageView;
}

- (UIButton *)contriButton{
    if (!_contriButton) {
        _contriButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contriButton setTitleColor:UIColorFromRGB(0x6069FC) forState:UIControlStateNormal];
        [_contriButton setTitleColor:UIColorFromRGB(0x6069FC) forState:UIControlStateSelected];
        _contriButton.backgroundColor = UIColorFromRGB(0xffffff);
        _contriButton.layer.cornerRadius = 25/2;
        _contriButton.layer.masksToBounds = YES;
        _contriButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_contriButton addTarget:self action:@selector(contriButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contriButton;
}

- (UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = UIColorRGBAlpha(0xffffff, 0.3);
    }
    return _sepView;
}

- (UIButton *)questButton{
    if (!_questButton) {
        _questButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_questButton setImage:[UIImage imageNamed:@"family_mon_quest"] forState:UIControlStateNormal];
        [_questButton setImage:[UIImage imageNamed:@"family_mon_quest"] forState:UIControlStateSelected];
        [_questButton addTarget:self action:@selector(questButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questButton;
}

- (UILabel *)waterLabel{
    if (!_waterLabel) {
        _waterLabel = [[UILabel alloc] init];
        _waterLabel.textColor  = [UIColor whiteColor];
        _waterLabel.textAlignment = NSTextAlignmentCenter;
        _waterLabel.font = [UIFont systemFontOfSize:14];
    }
    return _waterLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
