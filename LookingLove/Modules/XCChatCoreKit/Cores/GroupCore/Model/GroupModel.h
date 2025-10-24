//
//  GroupModel.h
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "NSObject+YYModel.h"
#import "GroupMemberModel.h"

@interface GroupModel : BaseObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger tid;
@property (strong, nonatomic) NSString *name;
@property (nonatomic,assign) UserID uid;
@property (nonatomic,assign) NSInteger familyId;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *groupDescription;
@property (nonatomic,assign) NSInteger managerCount;
@property (nonatomic,assign) NSInteger disabledCount;
@property (nonatomic,assign) NSInteger memberCount;
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NSDate *updateTime;
@property (nonatomic,assign) double totalAmount;
@property (nonatomic,assign) BOOL isVerify;
@property (nonatomic,assign) BOOL isPromt;
@property (nonatomic,assign) GroupMemberRole role;
@property (nonatomic,assign) BOOL isDisplayAccount;
@end
