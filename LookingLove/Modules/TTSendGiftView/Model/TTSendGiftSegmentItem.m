//
//  TTSendGiftSegmentItem.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftSegmentItem.h"

@implementation TTSendGiftSegmentItem
+ (instancetype)itemWithTitle:(NSString *)title{
    TTSendGiftSegmentItem *item = [[self alloc] init];
    item.title = title;
    item.isSelected = NO;
    return item;
}
@end
