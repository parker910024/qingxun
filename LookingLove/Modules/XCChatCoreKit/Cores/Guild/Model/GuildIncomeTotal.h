//
//  GuildIncomeTotal.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/1/17.
//  Copyright © 2019 KevinWang. All rights reserved.
//  收入统计

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@class GuildIncomeTotalVos;

//total    总计    是    [string]    查看
//5     vos        是    [array]
//6     rowNum    序号    是    [string]    查看
//7     reciveUid    uid    是    [string]    查看
//8     totalGoldNum    个人总计    是    [string]    查看
//9     avatar    头像    是    [string]    查看
//10     nick    名称    是    [string]    查看
//11     erbanNo    耳伴号

@interface GuildIncomeTotal : BaseObject<YYModel>
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray<GuildIncomeTotalVos *> *vos;
@end

@interface GuildIncomeTotalVos: NSObject
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger totalGoldNum;
@property (nonatomic, copy) NSString *erbanNo;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger reciveUid;
@end

NS_ASSUME_NONNULL_END
