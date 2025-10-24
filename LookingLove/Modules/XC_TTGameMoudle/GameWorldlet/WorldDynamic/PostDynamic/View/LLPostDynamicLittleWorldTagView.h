//
//  LLPostDynamicLittleWorldTagView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/7.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  发布动态的小世界标签

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LittleWorldDynamicPostWorld;

@interface LLPostDynamicLittleWorldTagView : UIView
@property (nonatomic, strong) LittleWorldDynamicPostWorld *model;

@property (nonatomic, copy) void (^selectTagHandler)(void);


#pragma mark - Public
/// 获取宽度
- (CGFloat)width;

@end

NS_ASSUME_NONNULL_END
