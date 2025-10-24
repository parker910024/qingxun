//
//  DSPositionGiftValueView.m
//  DSPositionView
//
//  Created by fengshuo on 2019/5/21.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "MYPositionGiftValueView.h"
#import <Masonry/Masonry.h>

#import "UIImage+Utils.h"
#import "XCTheme.h"


@interface MYPositionGiftValueView()
/**
 心形图标
 */
@property (nonatomic, strong) UIImageView *iconImageView;
/**
 礼物值
 */
@property (nonatomic, strong) UILabel *valueLabel;

@property(nonatomic, assign) long long giftValue;

@end

@implementation MYPositionGiftValueView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        ///解决 self 初始化 frame 为 0 约束尽管
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self initViews];
        [self initConstraints];
        
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.2);
    }
    return self;
}

- (void)dealloc {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(self.valueLabel).offset(5);
//    }];
}

#pragma mark - Public Methods
/**
 更新礼物值
 */
- (void)updateGiftValue:(long long)giftValue {
    NSString *value;
    if (giftValue < 1000000) {
        value = @(giftValue).stringValue;
    } else if (giftValue >= 100000000) {
        value = @"9999万+";
    } else {
        value = [NSString stringWithFormat:@"%lld万", giftValue/10000];
    }
    
    self.valueLabel.text = value;
    
    self.giftValue = giftValue;
}

#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.valueLabel];
}

- (void)initConstraints {
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(9);
    }];
    
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(5);
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - Getters and Setters
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"room_love_position_giftValue_heart"];
        [_iconImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _iconImageView;
}

- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = UIColorRGBAlpha(0xffffff, 0.8);
        _valueLabel.font = [UIFont systemFontOfSize:10];
        _valueLabel.text = @"0";
        [_valueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _valueLabel;
}


@end
