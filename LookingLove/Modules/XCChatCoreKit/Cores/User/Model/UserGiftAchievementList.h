//
//  UserGiftAchievementList.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2020/2/24.
//  Copyright © 2020 YiZhuan. All rights reserved.
//  用户礼物成就列表（二维

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class UserGiftAchievementItem;

@interface UserGiftAchievementList: BaseObject
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *backgroundUrl;
@property (nonatomic, assign) NSInteger attainNum;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, strong) NSArray<UserGiftAchievementItem *> *giftList;
@end

@interface UserGiftAchievementItem: NSObject
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *giftName;
@property (nonatomic, assign) NSInteger achId;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, assign) NSInteger goldPrice;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger giftSum;
@property (nonatomic, assign) NSInteger createTime;
@end

NS_ASSUME_NONNULL_END
