//
//  TTPositionGiftValueDetailView.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/21.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionGiftValueDetailView : UIView
// 容器view
@property(nonatomic, strong, readonly) UIView *containView;
// 向下的箭头
@property(nonatomic, strong, readonly) UIImageView *downArrowImage;

/**
 礼物值数据
 
 @param giftValue 礼物值
 */
- (void)updateGiftValue:(long long)giftValue;
@end

NS_ASSUME_NONNULL_END
