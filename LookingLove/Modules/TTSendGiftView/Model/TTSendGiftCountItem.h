//
//  TTSendGiftCountItem.h
//  TTSendGiftView
//
//  Created by Macx on 2019/5/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTSendGiftCountItem : BaseObject
@property (nonatomic, copy) NSString *giftNormalTitle;//礼物标题
@property (nonatomic, copy) NSString *giftCount;//礼物数量
/** 是否是自定义数量 默认为NO */
@property (nonatomic, assign) BOOL isCustomCount;

+ (instancetype)itemWithGiftNormalTitle:(NSString *)giftNormalTitle giftCount:(NSString *)giftCount;
@end

NS_ASSUME_NONNULL_END
