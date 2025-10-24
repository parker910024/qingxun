//
//  ShareCore.h
//  BberryCore
//
//  Created by chenran on 2017/7/6.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import <ShareSDK/ShareSDK.h>
#import "P2PInteractiveAttachment.h"
#import "XCFamily.h"
#import "GroupModel.h"
#import "RoomInfo.h"
#import "ShareModelInfor.h"
#import "CommunityInfo.h"
#import "LittleWorldListModel.h"
typedef enum {
    Share_Platform_Type_Wechat = 1,//微信
    Share_Platform_Type_QQ = 2,//QQ
    Share_Platform_Type_Wechat_Circle = 3,//微信朋友圈
    Share_Platform_Type_QQ_Zone = 4,//QQ空间
    Share_Platfrom_Type_Within_Application = 5,//应用内分享
    Share_Platfrom_Type_Weibo = 6//微博
}SharePlatFormType;

@class Attachment;

@interface ShareCore : BaseCore

@property (nonatomic, strong) ShareModelInfor * shareModel;


/**
 分享社区作品成功后调用
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间 5应用内 6微博
 @param worksId 社区的作品id
 */
- (void)shareCommunitySuccessWithShareType:(NSInteger)shareType worksId:(NSString *)worksId;

//分享所需要的model
- (ShareModelInfor *)getShareModel;
- (void)reloadShareModel:(ShareModelInfor *)model;


- (void)shareRoom:(UserID)uid roomUid:(UserID)roomUid platform:(SharePlatFormType)platform;

- (void)shareH5WithTitle:(NSString *)title url:(NSString *)url imgUrl:(NSString *)imgUrl desc:(NSString *)desc callBackLink:(NSString *)link platform:(SharePlatFormType)platform;

- (void)shareH5WithTitle:(NSString *)title url:(NSString *)url imgUrl:(NSString *)imgUrl desc:(NSString *)desc platform:(SharePlatFormType)platform;


/**
 分享小世界

 @param uid 本人uid
 @param worldInfo 小世界信息
 @param platform 分享平台
 */
- (void)shareLittleWorldWithUid:(UserID)uid worldInfo:(LittleWorldListItem *)worldInfo platform:(SharePlatFormType)platform;
/**
 分享社区
 
 @param uid 分享的用户
 @param communityInfo 社区作品
 @param platform 分享的平台
 */
- (void)shareCommnuityUid:(UserID)uid communityInfo:(CommunityInfo *)communityInfo platform:(SharePlatFormType)platform;
/**
 应用内分享
 @param shareType 分享的类型
 @param familyinfor  家族信息
 @param roomInfor 房间信息
 @param groupInfor  群信息
 此方法已经废弃 分享请使用新的方法
 */
- (void)shareApplicationWith:(CustomNotificationSubShare)shareType infor:(XCFamily *)familyinfor room:(RoomInfo *)roomInfor group:(GroupModel *)groupInfor andUserId:(UserID)uid andSessionId:(NSString *)sessionId andSessionType:(NIMSessionType)type and:(FamilyMemberPosition)position;

/**
 应用内分享的新方法 请使用这个方法
 shareInfor
 1.分享房间的时候
 2.分享家族
 3.分享群
 4.家族族长邀请好友
 5.萌声社区分享
 */
- (void)shareAppliactionWith:(ShareModelInfor *)shareInfor;


- (void)shareDynamicH5WithNick:(NSString *)nick
                   dynamicText:(NSString *)dynamicText
                   dynamicIcon:(NSString *)dynamicIcon
                      shareUrl:(NSString *)shareUrl
                      platform:(SharePlatFormType)platform;
/**
 分享成功后调用
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param sharePageId 分享页面，1直播间，2H5
 @param targetUid 如果被分享房间，传被分享房间UID
 */
- (void)postShareSuccessDataShareType:(NSInteger)shareType
                          sharePageId:(NSInteger)sharePageId
                            targetUid:(NSInteger)targetUid;

- (void)shareText:(NSString *)text platform:(SharePlatFormType)platform;

/**
 分享图片至第三方平台（应用内分享未实现）

 @param image 图片
 @param platform 平台类型
 */
- (void)shareImage:(UIImage *)image platform:(SharePlatFormType)platform;

- (BOOL)isInstallWechat;
- (BOOL)isInstallQQ;
- (BOOL)isInstallWeibo;
@end
