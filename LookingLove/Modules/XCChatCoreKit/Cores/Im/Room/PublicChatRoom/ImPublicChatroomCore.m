//
//  PublicChatroomCore.m
//  AFNetworking
//
//  Created by 卫明 on 2018/11/1.
//

#import "ImPublicChatroomCore.h"

#import "ImRoomExtMapKey.h"

#import <NIMSDK/NIMSDK.h>

//client
#import "ImPublicChatroomClient.h"
#import "ImLoginCoreClient.h"
#import "AppInitClient.h"
#import "UserCoreClient.h"
#import "AdCoreClient.h"
#import "ImRoomCoreClient.h"

#import "UserCore.h"
#import "AuthCore.h"
//tool
#import "NobleSourceTool.h"
#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSDictionary+Safe.h"
#import "NSMutableDictionary+Safe.h"

@interface ImPublicChatroomCore ()
<
    NIMChatroomManagerDelegate,
    ImLoginCoreClient,
    AppInitClient,
    UserCoreClient,
    AdCoreClient,
    ImRoomCoreClient
>

@property (nonatomic,assign) BOOL isLoginSuccess;

@property (nonatomic,assign) BOOL isGetRoomIdSuccess;

@property (nonatomic,assign) BOOL isUserInfoUpdate;

@end

@implementation ImPublicChatroomCore

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
        AddCoreClient(ImLoginCoreClient, self);
        AddCoreClient(AppInitClient, self);
        AddCoreClient(UserCoreClient, self);
        AddCoreClient(AdCoreClient, self);
        AddCoreClient(ImRoomCoreClient, self);
        [self initPublicChatroom];
    }
    return self;
}

- (void)initPublicChatroom {
    @weakify(self);
    [[self rac_signalForSelector:@selector(onImLoginSuccess) fromProtocol:@protocol(ImLoginCoreClient)] subscribeNext:^(id x) {
        @strongify(self);
        self.isLoginSuccess = YES;
        
        if (self.isLoginSuccess && self.isGetRoomIdSuccess && self.isUserInfoUpdate) {
            [[self enterPublicChatroomRoomId:[NSString stringWithFormat:@"%ld",(long)self.publicChatroomId]]subscribeNext:^(id x) {
                NotifyCoreClient(ImPublicChatroomClient, @selector(onPublicChatRoomSuccess:), onPublicChatRoomSuccess:(NIMChatroom *)x);
            }];
        }
    }];
    [[self rac_signalForSelector:@selector(onGetPublicChatroomIdSuccess) fromProtocol:@protocol(AppInitClient)]subscribeNext:^(id x) {
        self.isGetRoomIdSuccess = YES;
        if (self.isLoginSuccess && self.isGetRoomIdSuccess && self.isUserInfoUpdate) {
            [[self enterPublicChatroomRoomId:[NSString stringWithFormat:@"%ld",(long)self.publicChatroomId]]subscribeNext:^(id x) {
                NotifyCoreClient(ImPublicChatroomClient, @selector(onPublicChatRoomSuccess:), onPublicChatRoomSuccess:(NIMChatroom *)x);
            }];
        }
    }];
    [[self rac_signalForSelector:@selector(onCurrentUserInfoUpdate:) fromProtocol:@protocol(UserCoreClient)]subscribeNext:^(id x) {
        self.isUserInfoUpdate = YES;
        if (self.isLoginSuccess && self.isGetRoomIdSuccess && self.isUserInfoUpdate) {
            [[self enterPublicChatroomRoomId:[NSString stringWithFormat:@"%ld",(long)self.publicChatroomId]]subscribeNext:^(id x) {
                NotifyCoreClient(ImPublicChatroomClient, @selector(onPublicChatRoomSuccess:), onPublicChatRoomSuccess:(NIMChatroom *)x);
            }];
        }
    }];

}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
}

- (RACSignal *)enterPublicChatroomRoomId:(NSString *)roomId {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if (self.publicChatroomId > 0) {
            NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc]init];
            request.roomId = roomId;
            UserInfo *userInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
            SingleNobleInfo *nobleInfo = userInfo.nobleUsers;
            LevelInfo *levelInfo = userInfo.userLevelVo;
            UserCar *carInfo = userInfo.carport;
            NSMutableDictionary *extSource = [NSMutableDictionary dictionary];
            if (nobleInfo) {
                if (nobleInfo.level > 0) {
                    extSource = [NobleSourceTool sortStringWithNobleInfo:nobleInfo];
                    [extSource removeObjectForKey:@"zoneBg"];
                    [extSource removeObjectForKey:@"cardBg"];
                    [extSource removeObjectForKey:@"rankHide"];
                    [extSource removeObjectForKey:@"expire"];
                    [extSource removeObjectForKey:@"recomCount"];
                }
            }
            //        UserHeadWear *headwear = userInfo.userHeadwear;
            //        [extSource safeSetObject:headwear.effect forKey:@"pic"];
            [extSource safeSetObject:@(userInfo.defUser) forKey:@"defUser"];
            [extSource safeSetObject:userInfo.erbanNo forKey:@"erbanNo"];
            [extSource safeSetObject:@(userInfo.gender) forKey:@"gender"];
            
            if (userInfo.userHeadwear.effect.length && userInfo.userHeadwear.status == Headwear_Status_ok) {
                [extSource safeSetObject:userInfo.userHeadwear.effect forKey:@"pic"];
            }
            if (levelInfo) {
                [extSource safeSetObject:@([userInfo.userLevelVo.charmLevelSeq integerValue]) forKey:@"charmLevelSeq"];
                [extSource safeSetObject:@([userInfo.userLevelVo.experLevelSeq integerValue]) forKey:@"experLevelSeq"];
                [extSource safeSetObject:userInfo.userLevelVo.charmUrl forKey:@"charmUrl"];
                [extSource safeSetObject:userInfo.userLevelVo.experUrl forKey:@"experUrl"];
            }
            
            [extSource safeSetObject:@(userInfo.hasPrettyErbanNo) forKey:@"hasPrettyErbanNo"];
            
            [extSource safeSetObject:@(userInfo.defUser) forKey:@"defUser"];
            
            if (userInfo.newUser) {
                [extSource safeSetObject:@YES forKey:@"newUser"];
            }
            
            if (userInfo.hasPrettyErbanNo) {
                [extSource safeSetObject:@YES forKey:@"hasPrettyErbanNo"];
            }
            
            if (carInfo) {
                [extSource safeSetObject:carInfo.name forKey:@"carName"];
            }
            
            //官方主播认证（认证名称和图片背景）
            if (userInfo.nameplate) {
                [extSource safeSetObject:userInfo.nameplate.fixedWord forKey:ImRoomExtKeyOfficialAnchorCertificationName];
                [extSource safeSetObject:userInfo.nameplate.iconPic forKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
            }
            
            if (nobleInfo || levelInfo) {
                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
                request.roomExt = [ext yy_modelToJSONString];
            }
            if (projectType() == ProjectType_VKiss) {
                request.roomNickname = userInfo.communityNick;
                request.roomAvatar = userInfo.communityAvatar;
                [extSource safeSetObject:userInfo.age forKey:@"age"];
                [extSource safeSetObject:@(userInfo.gender) forKey:@"gender"];

                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
                request.roomExt = [ext yy_modelToJSONString];
            }
            [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
                
                self.publicMe = me;
                if (!error) {
                    [subscriber sendNext:chatroom];
                    [subscriber sendCompleted];
                }else {
                    
                    self.errorType = error.code;
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }
            }];
        }else {
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:@"公聊大厅不存在", NSLocalizedDescriptionKey,nil];
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:999 userInfo:userInfo1];
            [subscriber sendError:error];
        }
        return nil;
    }];
}

- (RACSignal *)rac_queryPublicChartRoomMemberByUid:(NSString *)uid{
    
    if (uid == nil || uid.length<=0) {
        return nil;
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        NIMChatroomMembersByIdsRequest *request = [[NIMChatroomMembersByIdsRequest alloc]init];
        request.roomId = [NSString stringWithFormat:@"%d",self.publicChatroomId];
        request.userIds = @[uid];
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            
            if (error == nil) {
                [subscriber sendNext:members.firstObject];
                [subscriber sendCompleted];
            }else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            
        }];
        return nil;
    }];
}

- (void)onUserHaveBannedForChatRoom:(NIMMessage *)message {
    [[self rac_queryPublicChartRoomMemberByUid:GetCore(AuthCore).getUid] subscribeNext:^(id x) {
        self.publicMe = (NIMChatroomMember *)x;
    }];
}

#pragma mark - private method
- (void)updateUserInfoInNIM:(UserInfo *)userInfo {
    
    SingleNobleInfo *nobleInfo = userInfo.nobleUsers;
    LevelInfo *levelInfo = userInfo.userLevelVo;
    UserCar *carInfo = userInfo.carport;
    NSMutableDictionary *extSource = [NSMutableDictionary dictionary];
    if (nobleInfo) {
        if (nobleInfo.level > 0) {
            extSource = [NobleSourceTool sortStringWithNobleInfo:nobleInfo];
            [extSource removeObjectForKey:@"zoneBg"];
            [extSource removeObjectForKey:@"cardBg"];
            [extSource removeObjectForKey:@"rankHide"];
            [extSource removeObjectForKey:@"expire"];
            [extSource removeObjectForKey:@"recomCount"];
        }
    }
    //        UserHeadWear *headwear = userInfo.userHeadwear;
    //        [extSource safeSetObject:headwear.effect forKey:@"pic"];
    [extSource safeSetObject:@(userInfo.defUser) forKey:@"defUser"];
    [extSource safeSetObject:userInfo.erbanNo forKey:@"erbanNo"];
    if (userInfo.userHeadwear.effect.length && userInfo.userHeadwear.status == Headwear_Status_ok) {
        [extSource safeSetObject:userInfo.userHeadwear.effect forKey:@"pic"];
    }
    if (levelInfo) {
        [extSource safeSetObject:userInfo.userLevelVo.charmUrl forKey:@"charmUrl"];
        [extSource safeSetObject:userInfo.userLevelVo.experUrl forKey:@"experUrl"];
    }
    
    if (userInfo.newUser) {
        [extSource safeSetObject:@YES forKey:@"newUser"];
    }
    
    if (userInfo.hasPrettyErbanNo) {
        [extSource safeSetObject:@YES forKey:@"hasPrettyErbanNo"];
    }
    
    if (carInfo) {
        [extSource safeSetObject:carInfo.name forKey:@"carName"];
    }
    
    //官方主播认证（认证名称和图片背景）
    if (userInfo.nameplate) {
        [extSource safeSetObject:userInfo.nameplate.fixedWord forKey:ImRoomExtKeyOfficialAnchorCertificationName];
        [extSource safeSetObject:userInfo.nameplate.iconPic forKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
    }
    
    NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc]init];
    request.roomId = [NSString stringWithFormat:@"%ld",(long)self.publicChatroomId];
    
    if (nobleInfo || levelInfo) {
        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithObject:extSource forKey:[GetCore(AuthCore) getUid]];
        request.updateInfo = @{@(NIMChatroomMemberInfoUpdateTagExt):[ext yy_modelToJSONString]};
    }

    
    [[NIMSDK sharedSDK].chatroomManager updateMyChatroomMemberInfo:request completion:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - UserCoreClient

//- (void)onCurrentUserInfoUpdate:(UserInfo *)userInfo {
//    if (userInfo.uid != [GetCore(AuthCore)getUid].userIDValue) {
//        return;
//    }
//    [self updateUserInfoInNIM:userInfo];
//}

#pragma mark - AdCoreClient

- (void)onReceiveUserUpGradeMessage:(UserUpGradeInfo *)upGradeInfo type:(UserUpgradeViewType)type {
    UserExtensionRequest *request = [[UserExtensionRequest alloc]init];
    request.type = QueryUserInfoExtension_Full;
    request.needRefresh = YES;
    @weakify(self);
    [[GetCore(UserCore)queryExtensionUserInfoByWithUserID:[GetCore(AuthCore)getUid].userIDValue requests:@[request]]subscribeNext:^(id x) {
        @strongify(self);
        UserInfo *userInfo = (UserInfo *)x;
        [self updateUserInfoInNIM:userInfo];
    }];
}

#pragma mark - NIMChatroomManagerDelegate

/**
 *  被踢回调
 *
 *  @param roomId   被踢的聊天室Id
 *  @param reason   被踢原因
 */
- (void)chatroomBeKicked:(NIMChatroomBeKickedResult *)result {
    NotifyCoreClient(ImPublicChatroomClient, @selector(onPublicChatroomWasKickedWithReason:), onPublicChatroomWasKickedWithReason:result.reason);
}

#pragma mark - ImLoginCoreClient
- (void)onImLoginSuccess {
    self.isLoginSuccess = YES;
}

- (void)onImLogoutSuccess {
    self.isLoginSuccess = NO;
}

#pragma mark - AppInitClient

- (void)onGetPublicChatroomIdSuccess {
    
}

@end
