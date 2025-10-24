//
//  UserUpGradeInfo.h
//  BberryCore
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

typedef enum : NSUInteger {
    UserUpgradeViewTypeExperLevel, //用户等级
    UserUpgradeViewTypeCharmLevel, //魅力等级
} UserUpgradeViewType;

@interface UserUpGradeInfo : BaseObject
@property (nonatomic, copy) NSString *levelName;
//@property (nonatomic, copy) NSString *experLevelName;//用户等级
//@property (nonatomic, copy) NSString *charmLevelName;//魅力等级

@end
