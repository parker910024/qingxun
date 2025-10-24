//
//  TTAboutMeSegementView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTAboutMeSegementView.h"
#import "TTAboutMeSegementChildView.h"

//category
#import "NSArray+Safe.h"
//tool
#import <Masonry/Masonry.h>
//theme
#import "XCTheme.h"

@interface TTAboutMeSegementView ()
<
    TTAboutMeSegementChildViewDelegate
>

@property (strong, nonatomic) NSArray *titles;

/**
 @我的
 */
@property (strong, nonatomic) TTAboutMeSegementChildView *childViewOne;

/**
 我发出的
 */
@property (strong, nonatomic) TTAboutMeSegementChildView *childViewTwo;

/**
 白色
 */
@property (strong, nonatomic) UIView *whilePlaceHolder;

@end

@implementation TTAboutMeSegementView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.currentType = TTAboutMeSegementViewClickType_AtMe;
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.layer.cornerRadius = 15.f;
    [self addSubview:self.whilePlaceHolder];
    [self addSubview:self.childViewOne];
    [self addSubview:self.childViewTwo];
}

- (void)initConstrations {
    [self.whilePlaceHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(25);
        make.center.mas_equalTo(self.childViewOne);
    }];
    [self.childViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.childViewTwo);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.childViewTwo.mas_leading);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    [self.childViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing);
        make.centerY.mas_equalTo(self.childViewOne.mas_centerY);
    }];
}

#pragma mark - TTAboutMeSegementChildViewDelegate

- (void)onAboutMeSegementChildView:(TTAboutMeSegementChildView *)childView wasClickWthType:(TTAboutMeSegementViewClickType)type {
    if ([self.delegate respondsToSelector:@selector(onTTAboutMeSegementView:childSegementWasClick:)]) {
        [self onMovePlaceHolderView:type];
        [self.delegate onTTAboutMeSegementView:self childSegementWasClick:type];
    }
}

#pragma mark - private method

- (void)onMovePlaceHolderView:(TTAboutMeSegementViewClickType)type {
    [UIView animateWithDuration:0.2 animations:^{
        if (type == TTAboutMeSegementViewClickType_AtMe) {
            [self.childViewOne setTitleColor:[XCTheme getTTMainColor]];
            [self.childViewTwo setTitleColor:UIColorFromRGB(0x999999)];
            if (self.currentType != type) {
                self.whilePlaceHolder.center = self.childViewOne.center;
            }
        }else if (type == TTAboutMeSegementViewClickType_SendFromMe) {
            [self.childViewOne setTitleColor:UIColorFromRGB(0x999999)];
            [self.childViewTwo setTitleColor:[XCTheme getTTMainColor]];
            if (self.currentType != type) {
                self.whilePlaceHolder.center = self.childViewTwo.center;
            }
        }
        self.currentType = type;
    }];
}

#pragma mark - setter & getter


- (void)setCurrentType:(TTAboutMeSegementViewClickType)currentType {
    _currentType = currentType;
    if (currentType == TTAboutMeSegementViewClickType_AtMe) {
        [self.childViewOne setTitleColor:[XCTheme getTTMainColor]];
        [self.childViewTwo setTitleColor:UIColorFromRGB(0x999999)];
    }else if (currentType == TTAboutMeSegementViewClickType_SendFromMe) {
        [self.childViewOne setTitleColor:UIColorFromRGB(0x999999)];
        [self.childViewTwo setTitleColor:[XCTheme getTTMainColor]];
    }
}

- (TTAboutMeSegementChildView *)childViewOne {
    if (!_childViewOne) {
        _childViewOne = [[TTAboutMeSegementChildView alloc]init];
        _childViewOne.type = TTAboutMeSegementViewClickType_AtMe;
        _childViewOne.delegate = self;
        [_childViewOne setTitle:@"@我的"];
    }
    return _childViewOne;
}

- (TTAboutMeSegementChildView *)childViewTwo {
    if (!_childViewTwo) {
        _childViewTwo = [[TTAboutMeSegementChildView alloc]init];
        _childViewTwo.type = TTAboutMeSegementViewClickType_SendFromMe;
        _childViewTwo.delegate = self;
        [_childViewTwo setTitle:@"我发出的"];
//        _childViewTwo.
    }
    return _childViewTwo;
}

- (UIView *)whilePlaceHolder {
    if (!_whilePlaceHolder) {
        _whilePlaceHolder = [[UIView alloc]init];
        _whilePlaceHolder.backgroundColor = UIColorFromRGB(0xffffff);
        _whilePlaceHolder.layer.cornerRadius = 12.5f;
        _whilePlaceHolder.layer.masksToBounds = YES;
    }
    return _whilePlaceHolder;
}

@end
