//
//  CarrotGiftInfo.h
//  XCChatCoreKit
//
//  Created by lee on 2019/3/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarrotGiftInfo : BaseObject
/** 记录id */
@property(nonatomic, copy) NSString *recordId;
/** 描述，如“收礼人 */
@property(nonatomic, copy) NSString *describeStr;
/** 货币单位,如“萝卜” */
@property(nonatomic, copy) NSString *currencyStr;
/** 日期时间戳     */
@property(nonatomic, copy) NSString *date;
/** 记录时间戳     */
@property(nonatomic, copy) NSString *createTime;
/** 礼物图片     */
@property(nonatomic, copy) NSString *giftPicUrl;
/** 礼物名称     */
@property(nonatomic, copy) NSString *giftName;
/** 礼物数量     */
@property(nonatomic, assign) NSNumber *giftNum;
/** 礼物id     */
@property(nonatomic, copy) NSString *giftId;
/** 数量，如“-100”     */
@property(nonatomic, copy) NSString *amountStr;

@end

NS_ASSUME_NONNULL_END
