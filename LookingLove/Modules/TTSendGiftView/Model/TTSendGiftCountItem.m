//
//  TTSendGiftCountItem.m
//  TTSendGiftView
//
//  Created by Macx on 2019/5/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftCountItem.h"

@implementation TTSendGiftCountItem

+ (instancetype)itemWithGiftNormalTitle:(NSString *)giftNormalTitle giftCount:(NSString *)giftCount {
    TTSendGiftCountItem *item = [[self alloc] init];
    item.giftNormalTitle = giftNormalTitle;
    item.giftCount = giftCount;
    item.isCustomCount = NO;
    return item;
}
@end
