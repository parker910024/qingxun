//
//  LLPostDynamicViewController.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^PostDynamicSuccessBlock)(void);

@interface LLPostDynamicViewController : BaseUIViewController
@property (nonatomic, copy) PostDynamicSuccessBlock refreshDynamicBlock;

/// 初始化指定小世界里面的发布动态
/// @discussion 如果不指定小世界，直接调用【init】方法
/// @param worldId 小世界Id
/// @param worldName 小世界名称
- (instancetype)initWithWorldId:(NSString *)worldId worldName:(NSString *)worldName;

/// 动态分享图片
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;
@end

NS_ASSUME_NONNULL_END
