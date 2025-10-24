//
//  TTGiftCell.m
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoGiftCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import <SDWebImage/UIImageView+WebCache.h>
// model
#import "RoomMagicWallInfo.h"
#import "UserGift.h"

//cate
#import "UIImageView+QiNiu.h"

@implementation TTMineInfoGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.giftImage];
    [self.contentView addSubview:self.giftName];
    [self.contentView addSubview:self.giftNumber];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.frame.size.width);
    }];
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(19);
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.giftImage.mas_bottom).offset(5);
    }];
    [self.giftNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark -
#pragma mark private methods
- (void)configCellModel:(__kindof BaseObject *)baseObject {
    if ([baseObject isKindOfClass:[UserGift class]]) {
        UserGift *giftInfo = (UserGift *)baseObject;
        if (giftInfo.picUrl) {
            [self.giftImage qn_setImageImageWithUrl:giftInfo.picUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomGift];
        }else {
            [self.giftImage setImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
        }
        self.giftName.text = giftInfo.giftName;
        if (self.isCarrot) {
            self.giftNumber.text = [NSString stringWithFormat:@"X%ld", giftInfo.receiveCount];
        } else {
            self.giftNumber.text = [NSString stringWithFormat:@"%@", giftInfo.reciveCount];
        }
    }
    
    if ([baseObject isKindOfClass:[RoomMagicWallInfo class]]) {
        RoomMagicWallInfo *magic = (RoomMagicWallInfo *)baseObject;
        if (magic.magicIcon) {
            [self.giftImage qn_setImageImageWithUrl:magic.magicIcon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomMagic];
        }else {
            [self.giftImage setImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
        }
        self.giftName.text = magic.magicName;
        self.giftNumber.text = [NSString stringWithFormat:@"X%@", magic.amount];
    }
}

#pragma mark - Getter && Setter

- (UIImageView *)giftImage {
    if (!_giftImage) {
        _giftImage = [[UIImageView alloc] init];
        _giftImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImage;
}

- (UILabel *)giftName {
    if (!_giftName) {
        _giftName = [[UILabel alloc] init];
        _giftName.textAlignment = NSTextAlignmentCenter;
        _giftName.textColor = [XCTheme getMSMainTextColor];
        _giftName.font = [UIFont systemFontOfSize:14];
    }
    return _giftName;
}

- (UILabel *)giftNumber {
    if (!_giftNumber) {
        _giftNumber = [[UILabel alloc] init];
        _giftNumber.textAlignment = NSTextAlignmentCenter;
        _giftNumber.textColor = [XCTheme getMSThirdTextColor];
        _giftNumber.font = [UIFont systemFontOfSize:14];
    }
    return _giftNumber;
}


@end
