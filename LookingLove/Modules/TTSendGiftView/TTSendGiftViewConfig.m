//
//  TTSendGiftViewConfig.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftViewConfig.h"
#import "XCTheme.h"

@implementation TTSendGiftViewConfig
#pragma mark - life cycle
+ (TTSendGiftViewConfig *)globalConfig {
    
    static TTSendGiftViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [TTSendGiftViewConfig new];
    });
    return config;
}

- (instancetype)init {
    if (self = [super init]) {
        [self tuTuConfig];
    }
    return self;
}

#pragma mark - private method

- (void)tuTuConfig {
    self.room_gift_package_tip = @"背包暂无内容~";//背包空的提示文案
    self.room_gift_arrow_image = @"room_gift_arrow";//选择礼物数量箭头图片名
    self.room_gift_sendGift_tip = @"赠送";//送礼物文案
    self.room_gift_sendMsg_default = @"熬过异地，就是一生";//喊话默认文案
    
    self.selectedCountLabelColor = [UIColor whiteColor];
    self.coinLabelColor = [UIColor whiteColor];
    
    self.send_gift_new = @"send_gift_new";//礼物标签新
    self.send_gift_limit = @"send_gift_limit";//礼物标签限
    self.send_gift_effect = @"send_gift_effect";//礼物标签特
    self.sendGiftItemCellBorderColor = [XCTheme getTTMainColor];
}
@end
