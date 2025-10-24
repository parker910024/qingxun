//
//  TTGameRoomViewController+RoomShare.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+RoomShare.h"
#import "TTGameRoomViewController+FunctionMenu.h"
#import "TTGameRoomViewController+Private.h"

#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "TTGameStaticTypeCore.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTStatisticsService.h"
#import "TTPopup.h"

@implementation TTGameRoomViewController (RoomShare)


#pragma mark - XCShareViewDelegate
- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag{
    
    [TTPopup dismiss];
    [self updateFunctionMenu];
    
    SharePlatFormType sharePlatFormType;

    switch (itemTag) {
        case XCShareItemTagAppFriends:
            sharePlatFormType = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            sharePlatFormType = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            sharePlatFormType = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            sharePlatFormType = Share_Platform_Type_QQ;
            break;
        default:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
    }
    [self handleShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView{
    [TTPopup dismiss];
    [self updateFunctionMenu];
}

#pragma mark - puble method
- (void)ttShowRoomShareView{
    if (self.roomInfo.type == RoomType_CP) { // CP房和普通房区分开
        [TTStatisticsService trackEvent:@"roomcp_share_click" eventDescribe:@"CP房-分享房间"];
    } else {
        [TTStatisticsService trackEvent:[self roomFullTrackName:TTStatisticsServiceRoomShareClick] eventDescribe:@"分享房间"];
    }
    
//    [self.functionMenuView removeFromSuperview];

    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    shareView.delegate = self;
    
    @weakify(self)
    
    TTPopupConfig *config = [[TTPopupConfig alloc] init];
    config.contentView = shareView;
    config.style = TTPopupStyleActionSheet;
    config.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        @strongify(self)
        [self updateFunctionMenu];
    };
    
    [TTPopup popupWithConfig:config];
}

#pragma mark - private method
- (void)handleShare:(SharePlatFormType)platform{
    if (platform == Share_Platfrom_Type_Within_Application) {
        ShareModelInfor * model = [[ShareModelInfor alloc] init];
        model.currentVC = self;
        model.roomInfor = self.roomInfo;
        model.shareType = Custom_Noti_Sub_Share_Room;
        [GetCore(ShareCore) reloadShareModel:model];
        GetCore(TTGameStaticTypeCore).shareRoomOrInviteType = TTShareRoomOrInviteFriendStatus_Share;
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
        [GetCore(ShareCore)shareRoom:uid roomUid:self.roomInfo.uid platform:platform];
    }
    
}

- (NSArray<XCShareItem *>*)getShareItems{
    
    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];
    
    XCShareItem *tutuItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:NO];
    
    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];
    
    return @[tutuItem,momentItem,weChatItem,qqZoneItem,qqItem];
}

@end
