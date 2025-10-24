//
//  XCFamilyMoneyModel.h
//  BberryCore
//
//  Created by gzlx on 2018/6/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "XCFamilyModel.h"

typedef NS_ENUM(NSInteger, FamilyMoneyOwnerType){
    FamilyMoneyOwnerMe = 1,//我的家族币
    FamilyMoneyOwnerManager= 2,// 族长管理家族币
    FamilyMoneyOwnerGroup = 3,// 群统计
    FamilyMoneyOwnerMoney = 4,//族长的家族币
};

@interface XCFamilyMoneyModel : BaseObject

@property (nonatomic, strong) NSString * month;
@property (nonatomic, assign) double  income;
@property (nonatomic, assign) double   cost;
@property (nonatomic, strong) NSString * moneyName;
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * list;
@end

