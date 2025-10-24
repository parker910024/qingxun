//
//  PopularTicket.h
//  LookingLove
//
//  Created by lvjunhang on 2020/12/3.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  人气票

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopularTicket : BaseObject
@property (nonatomic, assign) BOOL needDialog;//是否需要弹框
@property (nonatomic, copy) NSString *giftId;
@property (nonatomic, copy) NSString *giftUrl;
@property (nonatomic, copy) NSString *giftNum;
@property (nonatomic, copy) NSString *skipLink;//跳转
@end

NS_ASSUME_NONNULL_END
