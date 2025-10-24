//
//  XCUpgradeMessageContentView.m
//  XChat
//
//  Created by KevinWang on 2018/6/21.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCUpgradeMessageContentView.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "XCUserUpgradeAttachment.h"
#import "UIView+NTES.h"

NSString *const XCUserUpgadeMessageViewClick = @"XCUserUpgadeMessageViewClick";

@interface XCUpgradeMessageContentView ()
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation XCUpgradeMessageContentView

#pragma mark - overload
- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    UIEdgeInsets contentInsets = self.model.contentViewInsets;
//    CGFloat tableViewWidth = self.superview.width;
//    CGSize contentSize = [self.model contentSize:tableViewWidth];
    [self addConstraint];
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCUserUpgradeAttachment *customObject = (XCUserUpgradeAttachment*)object.attachment;
    if (customObject.first == Custom_Noti_Header_User_UpGrade) {
        if (customObject.second == Custom_Noti_Sub_User_UpGrade_ExperLevelSeq) {
            self.iconImageView.image = [UIImage imageNamed:@"upgrade_exper"];
            self.msgLabel.text = [NSString stringWithFormat:@"恭喜您的等级已到达%@",customObject.levelName];
        }else if (customObject.second == Custom_Noti_Sub_User_UpGrade_CharmLevelSeq){
            self.iconImageView.image = [UIImage imageNamed:@"upgrade_charm"];
            self.msgLabel.text = [NSString stringWithFormat:@"恭喜您的魅力等级已到达%@",customObject.levelName];
        }
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCUserUpgadeMessageViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}

#pragma mark - private method

- (void)setupSubViews{
    [self addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.msgLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.arrowImg];
}
- (void)addConstraint{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.width.height.equalTo(@50);
    }];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self).offset(-15);
        make.bottom.lessThanOrEqualTo(self.iconImageView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.tipLabel.mas_top);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(39);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.tipLabel);
        make.width.equalTo(@6);
        make.height.equalTo(@11);
    }];
}

#pragma mark - Getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.numberOfLines = 0;
        _msgLabel.font = [UIFont systemFontOfSize:14];
        _msgLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _msgLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0x999999);
        _lineView.alpha = 0.7;
    }
    return _lineView;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = UIColorFromRGB(0x999999);
        _tipLabel.text = @"立即查看";
    }
    return _tipLabel;
}
- (UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"home_moreArrow"];
    }
    return _arrowImg;
}

@end
