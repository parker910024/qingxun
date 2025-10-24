//
//  TTUserProtocolView.h
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTUserProtocolViewDelegate <NSObject>

- (void)onSelectBtnClicked:(BOOL)select;

@end

@interface TTUserProtocolView : UIView
/**
 导航控制器
 */
@property(nonatomic, weak) UINavigationController *nav;

/**
 代理
 */
@property(nonatomic, weak) id<TTUserProtocolViewDelegate> delegate;

/**
 是不是隐藏勾选框
 */
@property (nonatomic, assign) BOOL isHiddenCheck;

/**
 描述的文字
 */
@property (nonatomic, copy) NSString * agreementString;

/**
 描述的文字 富文本
 */
@property (nonatomic, copy) NSMutableAttributedString *agreementAttString;

/**
 协议的描述
 */
@property (nonatomic, copy) NSString * protocolString;

/**
 协议的颜色
 */
@property (nonatomic, strong) UIColor * protocolColor;

/**
 协议的地址
 */
@property (nonatomic, copy) NSString * protocolUrl;

/**
 控件的宽度
 */
- (CGFloat)getViewWidth;

/**
 选择框是不是选择了
 
 @return 是或者不是
 */
- (BOOL)isSelect;

@end
