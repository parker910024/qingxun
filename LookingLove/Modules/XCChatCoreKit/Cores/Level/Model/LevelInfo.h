//
//  LevelInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/29.
//  Copyright © 2018年 chenran. All rights reserved.
//


#import "BaseObject.h"

@interface LevelInfo : BaseObject

typedef enum {
    AccountType_Common = 1, //1 普通。
    AccountType_Official = 2,//2 官方 。
    AccountType_Robot = 3 //3 机器人
}AccountType;


//experAmount        -- 用户当前经验值
//experUrl               -- 经验等级图片链接
//experLevelName  -- 经验等级名称
//experLevelGrp     -- 经验等级组名
//charmAmount       -- 用户当前魅力值
//charmUrl               -- 魅力等级图片链接
//charmLevelName  -- 魅力等级名称
//charmLevelGrp     -- 魅力等级组名
@property (nonatomic, copy) NSString *experLevelName;
@property (nonatomic, copy) NSString *experLevelGrp;
@property (nonatomic, copy) NSString *experUrl;

@property (nonatomic, copy) NSString *experLevelSeq;

@property (nonatomic, copy) NSString *charmLevelName;
@property (nonatomic, copy) NSString *charmLevelGrp;
@property (nonatomic, copy) NSString *charmUrl;

@property (nonatomic, copy) NSString *charmLevelSeq;
@property(nonatomic, assign) AccountType defUser; //账号类型

@end
