//
//  TTSendGiftItemCell.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftItemCell.h"

#import "TTSendGiftViewConfig.h"

//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import <YYText/YYText.h>
#import "UIImageView+QiNiu.h"
#import "NSString+Utils.h"

//m
#import "GiftInfo.h"
#import "RoomMagicInfo.h"

@interface TTSendGiftItemCell()
@property (nonatomic, strong) UIView *itemBgView; //选中背景色
@property (nonatomic, strong) UILabel *giftNumLabel; //数量（背包用）
@property (nonatomic, strong) UIImageView *giftImageView; //礼物icon
@property (nonatomic, strong) UILabel *gitftNameLabel; //礼物名称
@property (nonatomic, strong) UILabel *giftPriceLabel; //礼物价格
@property (nonatomic, strong) UIImageView *carrotGiftIconImageView; // 萝卜礼物icon
@property (nonatomic, strong) YYLabel *tagLabel; //新特限标签

@property (nonatomic, assign) SelectGiftType selectGiftType;
@end

@implementation TTSendGiftItemCell

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - puble method
- (void)configCellBySelectedType:(SelectGiftType)selectedType data:(id)data {
    self.selectGiftType = selectedType;
    
    self.tagLabel.hidden = (selectedType == SelectGiftType_magic ? YES : NO);
    self.giftNumLabel.hidden = (selectedType == SelectGiftType_giftPackage ? NO : YES);
    
    if (selectedType == SelectGiftType_gift) {
        
        GiftInfo *info = (GiftInfo *)data;
        self.itemBgView.hidden = !info.isSelected;
        [self.giftImageView qn_setImageImageWithUrl:info.giftUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomGift];
        self.gitftNameLabel.text = info.giftName;
        
        NSString *coinStr = @"金币";
        if (info.consumeType == GiftConsumeTypeCoin) {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        } else if (info.consumeType == GiftConsumeTypeCarrot) {
            coinStr = @"";
            self.carrotGiftIconImageView.hidden = NO;
            NSString *strr = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
            CGFloat width = [NSString sizeWithText:strr font:self.giftPriceLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            CGFloat margin = (10 + 2 + width) * 0.5 - width * 0.5;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(margin);
            }];
            self.carrotGiftIconImageView.image = info.isSelected ? [UIImage imageNamed:@"send_gift_ radish_icon_selected"] : [UIImage imageNamed:@"send_gift_ radish_icon"];
        } else {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        }
        self.giftPriceLabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
        self.tagLabel.attributedText = [self creatSendGiftViewTagWithGiftInfo:info];
        
        self.gitftNameLabel.textColor = info.isSelected ? XCTheme.getTTMainColor : UIColorRGBAlpha(0xffffff, 1);
        self.giftPriceLabel.textColor = info.isSelected ? [XCTheme getTTMainColorWithAlpha:0.65] : UIColorRGBAlpha(0xffffff, 0.5);
        self.itemBgView.backgroundColor = info.isSelected ? UIColorRGBAlpha(0x0B0B0D, 0.1) : [UIColor clearColor];
        
    } else if (selectedType == SelectGiftType_magic) {
        self.carrotGiftIconImageView.hidden = YES;
        [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.itemBgView).offset(0);
        }];
        RoomMagicInfo *info = (RoomMagicInfo *)data;
        self.itemBgView.hidden = !info.isSelected;
        [self.giftImageView qn_setImageImageWithUrl:info.magicIcon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomGift];
        self.gitftNameLabel.text = info.magicName;
        self.giftPriceLabel.text = [NSString stringWithFormat:@"%ld金币",(long)info.magicPrice];
        
        self.gitftNameLabel.textColor = info.isSelected ? XCTheme.getTTMainColor : UIColorRGBAlpha(0xffffff, 1);
        self.giftPriceLabel.textColor = info.isSelected ? [XCTheme getTTMainColorWithAlpha:0.65] : UIColorRGBAlpha(0xffffff, 0.5);
        
        self.itemBgView.backgroundColor = info.isSelected ? UIColorRGBAlpha(0x0B0B0D, 0.1) : [UIColor clearColor];
        
    } else if(selectedType == SelectGiftType_giftPackage) {
        
        GiftInfo *info = (GiftInfo *)data;
        self.itemBgView.hidden = !info.isSelected;
        self.giftNumLabel.text = [NSString stringWithFormat:@"x%ld",(long)info.count];
        [self.giftImageView qn_setImageImageWithUrl:info.giftUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomGift];
        self.gitftNameLabel.text = info.giftName;
        NSString *coinStr = @"金币";
        if (info.consumeType == GiftConsumeTypeCoin) {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        } else if (info.consumeType == GiftConsumeTypeCarrot) {
            coinStr = @"";
            self.carrotGiftIconImageView.hidden = NO;
            NSString *strr = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
            CGFloat width = [NSString sizeWithText:strr font:self.giftPriceLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            CGFloat margin = (10 + 2 + width) * 0.5 - width * 0.5;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(margin);
            }];
            self.carrotGiftIconImageView.image = info.isSelected ? [UIImage imageNamed:@"send_gift_ radish_icon_selected"] : [UIImage imageNamed:@"send_gift_ radish_icon"];
        } else {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        }
        self.giftPriceLabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
        self.tagLabel.attributedText = [self creatSendGiftViewTagWithGiftInfo:info];
        
        self.gitftNameLabel.textColor = info.isSelected ? XCTheme.getTTMainColor : UIColorRGBAlpha(0xffffff, 1);
        self.giftPriceLabel.textColor = info.isSelected ? [XCTheme getTTMainColorWithAlpha:0.65] : UIColorRGBAlpha(0xffffff, 0.5);

        self.itemBgView.backgroundColor = info.isSelected ? UIColorRGBAlpha(0x0B0B0D, 0.1) : [UIColor clearColor];
        
    } else if(selectedType == SelectGiftType_nobleGift) {
        self.carrotGiftIconImageView.hidden = YES;
        GiftInfo *info = (GiftInfo *)data;
        
        self.itemBgView.hidden = !info.isSelected;
        [self.giftImageView qn_setImageImageWithUrl:info.giftUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomGift];
        self.gitftNameLabel.text = info.giftName;
        NSString *coinStr = @"金币";
        if (info.consumeType == GiftConsumeTypeCoin) {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        } else if (info.consumeType == GiftConsumeTypeCarrot) {
            coinStr = @"";
            self.carrotGiftIconImageView.hidden = NO;
            NSString *strr = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
            CGFloat width = [NSString sizeWithText:strr font:self.giftPriceLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
            CGFloat margin = (10 + 2 + width) * 0.5 - width * 0.5;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(margin);
            }];
            self.carrotGiftIconImageView.image = info.isSelected ? [UIImage imageNamed:@"send_gift_ radish_icon_selected"] : [UIImage imageNamed:@"send_gift_ radish_icon"];
        } else {
            coinStr = @"金币";
            self.carrotGiftIconImageView.hidden = YES;
            [self.giftPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.itemBgView).offset(0);
            }];
        }
        self.giftPriceLabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.goldPrice, coinStr];
        self.tagLabel.attributedText = [self creatSendGiftViewTagWithGiftInfo:info];
        
        self.gitftNameLabel.textColor = info.isSelected ? XCTheme.getTTMainColor : UIColorRGBAlpha(0xffffff, 1);
        self.giftPriceLabel.textColor = info.isSelected ? [XCTheme getTTMainColorWithAlpha:0.65] : UIColorRGBAlpha(0xffffff, 0.5);

        self.itemBgView.backgroundColor = info.isSelected ? UIColorRGBAlpha(0x0B0B0D, 0.1) : [UIColor clearColor];
    }
}

#pragma mark - Private
- (NSMutableAttributedString *)creatSendGiftViewTagWithGiftInfo:(GiftInfo *)giftInfo {
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    if (self.selectGiftType == SelectGiftType_nobleGift) {
        if (giftInfo.nobleId) {
            [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 26, 14) urlString:nil imageName:[NSString stringWithFormat:@"room_noble_gift_%d",giftInfo.nobleId]]];
        }
    } else {
        if (giftInfo.roomExclude) {
            if (attr.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
            }
            [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:@"send_gift_exclude"]];
        }
        if (giftInfo.hasLatest) {
            if (attr.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
            }
            [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:[TTSendGiftViewConfig globalConfig].send_gift_new]];
        }
        if (giftInfo.hasTimeLimit) {
            if (attr.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
            }
            [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:[TTSendGiftViewConfig globalConfig].send_gift_limit]];
        }
        if (giftInfo.hasEffect) {
            if (attr.length > 0) {
                [attr appendAttributedString:[self creatStrAttrByStr:@" "]];
            }
            [attr appendAttributedString:[self makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:[TTSendGiftViewConfig globalConfig].send_gift_effect]];
        }
    }
    
    return attr;
}

- (NSMutableAttributedString *)makeImageAttributedString:(CGRect)frame urlString:(NSString *)urlString imageName:(NSString *)imageName{
    UIImageView *charmImageView = [[UIImageView alloc]init];
    charmImageView.bounds = frame;
    charmImageView.contentMode = UIViewContentModeScaleToFill;
    if (urlString.length>0) {
        [charmImageView qn_setImageImageWithUrl:urlString placeholderImage:nil type:ImageTypeUserLibary];
    }else{
        charmImageView.image = [UIImage imageNamed:imageName];
    }
    NSMutableAttributedString * charmImageString = [NSMutableAttributedString yy_attachmentStringWithContent:charmImageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(charmImageView.frame.size.width, charmImageView.frame.size.height) alignToFont:[UIFont systemFontOfSize:15.0] alignment:YYTextVerticalAlignmentCenter];
    return charmImageString;
}

- (NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str {
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    return attr;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.itemBgView];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.giftNumLabel];
    [self.contentView addSubview:self.giftImageView];
    [self.contentView addSubview:self.gitftNameLabel];
    [self.contentView addSubview:self.giftPriceLabel];
    [self.contentView addSubview:self.carrotGiftIconImageView];
}

- (void)setupSubviewsConstraints {
    [self.itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.giftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(4.5);
        make.left.equalTo(self.contentView).offset(6);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftNumLabel);
        make.right.equalTo(self.contentView).offset(-3.5);
        make.height.equalTo(@14);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@48);
    }];
    
    [self.gitftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftImageView.mas_bottom).offset(3);
        make.centerX.equalTo(self.giftImageView);
        //        make.height.equalTo(@10);
    }];
    
    [self.carrotGiftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.giftPriceLabel.mas_left).offset(-2);
        make.width.height.mas_equalTo(10);
        make.top.mas_equalTo(self.gitftNameLabel.mas_bottom).offset(4);
    }];
    
    [self.giftPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gitftNameLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.itemBgView).offset(0);
        make.height.equalTo(@10);
    }];
}

- (UILabel *)createLabel:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    return label;
}

#pragma mark - Getter
- (UIView *)itemBgView {
    if (!_itemBgView) {
        _itemBgView = [[UIView alloc] init];
        _itemBgView.layer.cornerRadius = 6.0;
        _itemBgView.layer.masksToBounds = YES;
        _itemBgView.layer.borderWidth = 1.0;
        _itemBgView.layer.borderColor = [TTSendGiftViewConfig globalConfig].sendGiftItemCellBorderColor.CGColor;
        _itemBgView.backgroundColor = [UIColor clearColor];
    }
    return _itemBgView;
}

- (UILabel *)giftNumLabel {
    if (!_giftNumLabel) {
        _giftNumLabel = [self createLabel:9.0 textColor:UIColorRGBAlpha(0xffffff, 0.3)];
    }
    return _giftNumLabel;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
    }
    return _giftImageView;
}

- (UILabel *)gitftNameLabel {
    if (!_gitftNameLabel) {
        _gitftNameLabel = [self createLabel:10.0 textColor:UIColorFromRGB(0xffffff)];
    }
    return _gitftNameLabel;
}

- (UILabel *)giftPriceLabel {
    if (!_giftPriceLabel) {
        _giftPriceLabel = [self createLabel:9.0 textColor:UIColorRGBAlpha(0xffffff, 0.3)];
    }
    return _giftPriceLabel;
}

- (YYLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[YYLabel alloc] init];
    }
    return _tagLabel;
}

- (UIImageView *)carrotGiftIconImageView {
    if (!_carrotGiftIconImageView) {
        _carrotGiftIconImageView = [[UIImageView alloc] init];
        _carrotGiftIconImageView.image = [UIImage imageNamed:@"send_gift_ radish_icon"];
    }
    return _carrotGiftIconImageView;
}
@end
