//
//  TTCheckinViewController+Share.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinViewController+Share.h"
#import "TTCheckinShareContentView.h"

#import "XCShareView.h"
#import "TTPopup.h"
#import "XCMacros.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "CheckinCore.h"
#import "ShareCore.h"

@implementation TTCheckinViewController (Share)

/**
 分享签到图片
 */
- (void)shareCheckinImage {
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];
    
    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];
    NSArray *itmes = @[momentItem, weChatItem, qqZoneItem, qqItem];
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:itmes itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    shareView.delegate = self;
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = shareView;
    service.style = TTPopupStyleActionSheet;
    
    [TTPopup popupWithConfig:service];
}

#pragma mark - XCShareViewDelegate
- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag {
    
    [TTPopup dismiss];
    
    SharePlatFormType platform;
    switch (itemTag) {
        case XCShareItemTagAppFriends:
            platform = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            platform = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            platform = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            platform = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            platform = Share_Platform_Type_QQ;
            break;
        default:
            platform = Share_Platform_Type_Wechat_Circle;
            break;
    }
    
    if (self.shareImageURL == nil) {
        return;
    }
    
    [GetCore(ShareCore) shareH5WithTitle:nil url:nil imgUrl:self.shareImageURL desc:nil platform:platform];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}

#pragma mark - ShareCoreClient
- (void)onShareH5Success {
    [GetCore(CheckinCore) requestCheckinShare];
    
    if (self.isReplenishShare) {
        self.isReplenishShare = NO;
        [GetCore(CheckinCore) requestCheckinReplenishWithSignDay:self.replenishSignDay];
    }
}

@end
