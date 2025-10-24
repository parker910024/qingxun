//
//  DSPositionGiftValueView.h
//  DSPositionView
//
//  Created by fengshuo on 2019/5/21.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPositionGiftValueView : UIControl
// 礼物值
@property(nonatomic, assign, readonly) long long giftValue;
/**
 更新礼物值
 */
- (void)updateGiftValue:(long long)giftValue;
@end

NS_ASSUME_NONNULL_END
