//
//  LittleWorldCore.m
//  XCChatCoreKit
//
//  Created by lvjunhang on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "LittleWorldWoreToastClient.h"
#import "HttpRequestHelper+LittleWorld.h"
#import "AuthCore.h"
#import "ImMessageCore.h"
#import "NotificationCoreClient.h"
#import "Attachment.h"
#import "XCLittleWorldAttachment.h"
#import "ImMessageCoreClient.h"
#import "MessageBussiness.h"
#import <YYCache/YYCache.h>
#import "HttpRequestHelper+DynamicComment.h"

@interface LittleWorldCore ()<NotificationCoreClient>

/**
 小世界分类存储
 */
@property (nonatomic, strong) NSArray<LittleWorldCategory *> *worldCategoryArray;

@end

@implementation LittleWorldCore

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)init {
    if (self = [super init]) {
        AddCoreClient(NotificationCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
        
        self.littleDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)saveLittleDict {
    [[NSUserDefaults standardUserDefaults] setObject:self.littleDict forKey:@"littleDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)receiveDictWithKey:(NSString *)keyString {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"littleDict"];
    
    if (dict) {
        self.littleDict = [dict mutableCopy];
        
        return [self.littleDict objectForKey:keyString];
        
    } else {
        return nil;
    }
}

- (void)removeDictWithKey:(NSString *)keyString {
    self.littleDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"littleDict"] mutableCopy];
    
    [self.littleDict removeObjectForKey:keyString];
    
    [self saveLittleDict];
}

/**
 小世界首页（世界广场）
 */
- (void)requestWorldSquare {
    [HttpRequestHelper requestWorldSquareWithCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        LittleWorldSquare *response = [LittleWorldSquare yy_modelWithJSON:data];
        if (![response isKindOfClass:[LittleWorldSquare class]]) {
            response = nil;
        }
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldSquare:code:msg:), responseWorldSquare:response code:code msg:msg);
    }];
}

/**
 小世界首页全部分类列表，包含’我加入的‘和’推荐‘
 */
- (void)requestWorldFullCategoryList {
    
    [HttpRequestHelper requestWorldFullCategoryListOnCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[LittleWorldCategory class] json:data];
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldFullCategoryList:code:msg:), responseWorldFullCategoryList:list code:code msg:msg);
    }];
}

/**
 小世界分类列表（协议返回数据）
 */
- (void)requestWorldCategoryList {
    
    [self fetchWorldCategoryListWithRefresh:YES completion:^(NSArray<LittleWorldCategory *> * _Nonnull data, NSNumber * _Nonnull errorCode, NSString * _Nonnull msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldCategoryList:code:msg:), responseWorldCategoryList:data code:errorCode msg:msg);
    }];
}

/**
 小世界分类列表（block返回数据）
 
 @param isRefresh 是否刷新，如果不刷新，优先获取内存缓存，无缓存则请求获取
 @param completion 数据回调，若 data 为空，可尝试从 errorCode/msg 获取错误信息
 */
- (void)fetchWorldCategoryListWithRefresh:(BOOL)isRefresh completion:(void(^)(NSArray<LittleWorldCategory *> *data, NSNumber *errorCode, NSString *msg))completion {
    
    //缓存获取
    if (!isRefresh && self.worldCategoryArray.count > 0) {
        !completion ?: completion(self.worldCategoryArray, nil, nil);
        return;
    }
    
    //请求获取
    [HttpRequestHelper requestWorldCategoryListOnCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[LittleWorldCategory class] json:data];
        if ([list count] > 0) {
            self.worldCategoryArray = list;
        } else {
            list = nil;
        }
        
        !completion ?: completion(list, code, msg);
    }];
}

/**
 小世界列表
 
 @param page 查询页数，从 1 开始
 @param pageSize 每页数量
 @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
 @param worldTypeId 小世界类型，-1：我加入的，-2：推荐，其他
 */
- (void)requestWorldListWithPage:(NSInteger)page
                        pageSize:(NSInteger)pageSize
                       searchKey:(nullable NSString *)searchKey
                     worldTypeId:(nullable NSString *)worldTypeId {
    
    [HttpRequestHelper requestWorldListWithPage:page pageSize:pageSize searchKey:searchKey worldTypeId:worldTypeId completion:^(id data, NSNumber *code, NSString *msg) {
        
        LittleWorldListModel *response = [LittleWorldListModel yy_modelWithJSON:data];
        if (![response isKindOfClass:[LittleWorldListModel class]]) {
            response = nil;
        }
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldList:typeId:code:msg:), responseWorldList:response typeId:worldTypeId code:code msg:msg);
    }];
}

/**
 获取世界分享图片
 */
- (void)requestWorldSharePicWithWorldId:(NSString *)worldId {
    
    [HttpRequestHelper requestWorldSharePicWithWorldId:worldId completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldSharePic:code:msg:), responseWorldSharePic:data code:code msg:msg);
    }];
}

//@fuyuan

/**
 小世界详情页
 
 @param worldId 小世界 id
 */
- (void)requestWorldLetDetailDataWithUid:(NSString *)worldId uid:(UserID)uid {
    [HttpRequestHelper requestWorldLetDetailDataWithUid:worldId uid:(UserID)uid success:^(LittleWorldListItem * _Nonnull model) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldletGuestPage:), responseWorldletGuestPage:model);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldletGuestPageFail:resCode:), responseWorldletGuestPageFail:message resCode:resCode);
    }];
}

/**
 小世界详情页(block回调）
 
 @param worldId 小世界 id
 @param uid 用户uid
 @param completion 完成回调
 */
- (void)requestWorldDetailWithWorldId:(NSString *)worldId uid:(UserID)uid                              completion:(void(^)(LittleWorldListItem *data, NSNumber *errorCode, NSString *msg))completion {
    
    [HttpRequestHelper requestWorldLetDetailDataWithUid:worldId uid:(UserID)uid success:^(LittleWorldListItem * _Nonnull model) {
        !completion ?: completion(model, nil, nil);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        !completion ?: completion(nil, resCode, message);
    }];
}

/**
 加入小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
- (RACSignal *)requestJoinWorldLetWithUid:(NSString *)worldId uid:(UserID)uid isFromRoom:(BOOL)isFromRoom {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestJoinWorldLetWithUid:worldId uid:uid isFromRoom:isFromRoom success:^(BOOL success) {
            NotifyCoreClient(LittleWorldWoreToastClient, @selector(memberEnterlittleWorldSuccessWithWorldId:isFromRoom:), memberEnterlittleWorldSuccessWithWorldId:worldId.userIDValue isFromRoom:isFromRoom);
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 退出小世界
 
 @param worldId 小世界 id
 @param uid 当前用户uid
 */
- (RACSignal *)requestExitWorldLetWithUid:(NSString *)worldId uid:(UserID)uid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestExitWorldLetWithUid:worldId uid:uid success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 解散小世界
 
 @param worldId 小世界 id
 @param uid 创建者uid
 */
- (RACSignal *)requestDismissWorldLetWithUid:(NSString *)worldId uid:(UserID)uid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestDismissWorldLetWithUid:worldId uid:uid success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 编辑小世界
 
 @param worldId 小世界ID
 @param uid 创建者ID
 @param name 小世界名称
 @param icon 小世界图片
 @param description 小世界描述
 @param notice 小世界公告
 @param worldTypeId 小世界类型ID
 @param agreeFlag 加入小世界是否有限制
 */
- (RACSignal *)requestWorldLetEditDataWithWorld:(NSString *)worldId uid:(UserID)uid name:(NSString *)name icon:(NSString *)icon description:(NSString *)description notice:(NSString *)notice worldTypeId:(NSString *)worldTypeId agreeFlag:(BOOL)agreeFlag {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestWorldLetEditDataWithWorld:worldId uid:uid name:name icon:icon description:description notice:notice worldTypeId:worldTypeId agreeFlag:agreeFlag success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 小世界消息免打扰
 
 @param chatId 群聊ID
 @param uid uid
 @param ope true=开启、false=关闭
 */
- (RACSignal *)requestWorldLetChatMuteWithChatId:(UserID)chatId uid:(UserID)uid ope:(BOOL)ope {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestWorldLetChatMuteWithChatId:chatId uid:uid ope:ope success:^(BOOL success) {
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 关闭普通房的派对模式
 
 @param roomUid 房主uid
 */
- (void)requestWorldLetCloseGroupChatWithRoomUid:(UserID)roomUid {
    [HttpRequestHelper requestWorldLetCloseGroupChatWithRoomUid:roomUid success:^(BOOL success) {
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
    }];
}

/**
 查询当前用户是否在世界内
 
 @param worldId 世界ID
 @param uid uid
 */
- (RACSignal *)requestUserInWorldletWithWorldId:(UserID)worldId uid:(UserID)uid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestUserInWorldletWithWorldId:worldId uid:uid success:^(TTWorldletRoomModel *model) {
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [[NSError alloc]initWithDomain:message code:[resCode integerValue] userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//start @fegnshuo
/**
 请求小世界成员列表
 
 @param worldId 世界的id
 @param searchKey 搜索的关键字
 @param isSearch 是不是通过搜索
 @param status 是头部刷新还是尾部 刷新
 @param page 当前的页数
 */
- (void)requestLittleWorldMemberListWithWorldId:(UserID)worldId
                               searchKey:(NSString * __nullable)searchKey
                                isSearch:(BOOL)isSearch
                                    page:(int)page
                                  status:(int)status {
    [HttpRequestHelper requsetLittleWorldMemberListWithWorldId:worldId searchKey:searchKey page:page success:^(LittleWorldMemberModel * model) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestLittleWorldMemberListSuccess:isSearch:status:), requestLittleWorldMemberListSuccess:model isSearch:isSearch status:status);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestLittleWorldMemberListFail:status:), requestLittleWorldMemberListFail:message status:status);
    }];
}

/**
 请求小世界随机话题
 */
- (void)requestLittleWorldTeamRandomTopic {
    [HttpRequestHelper requestLittleWorldTeamTopicListWithPageSize:20 success:^(NSArray<LittleWorldTeamModel *> * _Nonnull lists) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requsetLittleWorldTeamRandomTopicSucess:), requsetLittleWorldTeamRandomTopicSucess:lists);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requsetLittleWorldTeamRandomTopicFail:), requsetLittleWorldTeamRandomTopicFail:message);
    }];
}


/**
 更新
 
 @param name 群聊的名字
 @param topic 群聊的话题
 */
- (void)updteLittleWorldTeamNameOrTopicWithTeamName:(nullable NSString  *)name topic:(nullable NSString *)topic chatId:(UserID)chatId {
    UserID uid = GetCore(AuthCore).getUid.userIDValue;
    [HttpRequestHelper updateLittleWorldTeamTopicWithChatId:chatId name:name topic:topic uid:uid success:^(BOOL success) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(updateLittleWorldTeamNameOrTopicSuccess), updateLittleWorldTeamNameOrTopicSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(updateLittleWorldTeamNameOrTopicFail:), updateLittleWorldTeamNameOrTopicFail:message);
    }];
}


/**
 请求小世界群聊的详情
 
 @param tId 群聊的id
 */
- (void)requsetLittleWorldTeamDetailWithTid:(UserID)tId {
    [HttpRequestHelper requestLittleWorldTeamDetailWithChatId:tId uid:GetCore(AuthCore).getUid.userIDValue success:^(LittleWorldTeamModel * _Nonnull teamModel) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requsetLittleWorldTeamDetailSuccess:), requsetLittleWorldTeamDetailSuccess:teamModel);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requsetLittleWorldTeamDetailFail:), requsetLittleWorldTeamDetailFail:message);
    }];
}


/**
 创建群聊派对

 @param worldId 世界的id
 @param tid 云信群聊的id
 */
- (void)createLittleWorldTeamPartyWithWorldId:(UserID)worldId tid:(NSString *)tid ownerFlag:(BOOL)ownerFlag {
    [HttpRequestHelper creatLittleWorldTeamPartyWithWorldId:worldId roomUid:GetCore(AuthCore).getUid.userIDValue success:^(NSString * warn) {
        [self sendLittleWorldCustomMessageWithTid:tid worldId:worldId roomUid:GetCore(AuthCore).getUid.userIDValue ownerFlag:ownerFlag];
        NotifyCoreClient(LittleWorldCoreClient, @selector(creatLittleWorldTeamPartySuccess:), creatLittleWorldTeamPartySuccess:warn);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(creatLittleWorldTeamPartyFail:), creatLittleWorldTeamPartyFail:message);
    }];
}


/**
 获取小世界派对列表
 
 @param worldId 世界的id
 @param page 当前的页数
 @param pageSize 每页的个数
 */
- (void)requestLittleWorldTeamPartyListWithWorldId:(UserID)worldId page:(int)page pageSize:(int)pageSize status:(int)status{
    [HttpRequestHelper requsetLittleWorldTeamPartyListWithWorldId:worldId page:page pageSize:pageSize success:^(TTLittleWorldPartyListModel * listModel) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestLittleWorldTeamPartySuccess:status:), requestLittleWorldTeamPartySuccess:listModel status:status);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestLittleWorldTeamPartyFail:status:), requestLittleWorldTeamPartyFail:message status:status);
    }];
}


/**
 移除小世界成员

 @param worldId 世界的id
 @param removerId 移出的人的id
 */
- (void)removeLittleWorldMemberWithWorldId:(UserID)worldId removerUid:(UserID)removerId {
    [HttpRequestHelper littleWorldRemoveMemberWithWorld:worldId managerUid:GetCore(AuthCore).getUid.userIDValue removerId:removerId success:^(BOOL isSuccess) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(removeLittleWorldMemberSuccess:), removeLittleWorldMemberSuccess:removerId);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(removeLittleWorldMemberFail:), removeLittleWorldMemberFail:message);
    }];
}

- (void)onRecvCustomTeamNoti:(NIMCustomSystemNotification *)notification {
    Attachment *attachment = [Attachment yy_modelWithJSON:notification.content];
    if (attachment.first == Custom_Noti_Header_Game_LittleWorld) {
        if (attachment.second == Custom_Noti_Sub_Little_World_Group_Topic || attachment.second == Custom_Noti_Sub_Little_World_Member_Count) {
            XCLittleWorldAttachment * littleWorldAttach = [XCLittleWorldAttachment yy_modelWithJSON:attachment.data];
            NotifyCoreClient(LittleWorldCoreClient, @selector(onReceiveTeamNotificationUpdateTopicOrNumbePersonWithAttach:second:), onReceiveTeamNotificationUpdateTopicOrNumbePersonWithAttach:littleWorldAttach second:attachment.second);
        }
    }
}

- (void)sendLittleWorldCustomMessageWithTid:(NSString *)tid worldId:(UserID)worldId roomUid:(UserID)roomUid ownerFlag:(BOOL)ownerFlag{
    XCLittleWorldAttachment * littleWorldAtt = [[XCLittleWorldAttachment alloc] init];
    littleWorldAtt.first =  Custom_Noti_Header_Game_LittleWorld;
    littleWorldAtt.second = Custom_Noti_Sub_Little_World_Room_Notify;
    NSDictionary * data = @{@"roomUid":@(roomUid), @"worldId":@(worldId), @"ownerFlag":@(ownerFlag)};
    littleWorldAtt.data = data;
    [GetCore(ImMessageCore) sendCustomMessageAttachement:littleWorldAtt sessionId:tid type:NIMSessionTypeTeam];
}

#pragma mark - IMmessageCoreClient
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeP2P) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[MessageBussiness class]]) {
            MessageBussiness *attachment = (MessageBussiness *)customObject.attachment;
            if (attachment.params.actionType > 0){
                NSInteger actionType = attachment.params.actionType;
                if (actionType == FamilyNotificationType_Inter) {
                   NotifyCoreClient(LittleWorldWoreToastClient, @selector(smallSecretaryJoinWorldletSuccessWithWorldId:isFromRoom:), smallSecretaryJoinWorldletSuccessWithWorldId:attachment.params.worldId.userIDValue isFromRoom:YES);
                }
            }
        }
    }
}

    
    
//end @fengshuo

/// 小世界成员活跃上报
/// @auth fulong
/// @param worldId 小世界id
/// @param uid 用户uid
/// @param activeType 在小世界群聊中活跃类型 活跃类型，1-消息，2-送礼物，3-创建语音派对，4-加入语音派对
- (void)reportWorldMemberoActiveType:(int)activeType reportUid:(UserID)uid worldId:(UserID)worldId {

    YYCache *cache = [YYCache cacheWithName:@"kWorldMemberActiveCache"];
    BOOL isSameDay = [[NSCalendar currentCalendar] isDateInToday:(NSDate *)[cache objectForKey:@"kWorldMemberActiveKey"]];
    
    NSArray *array = (NSArray *)[cache objectForKey:@"kWorldIDKey"];
    
    if (isSameDay && [array containsObject:@(worldId)]) {
        return; // 同一天同一个小世界不需要重复统计
    }

    if (worldId == 0) {
        // 没有小世界不需要传递
        return;
    }
    
     [HttpRequestHelper reportWorldMemberoActiveType:activeType reportUid:uid worldId:worldId completionHandler:^(id data, NSNumber *code, NSString *msg) {
          
         // 先从缓存中读取已存储的用户数据列表
         NSArray *array = (NSArray *)[cache objectForKey:@"kWorldIDKey"];
         
         // 将当前用户添加进去
         NSMutableArray *worldIDArrays = [NSMutableArray arrayWithArray:array];
         [worldIDArrays addObject:@(worldId)];
         
         // 去重
         NSSet *set = [NSSet setWithArray:worldIDArrays.mutableCopy];
         
         // 仅仅是发送到服务器，不需要做成功 or 失败的处理
         [cache setObject:[NSDate date] forKey:@"kWorldMemberActiveKey"];
         [cache setObject:set.allObjects forKey:@"kWorldIDKey"];
    }];
}

/**
 小世界列表
 
 @param worldId 世界id
  @param page 查询页数，从 1 开始
  @param pageSize 每页数量
  @param searchKey 小世界查询关键字，用户耳伴号或小世界名称，支持模糊搜索
  */
- (void)requestWorldGroupListWithWorldId:(NSString *)worldId
                                    page:(NSInteger)page
                                pageSize:(NSInteger)pageSize
                               searchKey:(nullable NSString *)searchKey {
    
    [HttpRequestHelper requestWorldGroupListWithWorldId:worldId page:page pageSize:pageSize searchKey:searchKey completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldGroupList:code:msg:), responseWorldGroupList:data code:code msg:msg);
    }];
}

/**
 加入小世界群聊
 
 @param worldId 小世界id
 */
- (void)requestWorldGroupJoinWithWorldId:(NSString *)worldId {
    
    [HttpRequestHelper requestWorldGroupJoinWithWorldId:worldId completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldGroupJoinSuccess:code:msg:), responseWorldGroupJoinSuccess:code==nil code:code msg:msg);
    }];
}

/**
退出小世界群聊，两个id二选一

@param chatId 小世界群聊id
@param sessionId 云信id
*/
- (void)requestWorldGroupQuitWithChatId:(NSString *)chatId sessionId:(NSString *)sessionId {
    
    [HttpRequestHelper requestWorldGroupQuitWithChatId:chatId sessionId:sessionId completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldGroupQuitSuccess:code:msg:), responseWorldGroupQuitSuccess:code==nil code:code msg:msg);
    }];
}

/**
 踢出小世界群聊

 @param toUid 被踢用户id
 */
- (void)requestWorldGroupKickWithUid:(NSString *)toUid {
    [HttpRequestHelper requestWorldGroupKickWithUid:toUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldGroupKickSuccess:code:msg:), responseWorldGroupKickSuccess:code==nil code:code msg:msg);
    }];
}

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
- (void)requestWorldPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList {
    
    [self requestWorldPostDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:nil];
}

/// 发布动态
/// @param worldId 小世界id
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
- (void)requestWorldPostDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder {
    [HttpRequestHelper requestPostDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:workOrder completionHandler:^(id data, NSNumber *code, NSString *msg) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldPostDynamicSuccess:code:msg:), responseWorldPostDynamicSuccess:data code:code msg:msg);
    }];
}

/// 发布动态(广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
- (void)requestWorldPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList {
    
    [self requestWorldPostSquareDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:nil];
}

/// 发布动态(广场）
/// @param worldId 小世界id（可为空）
/// @param type 发布动态的类型 动态类型，0-纯文本，1-声音，2-图文，3-视频
/// @param content 动态文本内容
/// @param resList 图片资源列表
/// @param workOrder 认证主播的派单
- (void)requestWorldPostSquareDynamicWithWorldID:(NSString *)worldId type:(int)type content:(NSString *)content resList:(NSArray *)resList workOrder:(AnchorOrderInfo *_Nullable)workOrder {
    [HttpRequestHelper requestPostSquareDynamicWithWorldID:worldId type:type content:content resList:resList workOrder:workOrder completionHandler:^(id data, NSNumber *code, NSString *msg) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldPostDynamicSuccess:code:msg:), responseWorldPostDynamicSuccess:data code:code msg:msg);
    }];
}

/**

 用户动态列表（我的主客态页）
 @param uid 查看对象的uid
 @param types 类型 0：纯文本，1:语音，2图片，3视频(为空标识所有,多种用逗号隔开)
 */
- (void)requestUserMomentListForUid:(NSString *)uid types:(NSString *)types page:(NSInteger)page pageSize:(NSInteger)pageSize {
    
    [HttpRequestHelper requestUserMomentListForUid:uid types:types page:page pageSize:pageSize completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[UserMoment class] json:data];

        NotifyCoreClient(LittleWorldCoreClient, @selector(responseUserMomentList:uid:code:msg:), responseUserMomentList:list uid:uid code:code msg:msg);
    }];
}

/**
 @param dynamicId 动态id
 @param worldId uid
 */
- (void)requestDynamicDeleteWitDynamicId:(long)dynamicId worldId:(NSString *)worldId {
    [HttpRequestHelper requestDynamicDeleteWitDynamicId:dynamicId worldId:worldId Success:^{
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicDeleteSuccess), requestDynamicDeleteSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicDeleteFailth:), requestDynamicDeleteFailth:message);
    }];
}

- (void)requestDynamicListWithWorldID:(NSString *)worldID pageNum:(NSInteger)pageNum dynamicId:(NSInteger)dynamicId {
    [HttpRequestHelper requestDynamicListWithWorldID:worldID dynamicId:dynamicId Success:^(NSArray<LLDynamicModel *> * _Nonnull dynamicModelList, NSString * _Nonnull nextDynamicId) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicListSuccess:nextDynamicId:), requestDynamicListSuccess:dynamicModelList nextDynamicId:nextDynamicId);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicListFailth:), requestDynamicListFailth:message);
    }];
}

/**
 点赞/取消点赞
 
 @param dynamicId 动态id
 @param worldId 小世界id
 @param isLike true 点赞 false 取消 状态,0-取消赞,1-赞
 @param dynamicUid 动态发布者的uid
 */
- (void)requestDynamicLikeWitDynamicId:(NSInteger)dynamicId
                               worldId:(NSString *)worldId
                               isLike:(BOOL)isLike
                            dynamicUid:(NSString *)dynamicUid {
//    if (isLike)  [[LTCommunityLikeAnimation shareInstance] showGiveLikeAnimation];//点赞动画
    [HttpRequestHelper requestDynamicLikeWitWitDynamicId:dynamicId worldId:worldId isLike:isLike dynamicUid:dynamicUid Success:^{
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicLikeSuccess), requestDynamicLikeSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicLikeFailth:dynamicId:), requestDynamicLikeFailth:message dynamicId:dynamicId);
    }];
}

/**
 点赞/取消点赞（block)
 
 @param dynamicId 动态id
 @param worldId 小世界id
 @param isLike true 点赞 false 取消 状态,0-取消赞,1-赞
 @param dynamicUid 动态发布者的uid
 */
- (void)requestDynamicLikeWitDynamicId:(NSInteger)dynamicId
                               worldId:(NSString *)worldId
                                isLike:(BOOL)isLike
                            dynamicUid:(NSString *)dynamicUid
                            completion:(void(^)(BOOL success, NSString *errorMsg))completion {
    
    [HttpRequestHelper requestDynamicLikeWitWitDynamicId:dynamicId worldId:worldId isLike:isLike dynamicUid:dynamicUid Success:^{
        !completion ?: completion(YES, nil);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        !completion ?: completion(NO, message);
    }];
}
/**
 请求动态详情

 @param dynamicId 动态id
 @param worldID 小世界id
 */
- (void)requestDynamicDetailsWitDynamicId:(NSString *)dynamicId worldID:(NSString *)worldID {
    [HttpRequestHelper requestDynamicDetailsWitDynamicId:dynamicId worldID:worldID Success:^(LLDynamicModel
    *dynamicModel) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicDetailsSuccess:), requestDynamicDetailsSuccess:dynamicModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicDetailsFailth:errorMessage:), requestDynamicDetailsFailth:resCode errorMessage:message);
    }];
}

/**
 请求评论列表

 @param worldID 所在小世界id
 @param dynamicId 动态id
 @param pageNum 页数
 @param timestamp 上一个评论list里的最后时间戳
 */
- (void)requestCommentListWithWorldID:(NSString *)worldID
                            dynamicId:(NSString *)dynamicId
                              pageNum:(NSInteger)pageNum
                            timestamp:(long)timestamp {
    [HttpRequestHelper requestCommentListWithWorldID:worldID dynamicId:dynamicId pageNum:pageNum timestamp:timestamp Success:^(NSArray<CTCommentReplyModel *> * _Nonnull commentList, long timeStamp) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestCommentListSuccess:timeStamp:), requestCommentListSuccess:commentList timeStamp:timeStamp);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestCommentListFailth:), requestCommentListFailth:message);
    }];
}

/**
 评论接口
 @param dynamicId 动态id
 @param content 评论内容
 */
- (void)requestAddCommentWithDynamicId:(NSInteger)dynamicId content:(NSString *)content {
    [HttpRequestHelper requestAddCommentWithDynamicId:dynamicId content:content Success:^(CTCommentReplyModel * _Nonnull commentModel) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestAddCommentSuccess:), requestAddCommentSuccess:commentModel);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestAddCommentFailth:), requestAddCommentFailth:message);
    }];
}

/**
 回复评论接口
 @param dynamicId 动态id
 @param content 评论内容
 @param commentId 评论id

 */
- (RACSignal *)requestReplyCommentWithDynamicId:(NSInteger)dynamicId
                                 content:(NSString *)content
                               commentId:(NSInteger )commentId {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper requestReplyCommentWitDynamicId:dynamicId content:content commentId:commentId Success:^(CTReplyModel * _Nonnull replyModel) {
            [subscriber sendNext:[replyModel model2dictionary]];
            [subscriber sendCompleted];
//            NotifyCoreClient(LittleWorldCoreClient, @selector(requestReplyCommentSuccess:), requestReplyCommentSuccess:replyModel);
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            NSError *error = [NSError errorWithDomain:message code:resCode.integerValue userInfo:nil];
            [subscriber sendError:error];
//            NotifyCoreClient(LittleWorldCoreClient, @selector(requestReplyCommentFailth:), requestReplyCommentFailth:message);
        }];
        return nil;
    }];
}

/**
 查询嗨玩派对房间（语音派对）
 */
- (void)requestWorldPartyRoomListWithWorldId:(NSString *)worldId {
    
    [HttpRequestHelper requestWorldPartyRoomListWithWorldId:worldId completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[LittleWorldPartyRoom class] json:data];
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldPartyRoomList:code:msg:), responseWorldPartyRoomList:list code:code msg:msg);
    }];
}

/// 删除评论 or 评论回复
/// @param commnetID 评论/回复id (commentId或replyId)
/// @param deleteType 删除类型 0 = 评论， 1 = 回复
- (RACSignal *)requestDynamicDeleteCommentWithCommentID:(NSString *)commnetID deleteType:(NSInteger)deleteType {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequestHelper requestDynamicDeleteCommentWithCommentID:commnetID Success:^(CTReplyModel * _Nonnull replyModel) {
            [subscriber sendNext:[replyModel model2dictionary]];
            [subscriber sendCompleted];
            //            NotifyCoreClient(LittleWorldCoreClient, @selector(requestDeleteCommentSuccessWithCommentId:type:), requestDeleteCommentSuccessWithCommentId:replyModel.replyId type:deleteType);
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            //            NotifyCoreClient(LittleWorldCoreClient, @selector(requestDeleteCommentFailth:type:), requestDeleteCommentFailth:message type:deleteType);
            NSError *error = [NSError errorWithDomain:message code:resCode.integerValue userInfo:nil];
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/// 获取评论回复列表
/// @param dynamicID 当前动态的动态id
/// @param commentID 动态的当前评论id
/// @param timestamp 上一条回复的时间戳
- (void)requestDynamicCommentReplyListWithDynamicID:(NSInteger)dynamicID commentID:(NSString *)commentID timestamp:(NSString *)timestamp {
    [HttpRequestHelper requestDynamicCommentReplyListWithDynamicID:dynamicID commentID:commentID timestamp:timestamp Success:^(CTReplyInfoModel * _Nonnull replyInfoModel) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestCommentReplyListSuccess:), requestCommentReplyListSuccess:replyInfoModel);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestCommentReplyListFailth:), requestCommentReplyListFailth:message);
    }];
}

/// 分享动态
/// @param worldId 所在的小世界id
/// @param dynamicID 动态id
/// @param uid 被分享人的 uid
- (void)requestWorldShareDynamicWithWorldId:(NSString *)worldId dynamicID:(NSInteger)dynamicID uid:(NSString *)uid {
    [HttpRequestHelper requestWorldShareDynamicWithWorldId:worldId dynamicID:dynamicID uid:uid Success:^(CTReplyInfoModel * _Nonnull replyInfoModel) {
        
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
    }];
}

#pragma mark -
#pragma mark 1.3.2

/// 动态广场推荐的动态
- (void)requestDynamicSquareRecommendDynamicsWithPage:(NSInteger)page {
    [HttpRequestHelper requestDynamicSquareRecommendDynamicsWithPage:page Success:^(NSArray<LLDynamicModel *> * _Nonnull dynamicModelList) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicSquareRecommendListSuccess:), requestDynamicSquareRecommendListSuccess:dynamicModelList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicListFailth:), requestDynamicListFailth:message);
    }];
}
/// 动态广场关注的动态
- (void)requestDynamicSquareFollowerDynamicsWithDynamicId:(NSString *)dynamicId {
    [HttpRequestHelper requestDynamicSquareFollowerDynamicsWithDynamicId:dynamicId Success:^(NSArray<LLDynamicModel *> * _Nonnull dynamicModelList, NSString * _Nonnull nextDynamicId) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicSquareFollowListSuccess:nextDynamicId:), requestDynamicSquareFollowListSuccess:dynamicModelList nextDynamicId:nextDynamicId);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(LittleWorldCoreClient, @selector(requestDynamicListFailth:), requestDynamicListFailth:message);
    }];
}

/// 动态发布里的世界列表
/// @param type 请求世界类型
/// @param page 分页，默认1
- (void)requestWorldDynamicPostWorldListWithType:(DynamicPostWorldRequestType)type page:(NSInteger)page {
    [HttpRequestHelper requestWorldDynamicPostWorldListWithType:type page:page completion:^(id data, NSNumber *code, NSString *msg) {
        
        NSArray *list = [NSArray yy_modelArrayWithClass:[LittleWorldDynamicPostWorld class] json:data];
        NotifyCoreClient(LittleWorldCoreClient, @selector(responseWorldDynamicPostWorldList:type:code:msg:), responseWorldDynamicPostWorldList:list type:type code:code msg:msg);
    }];
}

/// 获取主播订单状态（获取用户最新的动态派单）
/// @param targetUid 对方uid
- (void)requestAnchorOrderStatusWithUid:(NSString *)targetUid
                           completion:(void(^)(AnchorOrderStatus *data, NSNumber *errorCode, NSString *msg))completion {
    
    [HttpRequestHelper requestAnchorOrderStatusWithUid:targetUid completion:^(id data, NSNumber *code, NSString *msg) {
        
        AnchorOrderStatus *model = [AnchorOrderStatus modelWithJSON:data];
        !completion ?: completion(model, code, msg);
    }];
}

/// 获取动态派单的配置
- (void)requestAnchorOrderConfigWithCompletion:(void(^)(AnchorOrderConfig *data, NSNumber *errorCode, NSString *msg))completion {
    
    [HttpRequestHelper requestAnchorOrderConfigWithCompletion:^(id data, NSNumber *code, NSString *msg) {
        
        AnchorOrderConfig *model = [AnchorOrderConfig modelWithJSON:data];
        !completion ?: completion(model, code, msg);
    }];
}

@end
