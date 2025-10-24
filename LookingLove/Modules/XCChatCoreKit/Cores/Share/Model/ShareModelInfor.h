//
//  ShareModelInfor.h
//  BberryCore
//
//  Created by gzlx on 2018/6/21.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "XCFamily.h"
#import "RoomInfo.h"
#import "GroupModel.h"
#import "Attachment.h"
#import "FamilyCore.h"
#import "CommunityInfo.h"
#import "LittleWorldListModel.h"
#import "CTDynamicModel.h"
#import "ShareDynamicInfo.h"

@interface ShareModelInfor : BaseObject
/** 社区作品 */
@property (strong , nonatomic) CommunityInfo *communityInfo;
/** 分享家族信息*/
@property (nonatomic, strong) XCFamily * familyInfor;
/** 分享房间*/
@property (nonatomic, strong) RoomInfo * roomInfor;
/** 分享群组*/
@property (nonatomic, strong) GroupModel * grupInfor;
/** 分享小世界 */
@property (nonatomic, strong) LittleWorldListItem *worldletInfor;
/// 小世界动态
@property (nonatomic, strong) CTDynamicModel *dynamicModel;
@property (nonatomic, strong) ShareDynamicInfo *dynamicInfo;
/** 当前的控制器*/
@property (nonatomic, strong) UIViewController * currentVC;
/** 分享的类型*/
@property (nonatomic, assign) CustomNotificationSubShare shareType;
/** 分享家族的时候 是族长或者成员*/
@property (nonatomic, assign) FamilyMemberPosition  memberType;
/**族长邀请 族员分享*/
@property (nonatomic, assign) XCShare_Type Type;//是分享还是邀请
/** 分享到回话的 id*/
@property (nonatomic, strong) NSString * sessionId;
/** 分享到 p2p 还是群组*/
@property (nonatomic, assign) NIMSessionType sesstionType;



@end
