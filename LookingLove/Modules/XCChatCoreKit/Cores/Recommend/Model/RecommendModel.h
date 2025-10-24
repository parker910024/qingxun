//
//  RecommendModel.h
//  XCChatCoreKit
//
//  Created by zoey on 2019/1/2.
//  Copyright © 2019年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

typedef NS_ENUM(NSUInteger, RecommendState) {
    RecommendState_Unuse = 1,//未使用
    RecommendState_Using,    //使用中
    RecommendState_HadUse,   //已使用
    RecommendState_Timeout  //已过期
};

@interface RecommendModel : BaseObject

@property (strong , nonatomic) NSString *cardName;//推荐卡名称
@property (assign , nonatomic) int count;//推荐卡数量
@property (strong , nonatomic) NSString *validStartTime;//有效开始日期
@property (strong , nonatomic) NSString *validEndTime;//有效结束日期
@property (strong , nonatomic) NSString *useStartTime;//使用开始时间
@property (strong , nonatomic) NSString *useEndTime;//使用结束时间
@property (assign , nonatomic) RecommendState status;//状态值(1、未使用 2、使用中 3、已使用 4、已过期)
@property (assign , nonatomic) int days;//有效期

- (NSString *)getValidStartTime;
- (NSString *)getValidEndTime;

- (NSString *)getUseStartTime;
- (NSString *)getUseEndTime;
@end
