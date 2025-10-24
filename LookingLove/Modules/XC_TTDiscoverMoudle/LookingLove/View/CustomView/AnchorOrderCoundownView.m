//
//  AnchorOrderCoundownView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/5/10.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderCoundownView.h"

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"

#import "AnchorOrderStatus.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSString+Utils.h"
#import "UIButton+EnlargeTouchArea.h"

#import <YYText/YYText.h>
#import <MZTimerLabel/MZTimerLabel.h>
#import <Masonry/Masonry.h>

@interface AnchorOrderCoundownView ()<MZTimerLabelDelegate>

@property (nonatomic,strong) YYLabel *anchorOrderLabel;// 主播标签
@property (nonatomic, strong) MZTimerLabel *timerLabel;//定时器
@property (nonatomic, strong) UIButton *markButton;//问号

@property (nonatomic, copy) void(^tapHandler)(void);//点击交互
@property (nonatomic, copy) void(^markHandler)(void);//点击问号交互

@end

@implementation AnchorOrderCoundownView

- (void)dealloc {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self layoutUI];
        
        [self addTarget:self action:@selector(didClickCountdownView) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(KScreenWidth, 16);
}

- (void)setOrder:(AnchorOrderInfo *)order {
    if (order == nil) {
        return;
    }
    
    _order = order;
    
    self.anchorOrderLabel.attributedText = [self anchorOrderAttributedString:self.order];
    self.anchorOrderLabel.lineBreakMode = NSLineBreakByClipping;
    [self.timerLabel pause];
    [self.timerLabel reset];
    
    NSInteger seconds = order.orderFinalValidDate.timeIntervalSinceNow;
    if (seconds > 0) {
        [self.timerLabel setCountDownToDate:order.orderFinalValidDate];
        [self.timerLabel start];
    } else {
        self.timerLabel.text = @"可预约";
    }
}

- (void)layoutUI {
    [self addSubview:self.anchorOrderLabel];
    [self addSubview:self.timerLabel];
    [self addSubview:self.markButton];
    
    [self.anchorOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(0);
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.anchorOrderLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(42);
    }];
    
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timerLabel.mas_right).offset(6);
        make.right.mas_lessThanOrEqualTo(-6);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(14);
    }];
}

#pragma mark - MZTimerLabelDelegate
- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    
    timerLabel.text = @"可预约";
}

- (NSString *)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time {
    
    int min = (int)time/60;
    int sec = (int)time%60;
    NSString *timeForm = [NSString stringWithFormat:@"%2d:%02d", min, sec];
    if (min > 99) {
        timeForm = [NSString stringWithFormat:@"%d:%02d", min, sec];
    }
    
    return timeForm;
}

#pragma mark - Public
- (void)tapOrderHandler:(void(^)(void))handler {
    if (self.tapHandler) {
        self.tapHandler = nil;
    }
    
    self.tapHandler = handler;
}

- (void)tapMarkHandler:(void(^)(void))handler {
    if (self.markHandler) {
        self.markHandler = nil;
    }
    
    self.markHandler = handler;
    
    self.markButton.hidden = handler == nil;
}

#pragma mark - Order Attributed String
/// 订单富文本生成
/// @param order 订单
- (NSMutableAttributedString *)anchorOrderAttributedString:(AnchorOrderInfo *)order {
    if (order == nil) {
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *tagStr = [BaseAttrbutedStringHandler anchorSkillTagAttributedStringWithLabel:order.orderType color:UIColorFromRGB(0xFFAD37)];
    [str appendAttributedString:tagStr];
    [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:5]];
    
    NSString *price = [NSString stringWithFormat:@"%@金币/%@min", order.orderPrice, @(order.orderDuration).stringValue];
    NSAttributedString *priceStr = [BaseAttrbutedStringHandler textAttributedString:price textColor:UIColorFromRGB(0xFFAD37) textFont:[UIFont systemFontOfSize:12] alignmentFont:[UIFont systemFontOfSize:15]];
    [str appendAttributedString:priceStr];

    return str;
}

#pragma mark - Action
- (void)didClickCountdownView {
    !self.tapHandler ?: self.tapHandler();
}

- (void)didClickMarkButton:(UIButton *)sender {
    !self.markHandler ?: self.markHandler();
}

#pragma mark - Lazy Load
- (YYLabel *)anchorOrderLabel {
    if (_anchorOrderLabel == nil) {
        _anchorOrderLabel = [[YYLabel alloc] init];
        _anchorOrderLabel.userInteractionEnabled = NO;
    }
    return _anchorOrderLabel;
}

- (MZTimerLabel *)timerLabel {
    if (_timerLabel == nil) {
        _timerLabel = [[MZTimerLabel alloc] init];
        _timerLabel.delegate = self;
        _timerLabel.timerType = MZTimerLabelTypeTimer;
        _timerLabel.timeLabel.font = [UIFont systemFontOfSize:12];
        _timerLabel.timeLabel.textColor = UIColorFromRGB(0xABAAB3);
        _timerLabel.timeFormat = @"mm:ss";
    }
    return _timerLabel;
}

- (UIButton *)markButton {
    if (_markButton == nil) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setImage:[UIImage imageNamed:@"littleWorld_dynamic_ico_mark"] forState:UIControlStateNormal];
        [_markButton addTarget:self action:@selector(didClickMarkButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_markButton enlargeTouchArea:UIEdgeInsetsMake(6, 6, 6, 6)];
        
        _markButton.hidden = YES;
    }
    return _markButton;
}

@end
