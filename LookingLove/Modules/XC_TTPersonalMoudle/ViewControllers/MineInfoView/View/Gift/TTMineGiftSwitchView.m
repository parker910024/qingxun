//
//  TTMineGiftSwitchView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineGiftSwitchView.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTMineGiftSwitchView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *switchButton;
@end

@implementation TTMineGiftSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self subviewsInitAndLayout];
        
        self.exhibitType = TTGiftExhibitTypeAchievement;//Set default type
    }
    return self;
}

- (void)subviewsInitAndLayout {
    self.iconView = [[UIImageView alloc] init];
    [self addSubview:self.iconView];
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchButton setTitleColor:XCThemeSubTextColor forState:UIControlStateNormal];
    self.switchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.switchButton setImage:[UIImage imageNamed:@"mine_gift_shift"] forState:UIControlStateNormal];
    self.switchButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.switchButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.switchButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.switchButton addTarget:self action:@selector(didClickSwithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchButton];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)didClickSwithButton:(UIButton *)sender {
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        self.exhibitType = TTGiftExhibitTypeReceive;
    } else {
        self.exhibitType = TTGiftExhibitTypeAchievement;
    }
    
    !self.switchTypeHandler ?: self.switchTypeHandler(self.exhibitType);
}

#pragma mark - Public
/// 禁止展示成就礼物（后端未配置成就礼物时）
- (void)forbidExhibitAchievementGift {
    self.switchButton.hidden = YES;
    self.exhibitType = TTGiftExhibitTypeReceive;
}

#pragma mark - Lazy Load
- (void)setExhibitType:(TTGiftExhibitType)exhibitType {
    _exhibitType = exhibitType;
    
    BOOL achievement = exhibitType == TTGiftExhibitTypeAchievement;
    NSString *icon = achievement ? @"mine_gift_achievement" : @"mine_gift_receive";
    NSString *title = achievement ? @"收到的礼物" : @"礼物成就";
    self.iconView.image = [UIImage imageNamed:icon];
    [self.switchButton setTitle:title forState:UIControlStateNormal];
}

@end
