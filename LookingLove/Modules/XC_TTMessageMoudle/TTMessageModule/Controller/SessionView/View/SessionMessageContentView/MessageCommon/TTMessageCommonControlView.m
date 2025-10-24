//
//  MessageCommonControlView.m
//  XChat
//
//  Created by 卫明何 on 2018/5/28.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTMessageCommonControlView.h"
#import <YYLabel.h>
#import "UIImage+Utils.h"
#import "UIColor+UIColor_Hex.h"
#import "ImMessageCore.h"
#import "FamilyCore.h"
#import "TTMessageAttributedString.h"

#import <Masonry/Masonry.h>

@interface TTMessageCommonControlView ()

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) YYLabel *resultLabel;

@end

@implementation TTMessageCommonControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.resultLabel];
    
    @weakify(self);
    if (![GetCore(ImMessageCore).radiousImageCache objectForKey:@"leftBtnBg"]) {
        UIImage *leftBtnImage = [[UIImage alloc]init];
        [leftBtnImage imageWithSize:CGSizeMake(59, 25) radius:12.5 backColor:[UIColor colorWithHexString:@"#999999"] completion:^(UIImage *image) {
            UIImage *newImage = image;
            @strongify(self);
            [GetCore(ImMessageCore).radiousImageCache setObject:newImage forKey:@"leftBtnBg"];
            [self.leftButton setBackgroundImage:newImage forState:UIControlStateNormal];
            [self.leftButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
    }else {
        [self.leftButton setBackgroundImage:[GetCore(ImMessageCore).radiousImageCache objectForKey:@"leftBtnBg"] forState:UIControlStateNormal];
        [self.leftButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (![GetCore(ImMessageCore).radiousImageCache objectForKey:@"rightBtnBg"]) {
        UIImage *rightBtnImage = [[UIImage alloc]init];
        [rightBtnImage imageWithSize:CGSizeMake(59, 25) radius:12.5 backColor:[UIColor colorWithHexString:@"#67CD44"] completion:^(UIImage *image) {
            UIImage *newImage = image;
            @strongify(self);
            [GetCore(ImMessageCore).radiousImageCache setObject:newImage forKey:@"rightBtnBg"];
            [self.rightButton setBackgroundImage:newImage forState:UIControlStateNormal];
            [self.rightButton setTitle:@"同意" forState:UIControlStateNormal];
            [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
    }else {
        [self.rightButton setBackgroundImage:[GetCore(ImMessageCore).radiousImageCache objectForKey:@"rightBtnBg"] forState:UIControlStateNormal];
        [self.rightButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
}

- (void)initConstraints  {
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.width.mas_equalTo(59);
        make.height.mas_equalTo(25);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rightButton.mas_centerY);
        make.trailing.mas_equalTo(self.rightButton.mas_leading).offset(-10);
        make.width.mas_equalTo(59);
        make.height.mas_equalTo(25);
    }];
}

- (void)setBussiness:(MessageBussiness *)bussiness {
    _bussiness = bussiness;
    [self updateBussinessStateWith:bussiness];
}

- (void)updateBussinessStateWith:(MessageBussiness *)bussiness {
    if (bussiness.status == 0) {
        bussiness.status = 1;
    }
    switch (bussiness.status) {
        case Message_Bussiness_Status_Agree:
        {
            [self hideButton];
            self.resultLabel.attributedText = [TTMessageAttributedString creatResultByMessageStatus:bussiness.status nick:bussiness.approverNick];
        }
            break;
        case Message_Bussiness_Status_Refused:
        {
            [self hideButton];
            self.resultLabel.attributedText = [TTMessageAttributedString creatResultByMessageStatus:bussiness.status nick:bussiness.approverNick];
        }
            break;
        case Message_Bussiness_Status_OutDate:
        {
            [self hideButton];
            self.resultLabel.attributedText = [TTMessageAttributedString creatResultByMessageStatus:bussiness.status nick:bussiness.approverNick];
        }
            break;
        case Message_Bussiness_Status_Untreated:
        {
            [self showButton];
            
        }
            break;
        default:
            break;
    }
    self.resultLabel.hidden = !self.leftButton.hidden;
}

- (void)hideButton {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
}

- (void)showButton {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
}

- (void)leftButtonClick:(UIButton *)sender {
    NSMutableDictionary * info = [[self.bussiness.params model2dictionary] mutableCopy];
    [info addEntriesFromDictionary:@{@"type":@"0"}];
    [GetCore(FamilyCore)updateApprovalStatus:self.bussiness message:self.message targetStatus:Message_Bussiness_Status_Refused method:self.bussiness.url params:info];
}

- (void)rightButtonClick:(UIButton *)sender {
    NSMutableDictionary * info = [[self.bussiness.params model2dictionary] mutableCopy];
    [info addEntriesFromDictionary:@{@"type":@"1"}];
    [GetCore(FamilyCore)updateApprovalStatus:self.bussiness message:self.message targetStatus:Message_Bussiness_Status_Agree method:self.bussiness.url params:info];
}


#pragma mark - Getter

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _rightButton;
}

- (YYLabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[YYLabel alloc]init];
    }
    return _resultLabel;
}


@end
