//
//  MessageParams.h
//  BberryCore
//
//  Created by gzlx on 2018/7/5.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "XCFamily.h"

@interface MessageParams : BaseObject
@property (nonatomic, strong) NSString * inviteId;
@property (nonatomic, assign) FamilyNotificationType actionType;
@property (nonatomic, strong) NSString * familyId;
@property (nonatomic, strong) NSString *targetUid;
@property (nonatomic, strong) NSString *worldId;
@property (nonatomic, strong) NSString *recordId;
@end
