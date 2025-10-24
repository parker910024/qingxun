//
//  GroupMember.h
//  BberryCore
//
//  Created by gzlx on 2018/7/19.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "GroupMemberModel.h"


@interface GroupMember : BaseObject

@property (nonatomic, strong) NSString * count;
@property (nonatomic, strong) NSMutableArray<GroupMemberModel *> * memberList;

@end
