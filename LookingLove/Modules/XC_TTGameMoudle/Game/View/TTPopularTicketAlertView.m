//
//  TTPopularTicketAlertView.m
//  LookingLove
//
//  Created by lvjunhang on 2020/12/3.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTPopularTicketAlertView.h"

#import "XCMacros.h"
#import "XCTheme.h"

#import "UIImageView+QiNiu.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>

@interface TTPopularTicketAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *desLabel;//恭喜你获得了3张人气票，快把票送给你心仪的人吧
@property (nonatomic, strong) UIButton *doneButton;//我知道了
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation TTPopularTicketAlertView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Actions
- (void)didClickDoneButton:(UIButton *)sender {
    !self.doneHandler ?: self.doneHandler();
}

- (void)didClickCloseButton:(UIButton *)sender {
    !self.closeHandler ?: self.closeHandler();
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.desLabel];
    [self.bgView addSubview:self.doneButton];
    [self addSubview:self.closeButton];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(272);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(30);
        make.left.right.mas_equalTo(self.bgView).inset(38);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(38);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(-5);
        make.right.mas_equalTo(self.bgView.mas_right).offset(5);
        make.width.height.mas_equalTo(25);
    }];
}

#pragma mark - Getter Setter
- (void)setModel:(PopularTicket *)model {
    _model = model;
    
    NSString *content = [NSString stringWithFormat:@"恭喜你获得了%@张人气票，快把票送给你心仪的人吧", model.giftNum];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 6;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                                 NSForegroundColorAttributeName: UIColorFromRGB(0x333333),
                                 NSParagraphStyleAttributeName: paragraphStyle
    };
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    self.desLabel.attributedText = attr;
    
    [self.iconImageView qn_setImageImageWithUrl:model.giftUrl placeholderImage:XCTheme.defaultTheme.placeholder_image_square type:ImageTypeUserLibaryDetail];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = UIColor.whiteColor;
        _iconImageView.layer.cornerRadius = 8;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = UIColorFromRGB(0x333333);
        _desLabel.font = [UIFont boldSystemFontOfSize:15];
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}

- (UIButton *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_doneButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _doneButton.backgroundColor = UIColorFromRGB(0x39EBDF);
        [_doneButton addTarget:self action:@selector(didClickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.layer.cornerRadius = 19;
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.borderWidth = 2;
        _doneButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    }
    return _doneButton;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"game_home_popular_ticket_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];
    }
    return _closeButton;
}

@end
