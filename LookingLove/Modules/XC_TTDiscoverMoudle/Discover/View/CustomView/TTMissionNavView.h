//
//  TTMissionNavView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  任务中心自定义导航栏

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTMissionNavView;

@protocol TTMissionNavViewDelegate<NSObject>
- (void)didClickBackButtonInMissionNavView:(TTMissionNavView *)navView;
@end

@interface TTMissionNavView : UIView
@property (nonatomic, weak) id<TTMissionNavViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
