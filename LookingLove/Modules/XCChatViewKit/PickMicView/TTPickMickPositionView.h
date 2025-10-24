//
//  TTPickMickPositionView.h
//  WanBan
//
//  Created by lvjunhang on 2020/10/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  麦位

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPickMickPositionView : UIControl
/// 是否被占用
@property (nonatomic, assign, getter=isPicked) BOOL picked;

/// 坑位名称
- (void)postionLabel:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
