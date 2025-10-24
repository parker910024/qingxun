//
//  UserRankingInfo.h
//  BberryCore
//
//  Created by Macx on 2018/5/22.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"

@interface UserRankingInfo : BaseObject

@property (nonatomic, strong) NSArray<UserInfo *>  *dayRankings;//日榜
@property (nonatomic, strong) NSArray<UserInfo *>  *weekRankings;//周榜
@property (nonatomic, strong) NSArray<UserInfo *>  *totalRankings;//总榜

@end
