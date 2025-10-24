//
//  TTBlindDateResultView.h
//  WanBan
//
//  Created by lvjunhang on 2020/10/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  相亲结果

#import <UIKit/UIKit.h>

#import "RoomLoveModelSuccess.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTBlindDateResultView : UIView
@property (nonatomic, copy) void (^shareHandler)(UIImage *img);//分享回调

/// 相亲结果处理
- (void)handleResult:(RoomLoveModelSuccess *)model;

@end

NS_ASSUME_NONNULL_END
