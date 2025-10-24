//
//  FamilyCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "HttpRequestHelper+Family.h"
#import "ImMessageCoreClient.h"
#import "ImMessageCore.h"
#import "NSObject+YYModel.h"
#import "AttributedStringDataModel.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "P2PInteractiveAttachment.h"
#import "MessageBussiness.h"
#import "UserCoreClient.h"
@interface FamilyCore()
<
    ImMessageCoreClient
>

@property (strong, nonatomic) NSCache *contentAttrCache;
@property (strong, nonatomic) XCFamily * model;
@end

@implementation FamilyCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(ImMessageCoreClient, self);
        [self requestService];
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)requestService
{
    [self familyGuideAndService];
}

- (AttributedStringDataModel *)queryAttrByMessageId:(NSString *)messageId {
    return [self.contentAttrCache objectForKey:messageId];
}

- (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void (^)(XCFamily *))success {
    
    [self requestFamilyInfoByFamilyId:familyId success:success failure:nil];
}

- (void)requestFamilyInfoByFamilyId:(NSString *)familyId
                            success:(void (^)(XCFamily *))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    if (familyId == nil || familyId.length == 0) {
        if (failure) {
           failure(nil, @"家族ID获取错误");
        }
        return;
    }
    
    [HttpRequestHelper requestFamilyInfoByFamilyId:familyId success:^(XCFamily *familyInfo) {
        
        self.model.familyName = familyInfo.familyName;
        self.model.familyId = familyInfo.familyId;
        self.model.moneyName = familyInfo.moneyName;
        self.model.familyIcon = familyInfo.familyIcon;
        self.model.openMoney = familyInfo.openMoney;
        self.model.openGame = familyInfo.openGame;
        
        if (success) {
            success(familyInfo);
        }
        
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

- (void)saveAttributedString:(NSMutableAttributedString *)attributedString
               WithMessageId:(NSString *)messageId
                  isComplete:(BOOL)isComplete {
    
    AttributedStringDataModel *dataModel = [self.contentAttrCache objectForKey:messageId];
    if (!dataModel) {
        dataModel = [[AttributedStringDataModel alloc]init];
    }
    dataModel.attributedString = attributedString;
    dataModel.isComplete = isComplete;
    [self.contentAttrCache setObject:dataModel forKey:messageId];
}

- (void)updateApprovalStatus:(MessageBussiness *)bussiness
                     message:(NIMMessage *)message
                targetStatus:(Message_Bussiness_Status)targetStatus
                      method:(NSString *)method
                      params:(NSMutableDictionary *)params {
    [HttpRequestHelper updateFamilyBussinessStatusWith:targetStatus messageBussiness:bussiness method:method params:params successs:^(MessageBussiness *bussiness) {
//        Attachment *attachment = [[Attachment alloc]init];
//        attachment.first = bussiness.first;
//        attachment.second = bussiness.second;
//        attachment.data = bussiness.data;
//        NIMCustomObject *customObject = [[NIMCustomObject alloc]init];
//        customObject.attachment = attachment;
//        message.messageObject = customObject;
        MessageBussiness *bus = [MessageBussiness yy_modelWithJSON:message.localExt];
        bus.layout = [MessageLayout yy_modelWithJSON:message.localExt[@"layout"]];
        bus.status = bussiness.status;
        message.localExt = [bus model2dictionary];
        [GetCore(ImMessageCore)updateMessage:message session:message.session];
    } failure:^(NSNumber *resCode, NSString *msg) {
        [self handleCommonFamilyBussinessMessageWithResCode:[resCode integerValue] message:message];
    }];
}


- (void)familyGuideAndService{
    
    NSString *userID = [GetCore(AuthCore) getUid];
    if (userID.length<=0) {
        return;
    }
    @weakify(self);
    [HttpRequestHelper guideAndServiceWith:userID successs:^(NSDictionary *squareList) {
        @strongify(self);
        self.serviceDic = squareList;
        NotifyCoreClient(FamilyCoreClient, @selector(getServiceAndPhoneSuccess:), getServiceAndPhoneSuccess:squareList);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

//发现
- (void)familyFinderMessage:(NSString *)userID
{
    
    [[self getFamilyDiscoverRecommend:1] subscribeNext:^(id x) {
        XCFamily * charmInfor = (XCFamily *)x;//上周的魅力排行榜
        [[self familySquareInfor:userID] subscribeNext:^(id x) {
            //家族的信息（包含了banners 家族信息）
            NSMutableDictionary * famiyInfor = (NSMutableDictionary *)x;
            [famiyInfor safeSetObject:charmInfor forKey:@"charm"];
            NotifyCoreClient(FamilyCoreClient, @selector(getFinderFamilyMessageSuccess:), getFinderFamilyMessageSuccess:famiyInfor);
        } error:^(NSError *error) {
            NotifyCoreClient(FamilyCoreClient, @selector(getFinderFamilyMessageFail:), getFinderFamilyMessageFail:nil);
        }];
    } error:^(NSError *error) {
        [[self familySquareInfor:userID] subscribeNext:^(id x) {
            NSMutableDictionary * famiyInfor = (NSMutableDictionary *)x;
            NotifyCoreClient(FamilyCoreClient, @selector(getFinderFamilyMessageSuccess:), getFinderFamilyMessageSuccess:famiyInfor);
        } error:^(NSError *error) {
            NotifyCoreClient(FamilyCoreClient, @selector(getFinderFamilyMessageFail:), getFinderFamilyMessageFail:nil);
        }];
    }];
    

}


//家族广场
- (void)familySquareListWithID:(NSString *)userID
{
    [[self getFamilyDiscoverRecommend:2] subscribeNext:^(id x) {
        XCFamily * charmFamily = (XCFamily *)x;
        [[self familySquareInfor:userID] subscribeNext:^(id x) {
            NSMutableDictionary * dic = (NSMutableDictionary *)x;
            [dic setValue:charmFamily forKey:@"charm"];
            NotifyCoreClient(FamilyCoreClient, @selector(getFamilySqureListSuccess:), getFamilySqureListSuccess:dic);
        } error:^(NSError *error) {
            NotifyCoreClient(FamilyCoreClient, @selector(getFamilySqureListFail:), getFamilySqureListFail:nil);
        }];
    } error:^(NSError *error) {
        [[self familySquareInfor:userID] subscribeNext:^(id x) {
            NSMutableDictionary * dic = (NSMutableDictionary *)x;
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilySqureListSuccess:), getFamilySqureListSuccess:dic);
        } error:^(NSError *error) {
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilySqureListFail:), getFamilySqureListFail:nil);
        }];
    }];
}

- (void)getTotalFamilysWith:(NSString *)userId
                  andStatus:(int)status andPage:(int)page;
{
    [HttpRequestHelper getTotalFamilys:userId page:page successs:^(NSArray *squareList) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTotalFamilysListSuccessStatus:andList:), getTotalFamilysListSuccessStatus:status andList:squareList);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTotalFamilysListFailStatus:andMessage:), getTotalFamilysListFailStatus:status andMessage:message);
    }];
}

//家族广场的搜索的作用
- (void)searchFamilyListWithKey:(NSString *)key
{
    [HttpRequestHelper searchFamilSquareListWithFamilykey:key successs:^(NSArray *squareList) {
        NotifyCoreClient(FamilyCoreClient, @selector(searchFamilyListSuccess:), searchFamilyListSuccess:squareList);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(searchFamilyListFail:), searchFamilyListFail:message);
    }];
}


- (void)checktFamilyInforWith:(NSString *)teamId
{
    @weakify(self);
    [HttpRequestHelper getFamilyInforWith:teamId successs:^(XCFamily *familyModel) {
        @strongify(self);
        self.teamId = familyModel.familyId;
        if (familyModel.enterStatus == UserInFamilyYES) {
            self.model = familyModel;
        }
        NotifyCoreClient(FamilyCoreClient, @selector(getfamilyInforSuccess:), getfamilyInforSuccess:familyModel);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getfamilyInforFail:), getfamilyInforFail:message);
    }];
}

/**
 退出家族
 */
- (void)quitFamily
{
    [HttpRequestHelper quitFamilysuccesss:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(quitFamilySuccess:), quitFamilySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(quitFamilyFail:), quitFamilyFail:message);
    }];
}

- (void)enterFamilyWith:(NSString *)content
                 teamId:(NSString *)teamId
{
    [HttpRequestHelper userenterFamilyWith:teamId content:content successs:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(enterFamilySuccess:), enterFamilySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(enterFamilyFail:), enterFamilyFail:message);
    }];
}

//修改家族信息
- (void)modifyFamilyInfor:(NSDictionary *)familyDic
{
    [HttpRequestHelper modifyFamilyInforWith:familyDic successs:^(NSDictionary *modelDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(modifyFamilyInforMessageSuccess:), modifyFamilyInforMessageSuccess:modelDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(modifyFamilyInforMessageFail), modifyFamilyInforMessageFail);
    }];
}

- (void)requestGameListByFamilyId:(NSInteger)familyId {
    [HttpRequestHelper requestFamilyGameListByFamilyId:familyId success:^(NSArray<XCFamilyModel *> *source) {
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilyGameListSuccess:familyId:), getFamilyGameListSuccess:source familyId:familyId);
    } failure:^(NSNumber *redCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilyGameListFailure:), getFamilyGameListFailure:message);
    }];
}


- (void)fetchFamilyMemberList:(NSString * )userId
                         page:(NSInteger)page status:(NSInteger)status
{
    [HttpRequestHelper fetchFamilyMembersList:userId page:page success:^(XCFamily *family) {
        NotifyCoreClient(FamilyCoreClient, @selector(demandFamilyMemberListSuccess:status:), demandFamilyMemberListSuccess:family status:status);
    } failure:^(NSNumber *redCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(demandFamilyMemberListFail:status:), demandFamilyMemberListFail:message status:status)
    }];
}

- (void)removeFamilyMember:(NSInteger)targetId
{
    [HttpRequestHelper kichUserFromFamilyWithTargetID:targetId successs:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(kickoutFamilySuccess:), kickoutFamilySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(kickoutFamilyFail:), kickoutFamilyFail:message)
    }];
}

- (void)fetchFamilyMoneyManaegerWith:(NSString *)userID
{
    [HttpRequestHelper familyMoneyManagermentWith:userID successs:^(XCFamily *model) {
        self.model.familyMoney = model.totalAmount;
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyManagerSuccess:), fetchFamilyManagerSuccess:model);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyManagerFail:), fetchFamilyManagerFail:message);
    }];
}

- (void)fetchFamilyMoneyRecordListWith:(NSInteger)userId
                               andPage:(int)page
                              withTime:(NSString *)time
                                status:(int)status
                             isSearch:(BOOL)isSearch

{
    [HttpRequestHelper srachFamilyMoneyTradRecordWith:userId andPage:page andTime:time successs:^(NSMutableArray<XCFamilyMoneyModel *> *recordList) {
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyMoneyListSuccess:status:isSearch:), fetchFamilyMoneyListSuccess:recordList status:status isSearch:isSearch);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyMoneyListFail:status:isSearch:), fetchFamilyMoneyListFail:message status:status isSearch:isSearch);
    }];
}

- (void)transferFamilyMoenyTo:(NSInteger)targetId
                    andAmount:(NSString *)amount
{
    [HttpRequestHelper familyMoneyTradExchangeWith:[[GetCore(AuthCore) getUid] userIDValue] andTargetID:targetId andAmount:amount successs:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(exchangeFamilyMoneySuccess:), exchangeFamilyMoneySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(exchangeFamilyMoneyFail:), exchangeFamilyMoneyFail:message);
    }];
}

- (void)memberContributeFamilyMoney:(NSString *)amount
{
    [HttpRequestHelper memberContributFamilyMoneyTo:amount uccesss:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(memberContributeFamilyMoneySuccess:), memberContributeFamilyMoneySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(memberContributeFamilyMoneyFail:), memberContributeFamilyMoneyFail:message);
    }];
}

- (void)searchFamilyMemberListWithKey:(NSString *)key
{
    [HttpRequestHelper searchFamilyMemberlistWithKey:key successs:^(NSArray *memberList) {
        NotifyCoreClient(FamilyCoreClient, @selector(searchFamilyMemberListSuccess:), searchFamilyMemberListSuccess:memberList);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(searchFamilyMemberListFail:), searchFamilyMemberListFail:message);
    }];
}

- (void)inviteUserEnterFamilyWithTargetId:(NSString *)targetId
{
    [HttpRequestHelper inviteUserToFamilyWith:[GetCore(AuthCore) getUid] andTargetID:targetId successs:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(inviteOtherUserToFamilySuccess:), inviteOtherUserToFamilySuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(inviteOtherUserToFamilyFail:), inviteOtherUserToFamilyFail:message);
    }];
}

- (void)acceptPatriarchInviteWith:(NSString *)inviterId
{
    [HttpRequestHelper acceptInviteEnterFamilyWith:[GetCore(AuthCore) getUid] andInviteID:inviterId successs:^(NSDictionary *successDic) {
        NotifyCoreClient(FamilyCoreClient, @selector(acceptFamilyInviteSuccess:), acceptFamilyInviteSuccess:successDic);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(acceptFamilyInviteFail:), acceptFamilyInviteFail:message);
    }];
}

- (void)fetchFamilyMemberNotInGroupWith:(NSInteger)chatId
                                andPage:(NSInteger)page
                                 andKey:(NSString *)key
                              andStatus:(int)status
                               isSearch:(BOOL)isSearch
{
    [HttpRequestHelper fetchFamilyMemberNotJoinGroupWith:chatId andPage:page andKey:key success:^(XCFamily * familyInfor) {
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyMemberNotInGroupSuccess:andStatus:isSearch:), fetchFamilyMemberNotInGroupSuccess:familyInfor andStatus:status isSearch:isSearch);
    } failure:^(NSNumber *redCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(fetchFamilyMemberNotInGroupFail:andStatus:isSearch:), fetchFamilyMemberNotInGroupFail:message andStatus:status isSearch:isSearch);
    }];
}

- (void)getGroupWeekFamilyMoneyRecord:(NSInteger)groupId erbanNo:(NSInteger)erbanNo page:(int)page status:(int)status isSearch:(BOOL)isSearch{
    [HttpRequestHelper fetchGroupWeekRecordWith:groupId erbanNo:erbanNo page:page success:^(XCFamily *family) {
        NotifyCoreClient(FamilyCoreClient, @selector(getGroupWeekFamilyMoneyRecordSuccess:status:isSearch:), getGroupWeekFamilyMoneyRecordSuccess:family status:status isSearch:isSearch);
    } failure:^(NSNumber *redCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getGroupWeekFamilyMoneyRecordFail:status:isSearch:), getGroupWeekFamilyMoneyRecordFail:message status:status isSearch:isSearch);
    }];
}

//家族的 家族币记录
- (void)getFamilyMoneyRecordList:(NSString *)userId time:(NSString *)time page:(int)page status:(int)status{
    [HttpRequestHelper getFamilyMoneyRecord:userId time:time page:page successs:^(NSMutableArray<XCFamilyMoneyModel *> *recordList) {
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilyMoneyRecordSuccess:status:), getFamilyMoneyRecordSuccess:recordList status:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getFamilyMoneyRecordFail:status:), getFamilyMoneyRecordFail:message status:status);
    }];
}

//家族列表的（新的）魅力家族
- (void)getCharmFamilyList:(int)type page:(int)page pageSize:(int)pageSize status:(int)status{
    [HttpRequestHelper getFamilyRecormmendList:type page:page pageSize:pageSize successs:^(XCFamily *charmFamilyInfor) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTolalCharmFamilyListSuccess:family:), getTolalCharmFamilyListSuccess:status family:charmFamilyInfor);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTolalCharmFamilyListFail:andMessage:), getTolalCharmFamilyListFail:status andMessage:message);
    }];
}

//得到魅力家族的排行榜
-(RACSignal *)getFamilyDiscoverRecommend:(int)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getFamilyRecormmendList:type page:1 pageSize:6 successs:^(XCFamily *charmFamilyInfor) {
            [subscriber sendNext:charmFamilyInfor];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
           [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}
//得到发现页的信息
-(RACSignal *)getFamilyDiscoveInfor:(NSString *)userID{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getFamilyFinderMessageWith:userID successs:^(NSDictionary *bussiness) {
            [subscriber sendNext:bussiness];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

- (RACSignal *)familySquareInfor:(NSString *)userID{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getFamilySquareMessageWith:userID successs:^(NSMutableDictionary *bussiness) {
            [subscriber sendNext:bussiness];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
             [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
}

#pragma mark -萌声的家族
-(RACSignal *)getMSDiscoverBannerinforWith:(UserID)userID{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper getMSDicoverBannderInfor:userID successs:^(XCFamily *discoverInfor) {
            [subscriber sendNext:discoverInfor];
            [subscriber sendCompleted];
        } failure:^(NSNumber *resCode, NSString *message) {
            [subscriber sendError:CORE_API_ERROR(UserCoreErrorDomain, resCode.integerValue, message)];
        }];
        return nil;
    }];
    
}



- (void)getMSDiscoverInforWith:(UserID)userID{
    //先请求顶部的bannser
    [[self getMSDiscoverBannerinforWith:userID] subscribeNext:^(id x) {
        //家族魅力排行榜
        XCFamily * bannerInfor = (XCFamily *)x;
        [[self getFamilyDiscoverRecommend:1] subscribeNext:^(id x) {
          XCFamily * family = (XCFamily *)x;
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:bannerInfor forKey:@"banner"];
            [dic setValue:family forKey:@"charm"];
            NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverInforSuccess:), getMSDiscoverInforSuccess:dic);
        } error:^(NSError *error) {
            NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverInforFail), getMSDiscoverInforFail);
        }];
    } error:^(NSError *error) {
        [[self getFamilyDiscoverRecommend:1] subscribeNext:^(id x) {
            XCFamily * charmInfor = (XCFamily *)x;
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:charmInfor forKey:@"charm"];
            NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverInforSuccess:), getMSDiscoverInforSuccess:dic);
        } error:^(NSError *error) {
             NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverInforFail), getMSDiscoverInforFail);
        }];
    }];
    
}

- (void)getMSDiscoverFamilyInfor{
    [[GetCore(UserCore)  getUserInfoByRac:[[GetCore(AuthCore) getUid] userIDValue] refresh:YES] subscribeNext:^(id x) {
        UserInfo * infor = (UserInfo *)x;
        if (infor.familyId > 0) {
            [self requestFamilyInfoByFamilyId:[NSString stringWithFormat:@"%ld", infor.familyId] success:^(XCFamily *family) {
                NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverFamilyInforSuccess:), getMSDiscoverFamilyInforSuccess:family);
            }];
        }else{
             NotifyCoreClient(FamilyCoreClient, @selector(getMSDiscoverFamilyInforSuccess:), getMSDiscoverFamilyInforSuccess:nil);
        }
    }];
}

- (void)getTTDiscoverBannerInfor:(NSString *)userId{
    [HttpRequestHelper getFamilyFinderMessageWith:userId successs:^(NSDictionary *bussiness) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTTDiscoverBannerSuccess:), getTTDiscoverBannerSuccess:bussiness);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(FamilyCoreClient, @selector(getTTDiscoverBannerFail:), getTTDiscoverBannerFail:message);
    }];
}


#pragma mark - IMmessageCoreClient
- (void)onRecvP2PCustomMsg:(NIMMessage *)msg
{
    //房间自定义消息
    if (msg.messageType == NIMMessageTypeCustom && msg.session.sessionType == NIMSessionTypeP2P) {
        NIMCustomObject *customObject = (NIMCustomObject *)msg.messageObject;
        //自定义消息附件是Attachment类型且有值
        if (customObject.attachment != nil && [customObject.attachment isKindOfClass:[MessageBussiness class]]) {
            MessageBussiness *attachment = (MessageBussiness *)customObject.attachment;
        if (attachment.params.actionType > 0){
            NSInteger actionType = attachment.params.actionType;
            if (actionType ==  FamilyNotificationType_Outer ||
              actionType == FamilyNotificationType_BeKicked ||
               actionType == FamilyNotificationType_Dismiss) {
                [self reloadFamilyInfor:nil];
            }
            
            if (actionType == FamilyNotificationType_System_Award || actionType == FamilyNotificationType_System_Discount || actionType == FamilyNotificationType_Donate_Money || actionType == FamilyNotificationType_Trade_Money) {
                NotifyCoreClient(FamilyCoreClient, @selector(reciveMeesageReloadFamilyMoney:), reciveMeesageReloadFamilyMoney:attachment.params);
            }else{
                NotifyCoreClient(FamilyCoreClient, @selector(reciveFamilyCustomMessageWith:), reciveFamilyCustomMessageWith:attachment.params);
            }
            //刷新个人信息
            if (attachment.params.actionType != FamilyNotificationType_Enter_Group || attachment.params.actionType != FamilyNotificationType_Quit_Group) {
                NotifyCoreClient(UserCoreClient, @selector(onFamilyUpdateUserInfor), onFamilyUpdateUserInfor);
            }
        }
        }
    }
}





- (NSString *)getLaderID
{
    if (self.model.members.count > 0) {
        XCFamilyModel * model = [self.model.members firstObject];
        return model.uid;
    }
    return nil;
}

- (XCFamily *)getFamilyModel
{
    if (self.model) {
        return self.model;
    }
    return nil;
}

- (void)reloadFamilyInfor:(XCFamily *)familyInfor
{
    if (familyInfor) {
        self.model = familyInfor;
    }else{
        self.model = nil;
    }
}


- (void)onUpdateMessageSuccess:(NIMMessage *)msg {
    NotifyCoreClient(FamilyCoreClient, @selector(onUpdateMessageFromOriginAndLocalSuccess:), onUpdateMessageFromOriginAndLocalSuccess:msg);
}

#pragma mark - Private

- (void)handleCommonFamilyBussinessMessageWithResCode:(NSInteger)rescode message:(NIMMessage *)message {
    if (message.localExt) {
        MessageBussiness *bus = [MessageBussiness yy_modelWithJSON:message.localExt];
        bus.layout = [MessageLayout yy_modelWithJSON:message.localExt[@"layout"]];
        switch (rescode) {
            case 7005:
                {
                    bus.status = Message_Bussiness_Status_OutDate;
                }
                break;
                
            default:
                break;
        }
        message.localExt = [bus model2dictionary];
        [GetCore(ImMessageCore)updateMessage:message session:message.session];
    }
}


#pragma mark - Getter
- (NSCache *)contentAttrCache {
    if (!_contentAttrCache) {
        _contentAttrCache = [[NSCache alloc]init];
    }
    return _contentAttrCache;
}



@end
