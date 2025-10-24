//
//  ClientCore.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "ClientCore.h"
#import "AppInitClient.h"
#import "HttpRequestHelper+Client.h"
#import "AdCore.h"
#import "FaceCore.h"
#import "NobleCore.h"
#import "PurseCore.h"
#import "DESEncrypt.h"
#import "NSString+JsonToDic.h"
#import "PrivilegeInfo.h"
#import "MonsterGameModel.h"
#import "TabBarConfig.h"
#import "TabBarConfigManager.h"

#import "HomeCoreClient.h"
#import "XCMacros.h"
#import "ImLoginCore.h"
#import "RoomCoreV2.h"
#import "HostUrlManager.h"

#import "ImPublicChatroomCore.h"
#import "TTCPGameStaticCore.h"
#import "LittleWorldCore.h"

#import "AppDelegate.h"

@interface ClientCore ()<HomeCoreClient>

@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic,assign) NSInteger retryDelay;

@end

@implementation ClientCore

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initApp];
         [self baiduObserveCallBackApi];
        AddCoreClient(HomeCoreClient, self);
        
        [self requestCustomerConfig:^(NSDictionary *dict, NSNumber *errCode, NSString *msg) {
            if (dict) {
                self.customerType = [dict[@"type"] intValue];
            }
        }];
    }
    return self;
}


- (void)initApp {
    GetCore(FaceCore).isLoadFace = NO;
    self.retryCount += 1;
    HostUrlManager *option = [HostUrlManager shareInstance];
    NSArray *localArray = [option getHostListFromMemory];
    @weakify(self);
    [[option rac_getFasterHostName:localArray] subscribeNext:^(id x) {
        @strongify(self);
        NSArray *filtLocalHost = (NSArray *)x;
        if (filtLocalHost.count) {
            //hosturl
            [[HostUrlManager shareInstance] updatHostUrl:filtLocalHost.firstObject];
            //client
            [self clientInitNetwork:filtLocalHost.firstObject];
        } else {
            NSArray *remoteArray = [option getHostListFromDisk];
            if (remoteArray.count) {
                [[option rac_getFasterHostName:remoteArray] subscribeNext:^(id x) {
                    @strongify(self);
                    NSArray *filtRemoteHost = (NSArray *)x;
                    if (filtRemoteHost.count) {
                        //hosturl
                        [[HostUrlManager shareInstance] updatHostUrl:filtRemoteHost.firstObject];
                        //client
                        [self clientInitNetwork:filtRemoteHost.firstObject];
                    } else {
                        //ip
                        [[[HostUrlManager shareInstance] rac_getIpHost] subscribeNext:^(id x) {
                            @strongify(self);
                            NSString *iphost = (NSString *)x;
                            [[HostUrlManager shareInstance] updatHostUrl:iphost];
                            [self clientInitNetwork:iphost];
                        }];
                    }
                }];
            } else {
                //ip
                [[[HostUrlManager shareInstance] rac_getIpHost] subscribeNext:^(id x) {
                    @strongify(self);
                    NSString *iphost = (NSString *)x;
                    [[HostUrlManager shareInstance] updatHostUrl:iphost];
                    [self clientInitNetwork:iphost];
                }];
            }
        }
    }];
}

- (void)clientInitNetwork:(NSString *)hostName {
    if (hostName.length <= 0) {
        hostName = [HostUrlManager shareInstance].hostUrl;
    }
    @weakify(self);
    [HttpRequestHelper getTheClientInitWithHostName:hostName success:^(NSDictionary *initData) {
        
        NSLog(@"initData:%@",initData);
        // updateUrl = "http://beta.kawayisound.xyz";
        self.updateUrl = initData[@"updateUrl"][@"iOSUrl"];
        //remote hostlist
        NSArray *hostList = initData[@"domainList"];
        [[HostUrlManager shareInstance] saveHostList:hostList];
        
        /*web share host url*/
        [HostUrlManager shareInstance].webHostName = initData[@"webHostName"];
        
        /*Ad*/
        GetCore(AdCore).splash = [AdInfo modelWithJSON:initData[@"splashVo"]];
        NotifyCoreClient(AppInitClient, @selector(onGetAdSuucess), onGetAdSuucess);
        GetCore(PurseCore).exchangeGoldRate = [initData[@"exchangeGoldRate"] doubleValue];
        //xcGetCF的时候税率
        GetCore(PurseCore).taxDic = initData[@"tax"];
        GetCore(PurseCore).minDisplayCount = [initData[@"minDisplayCount"] integerValue];
        
        /* box */
        GetCore(RoomCoreV2).openBoxSwitch = [initData[@"openBoxSwitch"] boolValue];
        GetCore(RoomCoreV2).openBoxLimitLevel = [initData[@"openBoxSwitchLevelNo"] intValue];
        
        /*Privilege 贵族特权*/
        NSArray *nobleArr = [NSArray yy_modelArrayWithClass:[PrivilegeInfo class] json:initData[@"rights"]];
        for (PrivilegeInfo *item in nobleArr) {
            NobleInfo *nobleInfo = [[NobleInfo alloc]init];
            nobleInfo.level = item.id;
            nobleInfo.privilegeInfo = item;
            
            /*贵族资源*/
            GetCore(NobleCore).zipUrl = initData[@"nobleZip"][@"zipUrl"];
            GetCore(NobleCore).version = [initData[@"nobleZip"][@"version"] integerValue];
            
            [GetCore(NobleCore).tempPrivilegeDict setObject:nobleInfo forKey:[NSString stringWithFormat:@"%d",item.id]];
            
            NotifyCoreClient(AppInitClient, @selector(onGetNoblePrivilegeSuccess), onGetNoblePrivilegeSuccess);
        }
        NSDictionary *nobleRescource = [NSString dictionaryWithJsonString:initData[@"nobleZip"][@"resConf"]];
        for (NSString *key in nobleRescource.allKeys) {
            NobleInfo *nobleInfo = [GetCore(NobleCore).tempPrivilegeDict objectForKey:key];
            [nobleInfo.badge setValues:nobleRescource[key][@"badge"]];
            nobleInfo.cardbg.values = nobleRescource[key][@"cardbg"];
            nobleInfo.zonebg.values = nobleRescource[key][@"zonebg"];
            nobleInfo.open_effect.values = nobleRescource[key][@"open_effect"];
            nobleInfo.banner.values = nobleRescource[key][@"banner"];
            nobleInfo.headerwear.values = nobleRescource[key][@"headwear"];
            nobleInfo.halo.values = nobleRescource[key][@"halo"];
            nobleInfo.bubble.values = nobleRescource[key][@"bubble"];
            nobleInfo.recommend.values = nobleRescource[key][@"recommend"];
        }
        
        /** pubic chat room **/
        GetCore(ImPublicChatroomCore).publicChatRoomLevelNo = [[initData objectForKey:@"publicChatRoomLevelNo"] integerValue];
        GetCore(ImPublicChatroomCore).publicChatroomId = [[initData objectForKey:@"publicChatRoomId"] integerValue];
        GetCore(ImPublicChatroomCore).publicChatroomUid = [[initData objectForKey:@"publicChatRoomUid"] integerValue];
         GetCore(ImPublicChatroomCore).privateChatLevelNo = [[initData objectForKey:@"privateChatLevelNo"] integerValue];
        NotifyCoreClient(AppInitClient, @selector(onGetPublicChatroomIdSuccess), onGetPublicChatroomIdSuccess);
        
        /**  游戏的各种开关 **/
        GetCore(TTCPGameStaticCore).gameSwitch = [initData[@"gameSwitch"] boolValue];
        GetCore(TTCPGameStaticCore).roomGameSwitch = [initData[@"roomGameSwitch"] boolValue];
        GetCore(TTCPGameStaticCore).gameTime = [initData[@"gameTime"] integerValue] > 0 ? [initData[@"gameTime"] integerValue] : 60;
        GetCore(TTCPGameStaticCore).gameFrequency = [initData[@"gameFrequency"] integerValue] > 0 ? [initData[@"gameFrequency"] integerValue] : 60;
        GetCore(TTCPGameStaticCore).gameRankSwitch = [initData[@"gameRankSwitch"] boolValue];
        
        
        /** 认证 **/
        self.certificationType = [[initData objectForKey:@"certificationType"] integerValue];
        self.wechatPublic = [initData objectForKey:@"wechatPublic"];
        /* FaceJson */
        NSString *json = initData[@"faceJson"][@"json"];
        NSString *deJson = [DESEncrypt decryptUseDES:json key:keyWithType(KeyType_PwdEncode, NO)];
        NSDictionary *faceInitData = [NSString dictionaryWithJsonString:deJson];
        if (faceInitData) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FaceConfigInfo class] json:faceInitData[@"faces"]];
            GetCore(FaceCore).version = [NSString stringWithFormat:@"%@",faceInitData[@"version"]];
            GetCore(FaceCore).zipMd5 = [[NSString stringWithFormat:@"%@",faceInitData[@"zipMd5"]] uppercaseString];
            GetCore(FaceCore).zipUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",faceInitData[@"zipUrl"]]];
            
            NotifyCoreClient(AppInitClient, @selector(onGetFaceDataSuccess:), onGetFaceDataSuccess:arr);
            
        }else {
            
        }
        
        BOOL canplayTogether = [[initData objectForKey:@"playTogether"] boolValue];
        GetCore(FaceCore).canPlayTogether = canplayTogether;
        
        //monster
        NSArray *monsterArray = [NSArray yy_modelArrayWithClass:[MonsterGameModel class] json:initData[@"monsters"]];
        NotifyCoreClient(AppInitClient, @selector(onGetMonsterWillShow:), onGetMonsterWillShow:monsterArray);
        
        // 注册图片验证码
        self.captchaSwitch = [initData[@"captchaSwitch"] boolValue];
        
        GetCore(LittleWorldCore).worldGroupChatLevelNo = [initData[@"worldGroupChatLevelNo"] integerValue];
        
        self.reportSwitch = [initData[@"reportSwitch"] boolValue];
        
        // 青少年模式弹窗
        self.teenagerMode = [initData[@"teenagerMode"] integerValue];
//        [4]    (null)    @"parentMode" : (long)1
        
        TabBarConfig *tabbar = [TabBarConfig modelWithJSON:initData[@"bottomTabs"]];
        [TabBarConfigManager.shareInstance updateConfig:tabbar];
        
    } failure:^(NSNumber *resCode, NSString *message) {
        @strongify(self);
        if (self.retryCount < 10) {
            if (self.retryDelay == 0) {
                self.retryDelay = 1;
            }
            [self performSelector:@selector(clientInitNetwork:) withObject:[HostUrlManager shareInstance].hostUrl afterDelay:self.retryDelay * 2];
        }
    }];
}

#pragma mark - HomeCoreClient
- (void)networkReconnect {
    [self initApp];
}

//百度统计
- (void)baiduObserveCallBackApi{
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        return;
    }
    [HttpRequestHelper appInitObserveBaiduCallBackWithSuccess:^(NSDictionary *dic) {
        
    } failure:^(NSString *message, NSNumber *code) {
        
    }];
}

#pragma mark -
#pragma mark Location
/**
 上传用户地理位置接口
 
 @param address 地址信息
 @param adcode 城市编码
 @param longitude 经度
 @param latitude 纬度
 */
- (void)uploadUserLocationAddress:(NSString *)address
                           adcode:(NSString *)adcode
                        longitude:(double)longitude
                         latitude:(double)latitude {
    
    [HttpRequestHelper uploadUserLocationAddress:address adcode:adcode longitude:longitude latitude:latitude success:^(BOOL success) {
        NotifyCoreClient(AppInitClient, @selector(onGetLocationSuccess:errorCode:message:), onGetLocationSuccess:YES errorCode:nil message:nil);
    } failure:^(NSString *message, NSNumber *code) {
        NotifyCoreClient(AppInitClient, @selector(onGetLocationSuccess:errorCode:message:), onGetLocationSuccess:NO errorCode:code message:message);
    }];
}

// 请求客服配置
- (void)requestCustomerConfig:(void (^)(NSDictionary *dict, NSNumber *errCode, NSString *msg))completion {
    [HttpRequestHelper requestCustomerConfig:^(id data, NSNumber *code, NSString *msg) {
        if (completion) {
            completion(data,code,msg);
        }
    }];
}

- (void)requestYDConfig:(void (^)(NSNumber *dict, NSNumber *errCode, NSString *msg))completion{
    
    [HttpRequestHelper GET:@"acc/protected/switch" params:nil success:^(id data) {
        if (completion) {
            completion(data,nil,nil);
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        if (completion) {
            completion(nil,resCode,message);
        }
    }];
   
}

#pragma mark - AppLifeCycle

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    // 1.获得shortcutItem的type type就是初始化shortcutItem的时候传入的唯一标识符
    NSString *type = shortcutItem.type;
    
    //2.可以通过type来判断点击的是哪一个快捷按钮 并进行每个按钮相应的点击事件
    if ([type isEqualToString:@"openGameRoom"]) {
        self.needOpenRoom = YES;
        self.foreTouchOpenRoomType = RoomType_Game;
        if ([GetCore(ImLoginCore) isImLogin]) {
            if (self.needOpenRoom) {
                self.needOpenRoom = NO;
                @weakify(self);
                NotifyCoreClient(AppInitClient, @selector(onNeedOpenRoomWithRoomType:), onNeedOpenRoomWithRoomType:self.foreTouchOpenRoomType);
            }
        }
    }else if ([type isEqualToString:@"openPartyRoom"]) {
        self.needOpenRoom = YES;
        self.foreTouchOpenRoomType = RoomType_Party;
        if ([GetCore(ImLoginCore) isImLogin]) {
            if (self.needOpenRoom) {
                self.needOpenRoom = NO;
                @weakify(self);
                NotifyCoreClient(AppInitClient, @selector(onNeedOpenRoomWithRoomType:), onNeedOpenRoomWithRoomType:self.foreTouchOpenRoomType);
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


#pragma mark - Getter & Setter
- (FaceLivenessStrategy)strategy{
    if (self.certificationType==1){
        
        return FaceLivenessStrategy_Force;
    }else if (self.certificationType==2){
        
        return FaceLivenessStrategy_Guide;
    }else{
        
        return FaceLivenessStrategy_Pass;
    }
}

@end
