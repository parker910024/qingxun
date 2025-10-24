//
//  AnchorOrderAttributedStringMaker.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/29.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderAttributedStringMaker.h"

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"

#import "AnchorOrderStatus.h"

#import "XCTheme.h"
#import "NSString+Utils.h"

#import <YYText/YYText.h>

@interface AnchorOrderAttributedStringMaker ()
@property (nonatomic, strong) NSTimer *anchorOrderTimer;//定时器
@property (nonatomic, assign) int anchorOrderTimeout;//订单超时

@property (nonatomic, copy) void(^updateHandler)(NSAttributedString *string);//更新交互
@property (nonatomic, copy) void(^tapHandler)(void);//点击交互
@property (nonatomic, copy) void(^markHandler)(void);//点击问号交互

@property (nonatomic, strong) AnchorOrderInfo *order;//订单

@property (nonatomic, strong) NSMutableAttributedString *orderAttributedString;//订单富文本

@property (nonatomic, assign) NSRange timeStrRange;//时间富文本位置

@end

@implementation AnchorOrderAttributedStringMaker

- (void)dealloc {
    if (self.anchorOrderTimer) {
        [self.anchorOrderTimer invalidate];
        self.anchorOrderTimer = nil;
    }
}

- (instancetype)initWithOrder:(AnchorOrderInfo *)order {
    self = [super init];
    if (self) {
        self.order = order;
        self.anchorOrderTimeout = order.orderFinalValidDate.timeIntervalSinceNow;
        
        self.orderAttributedString = [self anchorOrderAttributedString:self.order];
        
        @weakify(self)
        [self.orderAttributedString yy_setTextHighlightRange:NSMakeRange(0, self.orderAttributedString.length) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            @strongify(self)
            !self.tapHandler ?: self.tapHandler();
        }];
        
        [self addAnchorOrderTimer];
    }
    return self;
}

#pragma mark - Public
- (void)updateHandler:(void(^)(NSAttributedString *string))handler {
    if (self.updateHandler) {
        self.updateHandler = nil;
    }
    
    self.updateHandler = handler;
    
    if (self.orderAttributedString) {
        !self.updateHandler ?: self.updateHandler(self.orderAttributedString);
    }
}

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
    
    if (handler && self.timeStrRange.location+self.timeStrRange.length==self.orderAttributedString.length) {
        
        NSInteger markLoc = self.orderAttributedString.length;
        
        [self.orderAttributedString appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:8]];
        [self.orderAttributedString appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 14, 14) urlString:nil imageName:@"littleWorld_dynamic_ico_mark"]];
        [self.orderAttributedString appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
        
        @weakify(self)
        [self.orderAttributedString yy_setTextHighlightRange:NSMakeRange(markLoc, self.orderAttributedString.length-markLoc) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            @strongify(self)
            !self.markHandler ?: self.markHandler();
        }];
    }
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
    [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:6]];
    
    NSInteger timeLoc = str.length;
    
    NSAttributedString *timeStr = [self timeAttributedString];
    [str appendAttributedString:timeStr];
    
    self.timeStrRange = NSMakeRange(timeLoc, timeStr.length);
    
    return str;
}

/// 更新时间富文本
- (void)updateTimeAttributedString {
    //更新倒计时
    NSAttributedString *timeStr = [self timeAttributedString];
    [self.orderAttributedString replaceCharactersInRange:self.timeStrRange withAttributedString:timeStr];
    //更新时间字符区域
    self.timeStrRange = NSMakeRange(self.timeStrRange.location, timeStr.length);
    //更新富文本
    !self.updateHandler ?: self.updateHandler(self.orderAttributedString);
    
    @weakify(self)
    //设置点击事件
    NSInteger orderTapLength = self.timeStrRange.location + self.timeStrRange.length;//订单点击区域
    [self.orderAttributedString yy_setTextHighlightRange:NSMakeRange(0, orderTapLength) color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        @strongify(self)
        !self.tapHandler ?: self.tapHandler();
    }];
}

/// 时间富文本
- (NSAttributedString *)timeAttributedString {
    
    int time = self.anchorOrderTimeout;
    NSString *timeForm = [NSString stringWithFormat:@"%d:%02d",time/60 ,time%60];

    if (time <= 0) {
        timeForm = @"已失效";
    }
    
    NSAttributedString *timeStr = [BaseAttrbutedStringHandler textAttributedString:timeForm textColor:UIColorFromRGB(0x999999) textFont:[UIFont systemFontOfSize:12] alignmentFont:[UIFont systemFontOfSize:15] fixedWidth:40];
    
    return timeStr;
}

#pragma mark - Anchor Order Timer
- (void)timerCountdownHandler {
    
    self.anchorOrderTimeout -= 1;
    if (self.anchorOrderTimeout <= 0) {
        [self removeAnchorOrderTimer];
    }
    
    [self updateTimeAttributedString];
}

- (void)addAnchorOrderTimer {
    if (self.anchorOrderTimeout <= 0) {
        [self timerCountdownHandler];
        return;
    }
    
    self.anchorOrderTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountdownHandler) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.anchorOrderTimer forMode:NSRunLoopCommonModes];
}

- (void)removeAnchorOrderTimer {
    if (self.anchorOrderTimer) {
        [self.anchorOrderTimer invalidate];
        self.anchorOrderTimer = nil;
    }
}

@end
