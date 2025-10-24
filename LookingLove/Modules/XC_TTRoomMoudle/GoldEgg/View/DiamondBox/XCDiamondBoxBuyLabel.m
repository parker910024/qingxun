//
//  XCDiamondBoxBuyLabel.m
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCDiamondBoxBuyLabel.h"
#import "Masonry.h"
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import "BaseAttrbutedStringHandler.h"
#import "XCTheme.h"

@interface XCDiamondBoxBuyLabel ()
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) YYLabel *label;
@end
@implementation XCDiamondBoxBuyLabel

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

- (void)dealloc{
    NSLog(@"XCDiamondBoxBuyLabel dealloc");
}

#pragma mark - Public Method

- (void)updateKeyNumber:(int)keyNumber {
    [self.label setAttributedText:[self createAttributeString:keyNumber]];
}

#pragma makr - Event Respond

- (void)buyButtonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDiamondBoxBuyButtonCliked)]) {
        [self.delegate onDiamondBoxBuyButtonCliked];
    }
}

#pragma mark - Private Method

- (void)setupSubviews {
    [self addSubview:self.label];
    [self addSubview:self.buyButton];
}

- (void)setupSubviewsConstraints {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset((-38-5)/2);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(5);
        make.centerY.equalTo(self.label);
        make.width.equalTo(@38);
        make.height.equalTo(@20);
    }];
}

//创建富文本
- (NSMutableAttributedString *)createAttributeString:(int)gold {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 25, 25) urlString:nil imageName:@"room_box_gold_key"]];
    [attributedString appendAttributedString:
     [BaseAttrbutedStringHandler creatStrAttrByStr:@" 剩余锤子: "
                                        attributed:@{NSForegroundColorAttributeName: UIColor.whiteColor,
                                                     NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    
    [attributedString appendAttributedString:
     [BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"%d ",gold]
                                        attributed:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFEA03),
                                                     NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    return attributedString;
}

#pragma mark - Getter

- (YYLabel *)label {
    if (!_label) {
        _label = [[YYLabel alloc] init];
        _label.attributedText = [self createAttributeString:0];
    }
    return _label;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] init];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"room_diamond_box_recharge"] forState:UIControlStateNormal];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [_buyButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_buyButton setTitleColor:UIColorFromRGB(0xC76200) forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}

@end

