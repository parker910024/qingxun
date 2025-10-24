//
//  GroupMemberModel.h
//  BberryCore
//
//  Created by 卫明何 on 2018/6/1.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "LevelInfo.h"

typedef enum : NSUInteger {
    GroupMemberRole_Owner   = 1,  //群主
    GroupMemberRole_Manager = 2,    //管理员
    GroupMemberRole_Normal  = 3     //普通成员
} GroupMemberRole;

@interface GroupMemberModel : BaseObject

/**
 成员id
 */
@property (nonatomic,assign) NSInteger id;

/**
 家族id
 */
@property (nonatomic,assign) NSInteger familyId;

/**
 群聊id
 */
@property (nonatomic,assign) NSInteger chatId;

/**
 云信群聊id
 */
@property (nonatomic,assign) NSInteger tid;

/**
 uid
 */
@property (nonatomic,assign) UserID uid;

/**
 群聊成员角色
 */
@property (nonatomic,assign) GroupMemberRole role;

/**
 是否消息提醒
 */
@property (nonatomic,assign) BOOL isPromt;

/**
 是否禁言
 */
@property (nonatomic,assign) BOOL isDisable;

/**
 加入时间
 */
@property (strong, nonatomic) NSDate *createTime;

/**
 成员耳伴号
 */
@property (strong, nonatomic) NSString *erbanNo;

/**
 成员头像
 */
@property (strong, nonatomic) NSString *avatar;

/**
 成员昵称
 */
@property (strong, nonatomic) NSString *nick;

//用户等级
@property(nonatomic, strong) LevelInfo *userLevelVo;
@property (nonatomic, assign) NSInteger gender;

@end
