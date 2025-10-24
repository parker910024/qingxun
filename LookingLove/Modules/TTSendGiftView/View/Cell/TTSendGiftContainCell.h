//
//  TTSendGiftContainCell.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSendGiftItemCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TTSendGiftContainCell, GiftInfo, RoomMagicInfo;
@protocol TTSendGiftContainCellDelegate<NSObject>

@optional
- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedGift:(GiftInfo *)giftInfo;
- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedPackageGift:(GiftInfo *)giftPackInfo;
- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedMagic:(RoomMagicInfo *)magicInfo;
- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedNobleGift:(GiftInfo *)nobleGiftInfo;

@end

@interface TTSendGiftContainCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<GiftInfo *> *giftInfos;//礼物
@property (nonatomic, strong) NSArray<RoomMagicInfo *> *maigcInfos;//魔法
@property (nonatomic, strong) NSArray<GiftInfo *> *giftPackInfos;//背包礼物
@property (nonatomic, strong) NSArray<GiftInfo *> *nobleGiftInfos;//贵族礼物
@property (nonatomic, assign) NSInteger section;//当前的section
@property (nonatomic, assign) SelectGiftType type;//类型
@property (nonatomic, weak) id<TTSendGiftContainCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
