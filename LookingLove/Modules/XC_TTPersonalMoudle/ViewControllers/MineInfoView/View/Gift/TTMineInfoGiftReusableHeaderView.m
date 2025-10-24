//
//  TTMineInfoGiftReusableHeaderView.m
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoGiftReusableHeaderView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "RoomMagicWallInfo.h"
#import "UserGift.h"
#import "UserGiftAchievementList.h"

@interface TTMineInfoGiftReusableHeaderView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TTMineInfoGiftReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
        [self initConstraints];
    }
    return self;
}


#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.textLabel];
    [self addSubview:self.countLabel];
}

- (void)initConstraints {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(15);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - gettter & setter
- (void)setUserGiftList:(NSArray<UserGift *> *)userGiftList {
    _userGiftList = userGiftList;
    __block NSInteger sum = 0;
    if (userGiftList) {
        [userGiftList enumerateObjectsUsingBlock:^(UserGift * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += obj.reciveCount.integerValue;
        }];
    }
    self.textLabel.text = @"收到的礼物";
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)sum];
}

- (void)setUserMagicList:(NSArray<RoomMagicWallInfo *> *)userMagicList {
    _userMagicList = userMagicList;
    __block NSInteger sum = 0;
    if (userMagicList) {
        [userMagicList enumerateObjectsUsingBlock:^(RoomMagicWallInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += obj.amount.integerValue;
        }];
    }
    self.textLabel.text = @"被施展的魔法";
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)sum];
}

- (void)setCarrotGiftList:(NSArray<UserGift *> *)carrotGiftList {
    _carrotGiftList = carrotGiftList;
    __block NSInteger sum = 0;
    if (carrotGiftList) {
        [carrotGiftList enumerateObjectsUsingBlock:^(UserGift * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += obj.receiveCount;
        }];
    }
    self.textLabel.text = @"收到的萝卜礼物";
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)sum];
}

- (void)setAchievementGiftList:(UserGiftAchievementList *)achievementGiftList {
    _achievementGiftList = achievementGiftList;
    
    self.textLabel.text = achievementGiftList.typeName;
    self.countLabel.text = [NSString stringWithFormat:@"(%ld/%ld)", (long)achievementGiftList.attainNum, (long)achievementGiftList.totalNum];
}

- (void)setHiddenGiftCount:(BOOL)hiddenGiftCount {
    _hiddenGiftCount = hiddenGiftCount;
    
    self.countLabel.hidden = hiddenGiftCount;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getMSMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [XCTheme getMSThirdTextColor];
        _countLabel.font = [UIFont systemFontOfSize:13.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _countLabel;
}
@end
