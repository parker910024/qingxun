//
//  XCLittleWorldPostDynamicSuccessView.m
//  XC_TTMessageMoudle
//
//  Created by Lee on 2019/12/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldPostDynamicSuccessView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "UIImageView+QiNiu.h"

@interface XCLittleWorldPostDynamicSuccessView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation XCLittleWorldPostDynamicSuccessView

#pragma mark - lifeCyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.iconImageView];
    self.backgroundColor = [XCTheme getTTMainColor];
    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
}

- (void)initConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.width.mas_equalTo(50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.iconImageView);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-25);
    }];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    NSString *title = dict[@"title"];
    if (!title && dict[@"nick"]) {//兼容Android字段不一致
        
        title = dict[@"nick"];
        if (title.length > 4) {
            title = [title substringToIndex:2];
            title = [title stringByAppendingString:@"..."];
        }
        
        title = [NSString stringWithFormat:@"%@ 发布了一条新动态，快来围观", title];
    }
    
    NSString *avatar = dict[@"avatar"] ?: dict[@"imageUrl"];
    
    self.titleLabel.text = title;
    self.textLabel.text = dict[@"content"];
    [self.iconImageView qn_setImageImageWithUrl:avatar placeholderImage:nil type:ImageTypeUserIcon];
}

#pragma mark -
#pragma mark getter && setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = UIColor.whiteColor;
    }
    return _textLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end

