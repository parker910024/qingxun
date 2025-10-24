//
//  TTGiftCountContainerView.h
//  TTSendGiftView
//
//  Created by Macx on 2019/5/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSendGiftCountItem.h"

NS_ASSUME_NONNULL_BEGIN
@class TTGiftCountContainerView;

@protocol TTGiftCountContainerViewDelegate <NSObject>
@optional;

/**
 点击了数量cell

 @param countView self
 @param countItem 礼物数量模型
 */
- (void)giftCountContainerView:(TTGiftCountContainerView *)countView didSelectItem:(TTSendGiftCountItem *)countItem;
@end

@interface TTGiftCountContainerView : UIView
/** delegate */
@property (nonatomic, weak) id<TTGiftCountContainerViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
