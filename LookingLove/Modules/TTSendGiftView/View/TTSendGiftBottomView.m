//
//  TTSendGiftBottomView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftBottomView.h"

#import "BalanceInfo.h"
#import "CarrotWallet.h"
#import "PurseCore.h"
#import "GiftInfo.h"
#import "RoomMagicInfo.h"

#import "TTSendGiftViewConfig.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "UIImage+Utils.h"
#import "XCMacros.h"

@interface TTSendGiftBottomView ()
/** 余额: */
@property (nonatomic, strong) UILabel *balanceLabel;
/** 当前金币余额 */
@property (nonatomic, strong) UILabel *coinLabel;
/** 充值 */
@property (nonatomic, strong) UIButton *rechargeButton;
/** 选择数量容器view */
@property (nonatomic, strong) UIView *sendOperationView;
/** 打开 选择 数量 礼物 */
@property (nonatomic, strong) UIButton *selectedCountBtn;
/** 箭头 */
@property (nonatomic, strong) UIImageView *arrowImage;
/** 礼物数量 */
@property (nonatomic, strong) UILabel *selectedCountLabel;
/** 赠送按钮 */
@property (nonatomic, strong) UIButton *sendGiftButton;

/** 当前选中的礼物模型 */
@property (nonatomic, strong) id giftItem;
@end

@implementation TTSendGiftBottomView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setCurrentType:(SelectGiftType)currentType {
    _currentType = currentType;
    
    if (currentType == SelectGiftType_magic) {
        [self.sendGiftButton setTitle:@"施法" forState:UIControlStateNormal];
        self.selectedCountBtn.enabled = NO;
        self.selectedCountLabel.text = @"1";
    } else if (currentType == SelectGiftType_gift) {
        [self.sendGiftButton setTitle:[TTSendGiftViewConfig globalConfig].room_gift_sendGift_tip forState:UIControlStateNormal];
        self.selectedCountBtn.enabled = YES;
    } else if (currentType == SelectGiftType_giftPackage) {
        [self.sendGiftButton setTitle:[TTSendGiftViewConfig globalConfig].room_gift_sendGift_tip forState:UIControlStateNormal];
        self.selectedCountBtn.enabled = YES;
    } else if (currentType == SelectGiftType_nobleGift) {
        [self.sendGiftButton setTitle:[TTSendGiftViewConfig globalConfig].room_gift_sendGift_tip forState:UIControlStateNormal];
        self.selectedCountBtn.enabled = YES;
    }
}

- (void)updateBottomViewInfo:(id)giftItem {
    _giftItem = giftItem;
    
    if ([giftItem isKindOfClass:[GiftInfo class]]) {
        GiftInfo *gift = (GiftInfo *)giftItem;

        // 盲盒礼物不显示小箭头
        self.arrowImage.hidden = gift.consumeType == GiftConsumeTypeBox;
        
        if (gift.consumeType == GiftConsumeTypeCoin) {
            self.coinLabel.text = [NSString stringWithFormat:@"%@", self.balanceInfo.goldNum];
            [self.rechargeButton setTitle:@"充值 >" forState:UIControlStateNormal];
        } else if (gift.consumeType == GiftConsumeTypeCarrot) {
            self.coinLabel.text = [NSString stringWithFormat:@"%@萝卜", self.carrotWallet.amount];
            [self.rechargeButton setTitle:@"做任务获取 >" forState:UIControlStateNormal];
        }  else if (gift.consumeType == GiftConsumeTypeBox) {
            // 盲盒礼物，只能选择一个
            self.selectedCountLabel.text = @"1";
            self.coinLabel.text = [NSString stringWithFormat:@"%d金币", self.balanceInfo.goldNum.intValue];
            [self.rechargeButton setTitle:@"充值 >" forState:UIControlStateNormal];
        }
        
    } else if ([giftItem isKindOfClass:[RoomMagicInfo class]]) {
//        RoomMagicInfo *gift = (RoomMagicInfo *)giftItem;
        self.coinLabel.text = [NSString stringWithFormat:@"%@", self.balanceInfo.goldNum];
        [self.rechargeButton setTitle:@"充值 >" forState:UIControlStateNormal];
    }
}

- (void)setBalanceInfo:(BalanceInfo *)balanceInfo {
    _balanceInfo = balanceInfo;
    [self updateBottomViewInfo:self.giftItem];
}

- (void)setCarrotWallet:(CarrotWallet *)carrotWallet {
    _carrotWallet = carrotWallet;
    [self updateBottomViewInfo:self.giftItem];
}

/** 更新礼物数量 */
- (void)updateGiftCountWithItem:(TTSendGiftCountItem *)countItem {
    if (countItem.isCustomCount) {
        [self selectCountBtnClick:self.selectedCountBtn];
    } else {
        self.selectedCountLabel.text = countItem.giftCount;
        [self selectCountBtnClick:self.selectedCountBtn];
    }
}

/** 更新箭头的图片 */
- (void)updateArrowImage:(BOOL)isUp {
    if (isUp) {
        self.arrowImage.image = [UIImage imageNamed:@"room_gift_arrow_up"];
    } else {
        self.arrowImage.image = [UIImage imageNamed:[TTSendGiftViewConfig globalConfig].room_gift_arrow_image];
    }
}

#pragma mark - xxx

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)rechargeButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftBottomView:didClickRechargeButton:type:)]) {
        GiftConsumeType type = GiftConsumeTypeCoin;
        if ([self.giftItem isKindOfClass:[GiftInfo class]]) {
            GiftInfo *gift = (GiftInfo *)self.giftItem;
            type = gift.consumeType;
        } else if ([self.giftItem isKindOfClass:[RoomMagicInfo class]]) {
            type = GiftConsumeTypeCoin;
        }
        [self.delegate sendGiftBottomView:self didClickRechargeButton:button type:type];
    }
}

- (void)selectCountBtnClick:(UIButton *)button {
    
    // 盲盒礼物不能可以选择数量
    if ([self.giftItem isKindOfClass:[GiftInfo class]]) {
        GiftInfo *gift = (GiftInfo *)self.giftItem;
        
        if (gift.consumeType == GiftConsumeTypeBox) {
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftBottomView:didClickSelectCountBtn:)]) {
        [self.delegate sendGiftBottomView:self didClickSelectCountBtn:button];
    }
}

- (void)tutuSendButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftBottomView:didClickSendButton:)]) {
        [self.delegate sendGiftBottomView:self didClickSendButton:button];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.balanceLabel];
    [self addSubview:self.coinLabel];
    [self addSubview:self.rechargeButton];
    
    [self addSubview:self.sendOperationView];
    [self.sendOperationView addSubview:self.selectedCountLabel];
    [self.sendOperationView addSubview:self.arrowImage];
    [self.sendOperationView addSubview:self.selectedCountBtn];
    [self.sendOperationView addSubview:self.sendGiftButton];
    
    self.balanceInfo = GetCore(PurseCore).balanceInfo;
    self.carrotWallet = GetCore(PurseCore).carrotWallet;
}

- (void)initConstrations {
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self.sendOperationView);
    }];
    
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceLabel.mas_right);
        make.centerY.mas_equalTo(self.balanceLabel);
    }];
    
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coinLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(self.sendOperationView);
        make.right.mas_lessThanOrEqualTo(self.sendOperationView.mas_left).offset(0);
    }];
    
    [self.sendOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(4);
    }];
    
    [self.selectedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(self.sendOperationView);
        make.right.mas_equalTo(self.arrowImage.mas_left);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.sendGiftButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.sendOperationView);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
    }];
    
    [self.selectedCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.sendOperationView);
        make.right.mas_equalTo(self.sendGiftButton.mas_left);
    }];
    
    [self.sendGiftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.sendOperationView);
        make.width.mas_equalTo(68);
    }];
}

#pragma mark - getters and setters
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        _balanceLabel.font = [UIFont systemFontOfSize:13];
        _balanceLabel.text = @"余额：";
    }
    return _balanceLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.textColor = [TTSendGiftViewConfig globalConfig].coinLabelColor;
        _coinLabel.font = [UIFont systemFontOfSize:13];
    }
    return _coinLabel;
}

- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeButton setTitle:@"充值 >" forState:UIControlStateNormal];
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            [_rechargeButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        }else {
            [_rechargeButton setTitleColor:[XCTheme getMainDefaultColor] forState:UIControlStateNormal];
        }
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _rechargeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;
}

- (UIView *)sendOperationView {
    if (!_sendOperationView) {
        _sendOperationView = [[UIView alloc] init];
        _sendOperationView.layer.masksToBounds = YES;
        _sendOperationView.layer.cornerRadius = 15;
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            _sendOperationView.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        }else {
            _sendOperationView.layer.borderColor = [XCTheme getMainDefaultColor].CGColor;
        }
        _sendOperationView.layer.borderWidth = 0.5;
    }
    return _sendOperationView;
}

- (UIButton *)selectedCountBtn {
    if (!_selectedCountBtn) {
        _selectedCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedCountBtn addTarget:self action:@selector(selectCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedCountBtn;
}

- (UILabel *)selectedCountLabel {
    if (!_selectedCountLabel) {
        _selectedCountLabel = [[UILabel alloc] init];
        _selectedCountLabel.textAlignment = NSTextAlignmentCenter;
        _selectedCountLabel.textColor = [TTSendGiftViewConfig globalConfig].selectedCountLabelColor;
        _selectedCountLabel.text = @"1";
        _selectedCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _selectedCountLabel;
}

- (UIImageView *)arrowImage {
    if(!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[TTSendGiftViewConfig globalConfig].room_gift_arrow_image]];
    }
    return _arrowImage;
}

- (UIButton *)sendGiftButton {
    if (!_sendGiftButton) {
        _sendGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendGiftButton setTitle:[TTSendGiftViewConfig globalConfig].room_gift_sendGift_tip forState:UIControlStateNormal];
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            [_sendGiftButton setBackgroundImage:[UIImage imageWithColor:[XCTheme getTTMainColor]] forState:UIControlStateNormal];
        }else {
            [_sendGiftButton setBackgroundImage:[UIImage imageWithColor:[XCTheme getMainDefaultColor]] forState:UIControlStateNormal];
        }
        _sendGiftButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _sendGiftButton.layer.masksToBounds = YES;
        _sendGiftButton.layer.cornerRadius = 15;
        [_sendGiftButton addTarget:self action:@selector(tutuSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendGiftButton;
}

@end
