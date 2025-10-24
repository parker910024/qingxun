//
//  TTPersonalTopBottomButton.m
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonalTopBottomButton.h"

//t
#import "TTPersonModuleTools.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTPersonalTopBottomButton()
@property (nonatomic, assign, readwrite) FunctionType type;//
@property (nonatomic, copy) void (^action)(FunctionType type);

@property (nonatomic, strong) UIView  *contianView;//
//图片文字
@property (nonatomic, strong) UIImageView  *iconImageView;//
@property (nonatomic, strong) UILabel  *titleLabel;//

//纯文字
@property (nonatomic, strong) UILabel  *textTitleLable;//
@property (nonatomic, strong) UILabel  *subTitleLabel;//
@end

@implementation TTPersonalTopBottomButton

//图片文字
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(FunctionType)type action:(void (^)(FunctionType type))action {
    if (self = [super init]) {
        [self initSubViews:NO];
        self.iconImageView.image = image;
        self.titleLabel.text = title;
        self.type = type;
        self.action = action;
    }
    return self;
}

//纯文字
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(FunctionType)type action:(void(^)(FunctionType type))action {
    if (self = [super init]) {
        [self initSubViews:YES];
        self.textTitleLable.text = title;
        self.type = type;
        self.action = action;
        self.subTitle = subTitle;
    }
    return self;
}

- (void)initSubViews:(BOOL)isTextOnly {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAction)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.contianView];

    if (isTextOnly) {
        [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        [self.contianView addSubview:self.textTitleLable];
        [self.contianView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contianView);
        }];
        [self.textTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.contianView);
            make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(8);
        }];
        
    }else {
        [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        [self.contianView addSubview:self.iconImageView];
        [self.contianView addSubview:self.titleLabel];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(self.contianView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.contianView);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
        }];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}



- (void)onClickAction {
    !self.action?:self.action(self.type);
}

#pragma mark - Getter && Setter

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = _subTitle;
}

- (UIView *)contianView {
    if (!_contianView) {
        _contianView = [[UIView alloc] init];
    }
    return _contianView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (UILabel *)textTitleLable {
    if (!_textTitleLable) {
        _textTitleLable = [[UILabel alloc] init];
        _textTitleLable.font = [UIFont systemFontOfSize:12];
        _textTitleLable.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _textTitleLable;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _subTitleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _subTitleLabel;
}



@end
