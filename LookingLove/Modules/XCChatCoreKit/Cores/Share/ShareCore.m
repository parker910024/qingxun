//
//  ShareCore.m
//  BberryCore
//
//  Created by chenran on 2017/7/6.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ShareCore.h"
#import "ShareCoreClient.h"
#import "HttpRequestHelper+Share.h"

#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDK/SSDKRegister.h>
#import <ShareSDK/ShareSDK.h>
//微信SDK头文件
#import "WXApi.h"


#import "UserCore.h"
#import "AuthCore.h"
#import "FamilyCore.h"
#import "ImRoomCoreV2.h"
#import "ImMessageCore.h"
#import "Attachment.h"
#import "XCApplicationSharement.h"
#import "LittleWorldCore.h"

#import "ShareSendInfo.h"
#import "HostUrlManager.h"

#import "XCMacros.h"
#import "XCKeyWordTool.h"
#import "XCHUDTool.h"

@implementation ShareCore


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSdk];
    }
    return self;
}


#pragma mark - puble method
//分享所需要的model
- (ShareModelInfor *)getShareModel{
    
    return self.shareModel;
}
- (void)reloadShareModel:(ShareModelInfor *)model{
    
    if (model) {
        self.shareModel = model;
    }
}


//安装判断
- (BOOL)isInstallWechat{
    
    return [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
}

- (BOOL)isInstallQQ{
    
    return [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
}

- (BOOL)isInstallWeibo{
    
    return [ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo];
}


//分享
/**
 分享社区
 
 @param uid 分享的用户
 @param communityInfo 社区作品
 @param platform 分享的平台
 */
- (void)shareCommnuityUid:(UserID)uid communityInfo:(CommunityInfo *)communityInfo platform:(SharePlatFormType)platform {
    //1、创建分享参数
    UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:uid];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&worksId=%@",[HostUrlManager shareInstance].webHostName,@"ms/modules/share/share-wx.html",uid,communityInfo.ID];
    //    NSString * title = communityInfo.topic;
    NSString *title = @"——来自萌声情感社";
    NSString * content = communityInfo.content;
    NSString *imageURL = communityInfo.cover.length > 0 ? communityInfo.cover : @" ";
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (content.length == 0) {
        content = @" ";
    }
    [shareParams SSDKSetupShareParamsByText:content
                                     images:@[imageURL]
                                        url:[NSURL URLWithString:urlString]
                                      title:title
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    NSString *typeStr = [[NSString alloc]init];
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
        typeStr = @"1";
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
        typeStr = @"2";
    } else if (platform == Share_Platform_Type_Wechat_Circle) {
        type = SSDKPlatformSubTypeWechatTimeline;
        typeStr = @"3";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        type = SSDKPlatformSubTypeQZone;
        typeStr = @"4";
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                
                [self reportByPlatform:platform];
                
                [self shareCommunitySuccessWithShareType:platform worksId:communityInfo.ID];
                NotifyCoreClient(ShareCoreClient, @selector(onShareCommunitySuccess), onShareCommunitySuccess);
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:nil topic:SocializationLog logLevel:XCLogLevelVerbose];
            }
                break;
            case SSDKResponseStateFail:
            {
                NotifyCoreClient(ShareCoreClient, @selector(onShareCommunityFailth:), onShareCommunityFailth:error.domain);
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:error topic:SocializationLog logLevel:XCLogLevelError];
            }
                break;
            default:
                break;
        }
    }];
}


- (void)shareRoom:(UserID)uid roomUid:(UserID)roomUid platform:(SharePlatFormType)platform{
    //1、创建分享参数
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:roomUid];
    UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:uid];
    ShareSendInfo *info = [[ShareSendInfo alloc]init];
    info.uid = uid;
    info.targetNick = userInfo.nick.length > 0 ? userInfo.nick : @"";
    info.targetUid = roomUid;
    info.nick = myInfo.nick.length > 0 ? myInfo.nick : @"";
    
    Attachment *attachment = [[Attachment alloc]init];
    attachment.first = Custom_Noti_Header_Room_Tip;
    attachment.second = Custom_Noti_Header_Room_Tip_ShareRoom;
    attachment.data = info.encodeAttachemt;
    NSString *urlString;
    NSString * title;
    NSString * content;
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB ){
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].webHostName,@"ms/modules/shareRoom/index.html",uid,roomUid];
        title = [NSString stringWithFormat:@"%@，随意分享甜美声线!",MyAppName];
    }else if (projectType() == ProjectType_Haha){
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].webHostName,@"h5/modules/share/share-room.html",uid,roomUid];
        content = @"进入我的直播间，这里有你想要的一切！让我们一起飞上天空，一起深潜大海，一起哈哈哈哈哈哈哈哈！！";
        title = @"哈哈，为你带来惊喜与快乐~";
    }else if (projectType() == ProjectType_TuTu){
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].hostUrl,@"modules/share/share_room.html",uid,roomUid];
        content = [NSString stringWithFormat:@"%@的房间里有好听的声音有趣的灵魂，就差你啦！",userInfo.nick];
        title = @"兔兔，与喜欢的声音不期而遇!";
    }else if (projectType() == ProjectType_Pudding){
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].hostUrl,@"modules/share/share_room.html",uid,roomUid];
        content = [NSString stringWithFormat:@"%@的房间里有好听的声音有趣的灵魂，就差你啦！",userInfo.nick];
        title = @"兔兔玩友，与喜欢的声音不期而遇!";
    } else if (projectType() == ProjectType_LookingLove) {
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].hostUrl,@"modules/share/share_room.html",uid,roomUid];
        content = [NSString stringWithFormat:@"%@的房间里有好听的声音有趣的灵魂，就差你啦！",userInfo.nick];
        title = [NSString stringWithFormat:@"%@，与喜欢的声音不期而遇!", [XCKeyWordTool sharedInstance].myAppName];
        
    } else if (projectType() == ProjectType_Planet){
        urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&uid=%lld",[HostUrlManager shareInstance].hostUrl,@"modules/share/share_room.html",uid,roomUid];
        content = [NSString stringWithFormat:@"%@的房间里有好听的声音有趣的灵魂，就差你啦！",userInfo.nick];
        title = [NSString stringWithFormat:@"%@，与喜欢的声音不期而遇!", [XCKeyWordTool sharedInstance].myAppName];
    }
    
    
    NSString *imageURL = userInfo.avatar.length > 0 ? userInfo.avatar : @" ";
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (content.length == 0) {
        content = @" ";
    }
    [shareParams SSDKSetupShareParamsByText:content
     
                                     images:@[imageURL]
                                        url:[NSURL URLWithString:urlString]
                                      title:title
     
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    NSString *typeStr = [[NSString alloc]init];
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
        typeStr = @"1";
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
        typeStr = @"2";
    } else if (platform == Share_Platform_Type_Wechat_Circle) {
        type = SSDKPlatformSubTypeWechatTimeline;
        typeStr = @"3";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        type = SSDKPlatformSubTypeQZone;
        typeStr = @"4";
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [[BaiduMobStat defaultStat]logEvent:@"room_share_click" eventLabel:@"分享"];
                NSString *sessionId = [NSString stringWithFormat:@"%ld",GetCore(ImRoomCoreV2).currentRoomInfo.roomId];
                [GetCore(ImMessageCore)sendCustomMessageAttachement:attachment sessionId:sessionId type:NIMSessionTypeChatroom];
                
                [self postShareSuccessDataShareType:platform sharePageId:SharePageIdRoom targetUid:roomUid callBackLink:nil];
                NotifyCoreClient(ShareCoreClient, @selector(onShareRoomSuccess), onShareRoomSuccess);
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:nil topic:SocializationLog logLevel:XCLogLevelVerbose];
            }
                break;
            case SSDKResponseStateFail:
            {
                NotifyCoreClient(ShareCoreClient, @selector(onShareRoomFailth), onShareRoomFailth);
                
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:error topic:SocializationLog logLevel:XCLogLevelError];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)shareH5WithTitle:(NSString *)title url:(NSString *)url imgUrl:(NSString *)imgUrl desc:(NSString *)desc platform:(SharePlatFormType)platform {
    [self shareH5WithTitle:title url:url imgUrl:imgUrl desc:desc callBackLink:url platform:platform];
}


- (void)shareH5WithTitle:(NSString *)title url:(NSString *)url imgUrl:(NSString *)imgUrl desc:(NSString *)desc callBackLink:(NSString *)link platform:(SharePlatFormType)platform
{
    //1、创建分享参数
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (projectType() == ProjectType_TuTu) {
        if (imgUrl== nil || imgUrl.length ==0) {
            imgUrl = @"https://img.tutuyuyin.com/logo.png";
        }
    }else if (projectType() == ProjectType_Pudding) {
        if (imgUrl== nil || imgUrl.length ==0) {
            imgUrl = @"https://img.tutuyuyin.com/pudding_icon.png";
        }
    }else if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB){
        if (imgUrl== nil || imgUrl.length ==0) {
            imgUrl = @"https://img.letusmix.com/bb_logo.png";
        }
    }else if (projectType() == ProjectType_VKiss){
        if (imgUrl== nil || imgUrl.length ==0) {
            imgUrl = @"https://img.wduoo.com/FgJJs0g7kXeUSjDbfNoz4LN8v_L2?imageslim";
        }
        if (platform == Share_Platfrom_Type_Weibo) {
            desc = [desc stringByAppendingString:url];
        }
    } else if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
#warning todo
    }
    
  
    imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@" "withString:@""];  //去除中间空格
    [shareParams SSDKSetupShareParamsByText:desc.length > 0 ? desc : nil
                                     images:@[imgUrl]
                                        url:[NSURL URLWithString:url]
                                      title:title.length > 0 ? title : nil
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    NSString *typeStr = [[NSString alloc]init];
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
        typeStr = @"1";
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
        typeStr = @"2";
    } else if (platform == Share_Platform_Type_Wechat_Circle) {
        type = SSDKPlatformSubTypeWechatTimeline;
        typeStr = @"3";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        type = SSDKPlatformSubTypeQZone;
        typeStr = @"4";
    }else if (platform == Share_Platfrom_Type_Weibo) {
        type = SSDKPlatformTypeSinaWeibo;
        typeStr = @"5";
    }
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSString * drawStr;
                if (projectType() == ProjectType_TuTu || projectType() == ProjectType_Pudding || projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet){
                    drawStr= @"double12";
                }else if(projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB){
                    drawStr = @"ms/modules/userDraw";
                }else if(projectType() == ProjectType_Haha){
                    drawStr = @"modules/userDraw";
                }
                if (drawStr && [url containsString:drawStr]) {//drawStr先判断
                    [self postShareSuccessDataShareType:platform sharePageId:SharePageIdUserDraw targetUid:0 callBackLink:link];
                }else { //网页
                    [self postShareSuccessDataShareType:platform sharePageId:SharePageIdH5 targetUid:0 callBackLink:link];
                }
                NotifyCoreClient(ShareCoreClient, @selector(onShareH5Success), onShareH5Success);
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":typeStr,@"uid":[GetCore(AuthCore)getUid]} error:nil topic:SocializationLog logLevel:XCLogLevelVerbose];
            }
                break;
            case SSDKResponseStateFail:
            {
                NotifyCoreClient(ShareCoreClient, @selector(onShareH5Failth:), onShareH5Failth:error.description);
                
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:error topic:SocializationLog logLevel:XCLogLevelError];
            }
                break;
            default:
                break;
        }
    }];
}

/**
 分享小世界
 
 @param uid 本人uid
 @param worldInfo 小世界信息
 @param platform 分享平台
 */
- (void)shareLittleWorldWithUid:(UserID)uid worldInfo:(LittleWorldListItem *)worldInfo platform:(SharePlatFormType)platform {
    //1、创建分享参数
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@?shareUid=%lld&worksId=%@",[HostUrlManager shareInstance].webHostName,@"ms/modules/share/share-wx.html",uid,communityInfo.ID];
    
    NSString *title;
    
    if (worldInfo.inWorld) {
        [NSString stringWithFormat:@"作为%@的第%ld位成员，世界那么大，我想带你一起去看看~", worldInfo.name,worldInfo.currentMember.memberNo];
    } else {
        title = @"世界那么大，我想带你一起去看看~";
    }
    
    NSString *content = [NSString stringWithFormat: @"上%@，会玩的都在这", [XCKeyWordTool sharedInstance].myAppName];
    NSString *imageURL = worldInfo.icon.length > 0 ? worldInfo.icon : @" ";
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (content.length == 0) {
        content = @" ";
    }
    [shareParams SSDKSetupShareParamsByText:content
                                     images:@[imageURL]
                                        url:[NSURL URLWithString:@"www.baidu.com"]
                                      title:title
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    NSString *typeStr = [[NSString alloc]init];
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
        typeStr = @"1";
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
        typeStr = @"2";
    } else if (platform == Share_Platform_Type_Wechat_Circle) {
        type = SSDKPlatformSubTypeWechatTimeline;
        typeStr = @"3";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        type = SSDKPlatformSubTypeQZone;
        typeStr = @"4";
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self reportByPlatform:platform];
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:nil topic:SocializationLog logLevel:XCLogLevelVerbose];
            }
                break;
            case SSDKResponseStateFail:
            {
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:error topic:SocializationLog logLevel:XCLogLevelError];
            }
                break;
            default:
                break;
        }
    }];
}

/**
 此方法即将废弃
 */
- (void)shareApplicationWith:(CustomNotificationSubShare)shareType infor:(XCFamily *)familyinfor room:(RoomInfo *)roomInfor group:(GroupModel *)groupInfor andUserId:(UserID)uid andSessionId:(NSString *)sessionId andSessionType:(NIMSessionType)type and:(FamilyMemberPosition)position
{
    if (position == FamilyMemberPositionOwen && familyinfor) {
        [GetCore(FamilyCore) inviteUserEnterFamilyWithTargetId:sessionId];
    }else{
        XCApplicationSharement * shareMent = [[XCApplicationSharement alloc] init];
        shareMent.first = Custom_Noti_Header_InApp_Share;
        shareMent.second = shareType;
        NSString * title;
        NSString * avatar;
        NSString * actionName;
        NSString * routerValue;
        int routerType;
        UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:uid];
        avatar = myInfo.avatar;
        NSMutableDictionary * data = [NSMutableDictionary dictionary];
        if (shareType == Custom_Noti_Sub_Share_Room) {
            title = [NSString stringWithFormat:@"我想邀请你进入：%@，和大家一起愉快的玩耍~", roomInfor.title];
            routerType = P2PInteractive_SkipType_Room;
            actionName = @"立即进入";
            routerValue = [NSString stringWithFormat:@"%lld", roomInfor.uid];
            [data safeSetObject:roomInfor forKey:@"info"];
        }else if(shareType == Custom_Noti_Sub_Share_Group){
            routerType = P2PInteractive_SkipType_Group;
            title = [NSString stringWithFormat:@"我想邀请你加入群聊：%@的群，和大家一起在家族里玩耍~", groupInfor.name];
            actionName = @"立即加入";
            routerValue = [NSString stringWithFormat:@"%ld", groupInfor.tid];
            [data safeSetObject:groupInfor forKey:@"info"];
        }else{
            routerType = P2PInteractive_SkipType_Family;
            title = [NSString stringWithFormat:@"我想邀请你加入家族：%@的家族，和大家一起在家族里玩耍吧~", familyinfor.familyName];
            actionName = @"立即加入";
            XCFamily * family = [[XCFamily alloc] init];
            family.familyId = familyinfor.familyId;
            family.familyIcon = familyinfor.familyIcon;
            family.familyName = familyinfor.familyName;
            routerValue = familyinfor.familyId;
            routerValue = familyinfor.familyId;
            [data safeSetObject:family forKey:@"info"];
        }
        
        [data safeSetObject:title forKey:@"title"];
        [data safeSetObject:avatar forKey:@"avatar"];
        [data safeSetObject:actionName forKey:@"actionName"];
        [data safeSetObject:routerValue forKey:@"routerValue"];
        [data safeSetObject:@(routerType) forKey:@"routerType"];
        shareMent.data = data;
        [GetCore(ImMessageCore)sendCustomMessageAttachement:shareMent sessionId:sessionId type:type];
    }
}

/**
 应用内分享的新方法 请使用这个方法
 shareInfor
 1.分享房间的时候
 2.分享家族
 3.分享群
 4.家族族长邀请好友
 5.萌声社区分享
 */
- (void)shareAppliactionWith:(ShareModelInfor *)shareInfor{
    //族长邀请的
    if (shareInfor.memberType == FamilyMemberPositionOwen && shareInfor.familyInfor) {
        [GetCore(FamilyCore) inviteUserEnterFamilyWithTargetId:shareInfor.sessionId];
    }else{
        XCApplicationSharement * shareMent = [[XCApplicationSharement alloc] init];
        shareMent.first = Custom_Noti_Header_InApp_Share;
        shareMent.second = shareInfor.shareType;
        NSString * title;
        NSString * avatar;
        NSString * actionName;
        NSString * routerValue;
        int routerType;
        UserInfo *myInfo = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
        avatar = myInfo.avatar;
        NSMutableDictionary * data = [NSMutableDictionary dictionary];
        //分享房间
        if (shareInfor.shareType == Custom_Noti_Sub_Share_Room) {
            title = [NSString stringWithFormat:@"我想邀请你进入：%@，和大家一起愉快的玩耍~", shareInfor.roomInfor.title];
            routerType = P2PInteractive_SkipType_Room;
            actionName = @"立即进入";
            routerValue = [NSString stringWithFormat:@"%lld", shareInfor.roomInfor.uid];
            [data safeSetObject:shareInfor.roomInfor forKey:@"info"];
        }else if(shareInfor.shareType == Custom_Noti_Sub_Share_Group){//分享房间
            routerType = P2PInteractive_SkipType_Group;
            title = [NSString stringWithFormat:@"我想邀请你加入群聊：%@的群，和大家一起在家族里玩耍~", shareInfor.grupInfor.name];
            actionName = @"立即加入";
            routerValue = [NSString stringWithFormat:@"%ld",shareInfor.grupInfor.tid];
            [data safeSetObject:shareInfor.grupInfor forKey:@"info"];
        }else if (shareInfor.shareType == Custom_Noti_Sub_Share_Commnunity){
            routerType = P2PInteractive_SkipType_Community_Share;
            title = @"我给你分享了一段好声音";
            actionName = @"立即进入";
            routerValue = [NSString stringWithFormat:@"%@",shareInfor.communityInfo.ID];
            [data safeSetObject:shareInfor.communityInfo forKey:@"info"];
            [[BaiduMobStat defaultStat] logEvent:@"share_cutefriend" eventLabel:@"分享到站内好友"];
        } else if (shareInfor.shareType == Custom_Noti_Sub_Share_LittleWorld) {
            if (shareInfor.worldletInfor.inWorld) {
              NSString * name  = [NSString stringWithFormat:@"\"%@\"",shareInfor.worldletInfor.name];
                title = [NSString stringWithFormat:@"作为%@的第%ld位成员，偷偷邀请你加入，世界那么大，我想带你一起去看看~", name,shareInfor.worldletInfor.currentMember.memberNo];
            } else {
                title = @"世界那么大，我想带你一起去看看~";
            }
            LittleWorldListItem * worldItem = shareInfor.worldletInfor;
            NSMutableDictionary * worldDic = [[worldItem model2dictionary] mutableCopy];
            [worldDic removeObjectForKey:@"members"];
            [data safeSetObject:worldDic forKey:@"info"];
            routerValue = [NSString stringWithFormat:@"%@", shareInfor.worldletInfor.worldId];
            routerType = P2PInteractive_SkipType_LittleWorldGuestPage;
            actionName = @"立即进入";
            
        }else if (shareInfor.shareType == Custom_Noti_Sub_Dynamic_ShareDynamic) {
            
            ShareDynamicInfo *model = shareInfor.dynamicInfo;
            if (model.content.length == 0) {
                model.content = @"再不跟我一起来，前排的瓜子都要卖完啦";
            }

            shareMent.first = Custom_Noti_Header_Dynamic;
            routerType = P2PInteractive_SkipType_CustomMessageDynamicDetail;
            routerValue = model.worldID;
            
            if (model.nick.length > 4) {
                model.nick = [model.nick substringToIndex:2];
                model.nick = [model.nick stringByAppendingString:@"..."];
            }
            
            title = [NSString stringWithFormat:@"%@ 发布了一条新动态，快来围观", model.nick];
            avatar = model.iconUrl;
            
            [data safeSetObject:model.content forKey:@"content"];
            [data safeSetObject:model.dynamicID forKey:@"dynamicId"];
            
        } else {
            routerType = P2PInteractive_SkipType_Family;
            XCFamily * familyinfor = shareInfor.familyInfor;
            title = [NSString stringWithFormat:@"我想邀请你加入家族：%@的家族，和大家一起在家族里玩耍吧~", shareInfor.familyInfor.familyName];
            actionName = @"立即加入";
            XCFamily * family = [[XCFamily alloc] init];
            family.familyId = familyinfor.familyId;
            family.familyIcon = familyinfor.familyIcon;
            family.familyName = familyinfor.familyName;
            routerValue = familyinfor.familyId;
            [data safeSetObject:family forKey:@"info"];
        }
        
        [data safeSetObject:title forKey:@"title"];
        [data safeSetObject:avatar forKey:@"avatar"];
        [data safeSetObject:actionName forKey:@"actionName"];
        [data safeSetObject:routerValue forKey:@"routerValue"];
        [data safeSetObject:@(routerType) forKey:@"routerType"];
        shareMent.data = data;
        [GetCore(ImMessageCore) sendCustomMessageAttachement:shareMent sessionId:shareInfor.sessionId type:shareInfor.sesstionType];
    }
}


- (void)shareText:(NSString *)text platform:(SharePlatFormType)platform {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:text
                                images:nil
                                   url:nil
                                 title:nil
                                  type:SSDKContentTypeText];
    
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
    }
    
    [ShareSDK share:type parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
    }];
}

- (void)shareDynamicH5WithNick:(NSString *)nick
                   dynamicText:(NSString *)dynamicText
                   dynamicIcon:(NSString *)dynamicIcon
                      shareUrl:(NSString *)shareUrl
                      platform:(SharePlatFormType)platform {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];


    NSString *title = [NSString stringWithFormat:@"%@ 发布了一条新动态", nick];
    
    [shareParams SSDKSetupShareParamsByText:!dynamicText ? @"点击查看动态详情" : dynamicText
                                     images:dynamicIcon
                                        url:[NSURL URLWithString:shareUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
         type = SSDKPlatformTypeWechat;
     } else if (platform == Share_Platform_Type_QQ){
         type = SSDKPlatformTypeQQ;
     } else if (platform == Share_Platform_Type_Wechat_Circle) {
         type = SSDKPlatformSubTypeWechatTimeline;
     } else if (platform == Share_Platform_Type_QQ_Zone) {
         type = SSDKPlatformSubTypeQZone;
     }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                // 分享成功后统计到服务器
                [GetCore(LittleWorldCore) requestWorldShareDynamicWithWorldId:self.shareModel.dynamicInfo.worldID
                                                                    dynamicID:self.shareModel.dynamicInfo.dynamicID.integerValue
                                                                          uid:self.shareModel.dynamicInfo.shareUid];
                
                [XCHUDTool showSuccessWithMessage:@"分享成功"];
            }
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败");
            }
                break;
            case SSDKResponseStateCancel:
            {
                NSLog(@"分享取消");
            }
                break;
            default:
                break;
        }
    }];
    
}
#pragma mark - private method

- (void)reportByPlatform:(SharePlatFormType)platform{
    NSString *eventID = nil;
    NSString *eventLabel = nil;
    if (platform == Share_Platform_Type_Wechat) {
        eventID = @"share_WeChat";
        eventLabel = @"分享到微信";
    } else if (platform == Share_Platform_Type_Wechat_Circle){
        eventID = @"share_friendscircle";
        eventLabel = @"分享到朋友圈";
    } else if (platform == Share_Platform_Type_QQ) {
        eventID = @"share_QQ";
        eventLabel = @"分享到QQ好友";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        eventID = @"share_QZone";
        eventLabel = @"分享到QQ空间";
    }
    
    [[BaiduMobStat defaultStat] logEvent:eventID eventLabel:eventLabel];
}

- (void)initSdk
{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:keyWithType(KeyType_QQAppid, NO)
                                     appkey:keyWithType(KeyType_QQSecret, NO)
                        enableUniversalLink:YES
                              universalLink:keyWithType(KeyType_QQUniversalLink, NO)];
        
        //微信
        NSString *universalLink = [NSString stringWithFormat:@"%@/",keyWithType(KeyType_BaseURL, NO)];
        [platformsRegister setupWeChatWithAppId:keyWithType(KeyType_WechatAppid, NO)
                                      appSecret:keyWithType(KeyType_WechatSecret, NO)
                                  universalLink:universalLink];
    }];
}




/**
 分享成功后调用
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param sharePageId 分享页面，1 直播间，2 H5 3 888 转盘抽奖
 @param targetUid 如果被分享房间，传被分享房间UID
 */
- (void)postShareSuccessDataShareType:(NSInteger)shareType sharePageId:(SharePageId)sharePageId targetUid:(NSInteger)targetUid callBackLink:(NSString *)link{
    
    [HttpRequestHelper postShareSuccessWithShareType:shareType sharePageId:sharePageId targetUid:targetUid shareUrl:link success:^(NSString *packetNum) {
        NotifyCoreClient(ShareCoreClient, @selector(postShareSuccessNetworkSuccessDataShareType:sharePageId:targetUid:), postShareSuccessNetworkSuccessDataShareType:shareType sharePageId:sharePageId targetUid:targetUid);
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}


/**
 分享社区作品成功后调用
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param worksId 社区的作品id
 */
- (void)shareCommunitySuccessWithShareType:(NSInteger)shareType worksId:(NSString *)worksId {
    [HttpRequestHelper postShareSuccessWithShareType:shareType worksId:worksId success:^(NSString *packetNum) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
}

- (void)shareImage:(UIImage *)image platform:(SharePlatFormType)platform {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:@[image]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    NSString *typeStr = [[NSString alloc]init];
    SSDKPlatformType type = 0;
    if (platform == Share_Platform_Type_Wechat) {
        type = SSDKPlatformTypeWechat;
        typeStr = @"1";
    } else if (platform == Share_Platform_Type_QQ){
        type = SSDKPlatformTypeQQ;
        typeStr = @"2";
    } else if (platform == Share_Platform_Type_Wechat_Circle) {
        type = SSDKPlatformSubTypeWechatTimeline;
        typeStr = @"3";
    } else if (platform == Share_Platform_Type_QQ_Zone) {
        type = SSDKPlatformSubTypeQZone;
        typeStr = @"4";
    }else if (platform == Share_Platfrom_Type_Weibo) {
        type = SSDKPlatformTypeSinaWeibo;
        typeStr = @"5";
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NotifyCoreClient(ShareCoreClient, @selector(onShareImageSuccess), onShareImageSuccess);
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":typeStr,@"uid":[GetCore(AuthCore)getUid]} error:nil topic:SocializationLog logLevel:XCLogLevelVerbose];
            }
                break;
            case SSDKResponseStateFail:
            {
                NotifyCoreClient(ShareCoreClient, @selector(onShareImageFailure:), onShareImageFailure:error.description);
                
                [[XCLogger shareXClogger]sendLog:@{EVENT_ID:CShareLog,@"type":[NSString stringWithFormat:@"%d",(int)type],@"uid":[GetCore(AuthCore)getUid]} error:error topic:SocializationLog logLevel:XCLogLevelError];
            }
                break;
            default:
                break;
        }
    }];
}

@end
