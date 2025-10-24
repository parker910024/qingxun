//
//  XCPlaceholderTextView.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/3/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCPlaceholderTextView : UITextView
/** 占位文本*/
@property(copy,nonatomic)   NSString *placeholder;

/** 最大长度设置*/
@property(assign,nonatomic) NSInteger maxTextLength;

/** 更新高度*/
@property(assign,nonatomic) float updateHeight;


/**
 *  增加text 长度限制
 */
-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(XCPlaceholderTextView *text))limit;
/**
 *  开始编辑 的 回调
 */
-(void)addTextViewBeginEvent:(void(^)(XCPlaceholderTextView *text))begin;

/**
 *  文本改变 的 回调
 */
-(void)addTextViewUpdateEvent:(void(^)(XCPlaceholderTextView *text))update;

/**
 *  结束编辑 的 回调
 */
-(void)addTextViewEndEvent:(void(^)(XCPlaceholderTextView *text))End;


/** 设置Placeholder 颜色 */
-(void)setPlaceholderColor:(UIColor*)color;

/** 设置Placeholder 字体 */
-(void)setPlaceholderFont:(UIFont*)font;

/** 设置透明度 */
-(void)setPlaceholderOpacity:(float)opacity;

@end

NS_ASSUME_NONNULL_END
