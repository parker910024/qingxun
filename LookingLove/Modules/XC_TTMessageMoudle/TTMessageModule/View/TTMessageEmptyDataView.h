//
//  TTMessageEmptyDataView.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  消息模块无数据占位显示控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTMessageEmptyDataView;

@protocol TTMessageEmptyDataViewDelegate <NSObject>

@optional
/**
 点击无数据视图事件处理

 @param emptyDataView 当前无数据视图
 */
- (void)didTapEmptyDataView:(TTMessageEmptyDataView *)emptyDataView;

@end

@interface TTMessageEmptyDataView : UIControl

/**
 视图的事件代理
 */
@property (nonatomic, assign) id<TTMessageEmptyDataViewDelegate> delegate;

/**
 显示提示信息，默认：暂无数据
 */
@property (nonatomic, copy, nullable) NSString *text;

/**
 直接初始化富文本显示提示信息，默认：nil
 @discussion 如果 msg 设置不满足要求，比如两行文字大小不一，可使用此属性
 */
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;

/**
 显示提示图片，默认：[[XCTheme defaultTheme] default_empty]
 */
@property (nonatomic, copy) NSString *image;

/**
 提示信息文本大小，默认：13
 */
@property (nonatomic, assign) CGFloat textFontSize;

/**
 提示信息文本颜色，默认：[XCTheme getTTDeepGrayTextColor]
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 文本行距，默认：12
 */
@property (nonatomic, assign) CGFloat textLineSpacing;

/**
 文本底部距图片底部的偏移，默认：0
 @discussion 约束底部偏移，因为有些文本和图片是有重叠的，所以可正可负，负值时跌在图片上面
 */
@property (nonatomic, assign) CGFloat textToImageBottomOffset;

/**
 图片中心点竖直偏移，默认：0
 @discussion 正值：向下偏移，负值：向上偏移
 */
@property (nonatomic, assign) CGFloat imageCenterOffsetY;

@end

NS_ASSUME_NONNULL_END
