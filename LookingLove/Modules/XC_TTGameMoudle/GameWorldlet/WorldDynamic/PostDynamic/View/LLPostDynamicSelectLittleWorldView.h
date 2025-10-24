//
//  LLPostDynamicSelectLittleWorldView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/7.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  发布动态的选择小世界

#import <UIKit/UIKit.h>

@class LittleWorldDynamicPostWorld;

NS_ASSUME_NONNULL_BEGIN

@interface LLPostDynamicSelectLittleWorldView : UIView
@property (nonatomic, strong, nullable) NSArray<LittleWorldDynamicPostWorld *> *worldArray;
@property (nonatomic, strong, nullable) LittleWorldDynamicPostWorld *selectWorld;//当前选中小世界

@property (nonatomic, copy) void (^selectWorldHandler)(void);//选择小世界

@end

NS_ASSUME_NONNULL_END
