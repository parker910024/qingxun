//
//  TTSendGiftViewConfig.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSendGiftViewConfig : NSObject
@property (nonatomic, copy) NSString *room_gift_package_tip;//背包空的提示文案
@property (nonatomic, copy) NSString *room_gift_arrow_image;//选择礼物数量箭头图片名
@property (nonatomic, copy) NSString *room_gift_sendGift_tip;//送礼物文案
@property (nonatomic, copy) NSString *room_gift_sendMsg_default;//喊话默认文案

@property (nonatomic, strong) UIColor *selectedCountLabelColor; //选择数量文字颜色
@property (nonatomic, strong) UIColor *coinLabelColor;//金币文字颜色


/*****XCSendGiftItemCell*******/
@property (nonatomic, copy) NSString *send_gift_new;//礼物标签新
@property (nonatomic, copy) NSString *send_gift_limit;//礼物标签限
@property (nonatomic, copy) NSString *send_gift_effect;//礼物标签特
@property (nonatomic, strong) UIColor *sendGiftItemCellBorderColor;//选中礼物的背景边框颜色

+ (TTSendGiftViewConfig *)globalConfig;
@end

NS_ASSUME_NONNULL_END
