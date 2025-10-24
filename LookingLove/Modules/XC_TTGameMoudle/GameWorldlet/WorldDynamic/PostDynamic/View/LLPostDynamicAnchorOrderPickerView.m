//
//  LLPostDynamicAnchorOrderPickerView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicAnchorOrderPickerView.h"

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"

#import "AnchorOrderStatus.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"
#import "NSString+Utils.h"
#import "TTStatisticsService.h"
#import "BaseAttrbutedStringHandler.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

@interface LLPostDynamicAnchorOrderPickerView ()

@property (nonatomic, strong) UILabel *makeOrderLabel;//接单
@property (nonatomic, strong) UIButton *selectButton;//选择按钮
@property (nonatomic, strong) YYLabel *selectOrderLabel;//已选择订单
@property (nonatomic, strong) UIButton *deleteButton;//已选择删除按钮
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@property (nonatomic, strong) UIView *sepatateLine;//分割线

@end

@implementation LLPostDynamicAnchorOrderPickerView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupConstraint];
        
        //初始化显示
        self.selectOrder = nil;
    }
    return self;
}

#pragma mark - Actions
///选择按钮
- (void)onClickSelectButton:(UIButton *)sender {
    !self.selectOrderHandler ?: self.selectOrderHandler();
}

///已选择删除按钮
- (void)onClickDeleteButton:(UIButton *)sender {
    
    [TTStatisticsService trackEvent:@"world_delete_order" eventDescribe:@"发布动态_删除接单信息"];

    self.selectOrder = nil;
}

/// 设置订单富文本
- (void)setupAnchorOrderAttributedString {
    
    if (self.selectOrder == nil) {
        self.selectOrderLabel.attributedText = nil;
        return;
    }
    
    NSAttributedString *orderStr = [self anchorOrderAttributedString:self.selectOrder];
    self.selectOrderLabel.attributedText = orderStr;
}

/// 订单富文本生成
/// @param order 订单
- (NSAttributedString *)anchorOrderAttributedString:(AnchorOrderInfo *)order {
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
    [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:8]];

    NSString *time = [NSString stringWithFormat:@"%@min有效", order.orderValidTime];
    NSAttributedString *timerStr = [BaseAttrbutedStringHandler textAttributedString:time textColor:UIColorFromRGB(0x999999) textFont:[UIFont systemFontOfSize:12] alignmentFont:[UIFont systemFontOfSize:15]];
    [str appendAttributedString:timerStr];
    
    return str.copy;
}

#pragma mark - Private
- (void)setupView {
    [self addSubview:self.makeOrderLabel];
    [self addSubview:self.selectButton];
    [self addSubview:self.selectOrderLabel];
    [self addSubview:self.deleteButton];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.sepatateLine];
}

- (void)setupConstraint {
    [self.sepatateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.makeOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.arrowImageView);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.makeOrderLabel);
        make.right.mas_equalTo(self.arrowImageView);
        make.bottom.mas_equalTo(self.sepatateLine);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.arrowImageView);
    }];
    
    [self.selectOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.makeOrderLabel).offset(20);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.makeOrderLabel);
    }];
}

#pragma mark - Setter Getter
- (void)setSelectOrder:(AnchorOrderInfo *)selectOrder {
    if (_selectOrder == selectOrder) {
        return;
    }
    
    _selectOrder = selectOrder;
    
    [self setupAnchorOrderAttributedString];
    
    self.selectButton.hidden = selectOrder;
    self.deleteButton.hidden = !self.selectButton.isHidden;
}

- (UILabel *)makeOrderLabel {
    if (!_makeOrderLabel) {
        _makeOrderLabel = [[UILabel alloc] init];
        _makeOrderLabel.text = @"接单";
        _makeOrderLabel.font = [UIFont systemFontOfSize:15];
        _makeOrderLabel.textColor = XCThemeMainTextColor;
    }
    return _makeOrderLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onClickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _selectButton = button;
    }
    return _selectButton;
}

- (YYLabel *)selectOrderLabel {
    if (!_selectOrderLabel) {
        _selectOrderLabel = [[YYLabel alloc] init];
    }
    return _selectOrderLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"littleWorld_post_delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];

        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        button.hidden = YES;
        
        _deleteButton = button;
    }
    return _deleteButton;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleWorld_post_more"]];
    }
    return _arrowImageView;
}

- (UIView *)sepatateLine {
    if (!_sepatateLine) {
        _sepatateLine = [[UIView alloc] init];
        _sepatateLine.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return _sepatateLine;
}

@end

