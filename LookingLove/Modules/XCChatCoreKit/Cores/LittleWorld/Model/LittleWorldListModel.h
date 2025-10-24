//
//  LittleWorldListModel.h
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  小世界列表模型

#import "BaseObject.h"

typedef enum : NSUInteger {
    TTWorldletCreater = 1,
    TTWorldletNormal = 2,
} TTWorldLetType;

NS_ASSUME_NONNULL_BEGIN

@class LittleWorldListItem;
@class LittleWorldListItemMember;

/**
 标签枚举，1-新，2-热，4-官方，8-派对中
 */
typedef NS_OPTIONS(NSUInteger, LittleWorldListItemTag) {
    LittleWorldListItemTagNew = 1 << 0,
    LittleWorldListItemTagHot = 1 << 1,
    LittleWorldListItemTagOfficial = 1 << 2,
    LittleWorldListItemTagOnParty = 1 << 3,
};

/**
 小世界列表的数据模型
 */
@interface LittleWorldListModel : BaseObject
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSArray<LittleWorldListItem *> *records;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) BOOL searchCount;
@end

/**
 小世界列表每个世界的数据模型
 */
@interface LittleWorldListItem : BaseObject

@property (nonatomic, copy) NSString *worldId;//convert from id
@property (nonatomic, copy) NSString *ownerUid;//创建人id
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *icon;//封面
@property (nonatomic, assign) NSInteger memberNum;//人数
@property (nonatomic, copy) NSString *desc;//描述 convert from description
@property (nonatomic, copy) NSString *notice;//公告
@property (nonatomic, copy) NSString *typePict;//分类图片
@property (nonatomic, assign) BOOL inWorld; // 是否加入了这个小世界
@property (nonatomic, copy) NSString *noticeUpdateTime; // 小世界公告更新时间
@property (nonatomic, assign) BOOL agreeFlag; // 加入小世界的条件 1：申请同意后 0：所有人可进
@property (nonatomic, copy) NSString *typeId; // 小世界分类id
@property (nonatomic, copy) NSString *typeName; // 小世界分类名
@property (nonatomic, copy) NSString *tid; // 小世界群聊 云信id
@property (nonatomic, assign) NSInteger chatId; // 小世界群聊ID
@property (nonatomic, copy) NSString *createGroupChatNum; // 创建群聊人数
@property (nonatomic, copy) NSString *groupChatName;//群聊名
@property (nonatomic, assign) BOOL inGroupChat; //当前用户是否在群聊中
@property (nonatomic, strong) LittleWorldListItemMember *currentMember; // 当前用户对象
/** 在线人数*/
@property (nonatomic, assign) int onlineNum;
//标签，可多值并存，1-新，2-热，4-官方，8-派对中
@property (nonatomic, assign) LittleWorldListItemTag tag;

@property (nonatomic, strong) NSArray<LittleWorldListItemMember *> *members;//部分成员

@end

/**
 成员对象
 */
@interface LittleWorldListItemMember : BaseObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger muteFlag;//禁言状态，0.不禁言 1.禁言
@property (nonatomic, assign) NSInteger promtFlag;//消息提醒状态，0.屏蔽消息 1.开启提醒
@property (nonatomic, assign) NSInteger status;//状态
@property (nonatomic, copy) NSString *ownerFlag; // 是否是创始人
@property (nonatomic, assign) NSInteger memberNo; // 该世界的第几位成员

@end

NS_ASSUME_NONNULL_END
