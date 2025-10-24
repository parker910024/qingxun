//
//  TTSendGiftLimitView.h
//  WanBan
//
//  Created by jiangfuyuan on 2020/11/30.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ConsumptionLimit_Daily,
    ConsumptionLimit_Month,
} ConsumptionLimitType;

NS_ASSUME_NONNULL_BEGIN

@interface TTSendGiftLimitView : UIView
@property (nonatomic, assign) ConsumptionLimitType limitType;
@end

NS_ASSUME_NONNULL_END
