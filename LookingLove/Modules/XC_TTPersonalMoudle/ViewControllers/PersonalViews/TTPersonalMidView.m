//
//  TTPersonalMidView.m
//  TuTu
//
//  Created by Macx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonalMidView.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "XCTheme.h"

#import "UserInfo.h"
#import <Masonry/Masonry.h>

@interface TTPersonalMidView()

@property (nonatomic, strong) UIView  *contianView;//

@property (nonatomic, strong) TTPersonalTopBottomButton  *followBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *fansBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *LevelBtn;//
@property (nonatomic, strong) TTPersonalTopBottomButton  *charmBtn;//

@end


@implementation TTPersonalMidView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    [self addSubview:self.contianView];
    [self.contianView addSubview:self.followBtn];
    [self.contianView addSubview:self.fansBtn];
    [self.contianView addSubview:self.LevelBtn];
    [self.contianView addSubview:self.charmBtn];
    
    [self makeConstriants];
}

- (void)makeConstriants {
//    CGFloat height = 55;
    
    [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contianView).offset(22);
        make.centerY.mas_equalTo(self.contianView);
//        make.height.width.mas_equalTo(height);
    }];
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followBtn.mas_right).offset(50);
        make.centerY.mas_equalTo(self.contianView);
//        make.height.width.mas_equalTo(height);
    }];
    [self.charmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contianView).offset(-15);
        make.centerY.mas_equalTo(self.contianView);
//        make.height.width.mas_equalTo(height);
    }];
    [self.LevelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contianView.mas_centerX);
//        make.height.width.mas_equalTo(height);
        make.centerY.mas_equalTo(self.contianView);
    }];
}

#pragma mark - Event

- (void)onClickFunctionAction:(FunctionType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFunctionType:)]) {
        [self.delegate onClickFunctionType:type];
    }
}

#pragma mark - Getter && Setter

- (void)setInfo:(UserInfo *)info {
    _info = info;
    self.followBtn.subTitle = [NSString stringWithFormat:@"%ld",info.followNum];
    self.fansBtn.subTitle = [NSString stringWithFormat:@"%ld",info.fansNum];
    self.LevelBtn.subTitle = [NSString stringWithFormat:@"Lv.%@",info.userLevelVo.experLevelSeq];
    self.charmBtn.subTitle = [NSString stringWithFormat:@"Lv.%@",info.userLevelVo.charmLevelSeq];
}

- (UIView *)contianView {
    if (!_contianView) {
        _contianView = [[UIView alloc] init];
        _contianView.layer.masksToBounds = YES;
        _contianView.layer.cornerRadius = 8;
        _contianView.backgroundColor = [UIColor whiteColor];
    }
    return _contianView;
}

- (TTPersonalTopBottomButton *)followBtn {
    if (!_followBtn) {
        @weakify(self)
        _followBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"关注" subTitle:@"0" type:FunctionType_Follow action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionAction:type];
        }];
    }
    return _followBtn;
}

- (TTPersonalTopBottomButton *)fansBtn {
    if (!_fansBtn) {
        @weakify(self)
        _fansBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"粉丝" subTitle:@"0" type:FunctionType_Fans action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionAction:type];
        }];
    }
    return _fansBtn;
}
- (TTPersonalTopBottomButton *)LevelBtn {
    if (!_LevelBtn) {
        @weakify(self)
        _LevelBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"用户等级" subTitle:@"Lv.0" type:FunctionType_Level action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionAction:type];
        }];
    }
    return _LevelBtn;
}
- (TTPersonalTopBottomButton *)charmBtn {
    if (!_charmBtn) {
        @weakify(self)
        _charmBtn = [[TTPersonalTopBottomButton alloc] initWithTitle:@"魅力等级" subTitle:@"0" type:FunctionType_Charm action:^(FunctionType type) {
            @strongify(self)
            [self onClickFunctionAction:type];
        }];
    }
    return _charmBtn;
}

@end
