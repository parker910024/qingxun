//
//  LTDynamicUnreadHeaderView.m
//  LTChat
//
//  Created by apple on 2019/9/26.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTDynamicUnreadHeaderView.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>


//#import "AppDelegate.h"
#import "XCCurrentVCStackManager.h"

#import "LTDynamicCommentListVC.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"

@interface LTDynamicUnreadHeaderView ()

//消息父控件
@property (nonatomic, strong) UIView *bgView;
//头像
@property (nonatomic, strong) UIImageView *headImg;
//未读消息
@property (nonatomic, strong) UILabel *unReadLab;

@end

@implementation LTDynamicUnreadHeaderView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)updateUnreadData {
//    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (delegate.unreadModel.allCount > 0) {
//        self.unReadLab.text = [NSString stringWithFormat:[@"%ld条新消息" localString],(delegate.unreadModel.allCount)];
//        [self.headImg sd_setImageWithURL:[NSURL URLWithString:delegate.unreadModel.avatar] placeholderImage:[UIImage imageNamed:default_bg]];
//    }

}

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol] 

#pragma mark - [core相关的Protocol]

#pragma mark - event response

- (void)onTapClick:(UITapGestureRecognizer *)tap {
    
    LTDynamicCommentListVC * vc = [[LTDynamicCommentListVC alloc] init];
    [[[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headImg];
    [self.bgView addSubview:self.unReadLab];
}

- (void)initConstrations {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.width.equalTo(@200);
        make.height.equalTo(@44);
    }];

    [self.unReadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.centerX.equalTo(@(self.bgView.width/2 + 18));
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.height.width.equalTo(@25);
        make.right.equalTo(self.unReadLab.mas_left).mas_offset(-10);
    }];
}

#pragma mark - getters and setters

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _bgView.layer.cornerRadius = 5;
//        _bgView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
//        _bgView.layer.shadowOffset = CGSizeMake(2, 15);
//        _bgView.layer.shadowOpacity = 0.5;
//        _bgView.layer.shadowRadius = 10;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}

- (UILabel *)unReadLab{
    if (!_unReadLab) {
        _unReadLab = [[UILabel alloc] init];
        _unReadLab.textAlignment = NSTextAlignmentLeft;
        _unReadLab.textColor = UIColorRGBAlpha(0x39E2C6, 1);
        _unReadLab.text = @"1条新消息";
        _unReadLab.font = [UIFont systemFontOfSize:12];
    }
    return _unReadLab;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.layer.cornerRadius = 12.5;
        _headImg.layer.masksToBounds = YES;
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImg;
}

@end
