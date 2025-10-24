//
//  TTApprenticeFlowerView.m
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTApprenticeFlowerView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"
#import "MentoringGiftModel.h"
#import "UIImageView+QiNiu.h"

@interface TTApprenticeFlowerView ()
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** 花 */
@property (nonatomic, strong) UIImageView *flowerImageView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** 答谢按钮 */
@property (nonatomic, strong) UIButton *thanksButton;
/** 回赠按钮 */
@property (nonatomic, strong) UIButton *rewardButton;
@end

@implementation TTApprenticeFlowerView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickThanksButton:(UIButton *)btn {
    if (self.thanksButtonDidClickBlcok) {
        self.thanksButtonDidClickBlcok();
    }
}

- (void)didClickRewardButton:(UIButton *)btn {
    if (self.rewardButtonDidClickBlcok) {
        self.rewardButtonDidClickBlcok();
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.flowerImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.thanksButton];
    [self.contentView addSubview:self.rewardButton];
    
    [self.thanksButton addTarget:self action:@selector(didClickThanksButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rewardButton addTarget:self action:@selector(didClickRewardButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.flowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(58);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(84);
        make.centerY.mas_equalTo(self.flowerImageView);
    }];
    
    [self.thanksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(self.rewardButton.mas_left).offset(-11);
        make.height.mas_equalTo(38);
    }];
    
    [self.rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.thanksButton);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and setters

- (void)setAppenticeFlowerAttach:(XCMentoringShipAttachment *)appenticeFlowerAttach {
    _appenticeFlowerAttach = appenticeFlowerAttach;
    MentoringGiftModel * giftModel = [MentoringGiftModel yy_modelWithJSON:appenticeFlowerAttach.extendData];
    [self.flowerImageView qn_setImageImageWithUrl:giftModel.picUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    NSString * title = [appenticeFlowerAttach.content firstObject];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSRange range = [title rangeOfString:giftModel.giftName];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF3D56) range:NSMakeRange(range.location, title.length -range.location)];
    self.titleLabel.attributedText = attributedString;
    
    self.thanksButton.enabled = !appenticeFlowerAttach.apprenticeThank;
    if (appenticeFlowerAttach.apprenticeThank) {
        self.thanksButton.layer.borderColor = UIColorFromRGB(0xdbdbdb).CGColor;
    }else{
        self.thanksButton.layer.borderColor = [[XCTheme getTTMainColor] CGColor];
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)flowerImageView {
    if (!_flowerImageView) {
        _flowerImageView = [[UIImageView alloc] init];
    }
    return _flowerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)thanksButton {
    if (!_thanksButton) {
        _thanksButton = [[UIButton alloc] init];
        [_thanksButton setTitle:@"答谢" forState:UIControlStateNormal];
        [_thanksButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_thanksButton setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        _thanksButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _thanksButton.layer.cornerRadius = 19;
        _thanksButton.layer.masksToBounds = YES;
        _thanksButton.layer.borderWidth = 1;
    }
    return _thanksButton;
}

- (UIButton *)rewardButton {
    if (!_rewardButton) {
        _rewardButton = [[UIButton alloc] init];
        [_rewardButton setTitle:@"回赠" forState:UIControlStateNormal];
        [_rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rewardButton.backgroundColor = [XCTheme getTTMainColor];
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _rewardButton.layer.cornerRadius = 19;
        _rewardButton.layer.masksToBounds = YES;
    }
    return _rewardButton;
}

@end
