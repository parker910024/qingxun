//
//  MentoringGiftModel.h
//  XCChatCoreKit
//
//  Created by gzlx on 2019/2/15.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MentoringGiftModel : BaseObject

/** 礼物的id*/
@property (nonatomic, assign) UserID giftId;
/** 礼物的名称*/
@property (nonatomic, copy) NSString * giftName;
/** 礼物的图片*/
@property (nonatomic, copy) NSString * picUrl;

@end

NS_ASSUME_NONNULL_END
