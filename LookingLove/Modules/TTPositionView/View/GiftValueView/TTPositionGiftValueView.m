//
//  TTPositionGiftValueView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/21.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionGiftValueView.h"
#import <Masonry/Masonry.h>

#import "UIImage+Utils.h"
#import "XCTheme.h"


@interface TTPositionGiftValueView()
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

@implementation TTPositionGiftValueView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        ///解决 self 初始化 frame 为 0 约束尽管
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self initViews];
        [self initConstraints];
        self.backgroundColor = UIColor.orangeColor;
    }
    return self;
}

- (void)dealloc {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 处理 view 的背景图，可自动拉伸
    UIImage *bgImage = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xFD5766), UIColorFromRGB(0xFE7763)] gradientType:GradientTypeLeftToRight imgSize:self.bounds.size];
    
    CGFloat imgW = bgImage.size.width * 0.5;
    CGFloat imgH = bgImage.size.height * 0.5;
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                byRoundingCorners:UIRectCornerAllCorners
                                                      cornerRadii:CGSizeMake(imgW, imgH)];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, imgH, imgW, imgH)
                                                byRoundingCorners:UIRectCornerBottomLeft
                                                      cornerRadii:CGSizeMake(imgW, imgH)];
    
    [path1 appendPath:path2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path1.CGPath;
    shapeLayer.frame = self.bounds;
    self.layer.contents = (id)bgImage.CGImage; // 设置view 背景图
    self.layer.mask = shapeLayer; // layer 切的个性圆角
    
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
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(8);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(3);
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - Getters and Setters
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"room_game_position_giftValue_heart"];
        
        [_iconImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _iconImageView;
}

- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = UIColor.whiteColor;
        _valueLabel.font = [UIFont systemFontOfSize:9];
        _valueLabel.text = @"0";
        
        [_valueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _valueLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
