//
//  TTUserCardFunctionItemConfig.m
//  TuTu
//
//  Created by 卫明 on 2018/11/19.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatUserCardFunctionItemConfig.h"

//tool
#import "XCCurrentVCStackManager.h"

//core
#import "AuthCore.h"
#import "PraiseCore.h"
#import "RoomCoreV2.h"
#import "GiftCore.h"
#import "RoomQueueCoreV2.h"
#import "FaceCore.h"
#import "ImRoomCoreV2.h"
#import "ImPublicChatroomCore.h"

//toast
#import "XCHUDTool.h"

//view
#import "TTSendGiftView.h"

//bridge
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

//vc
#import "TTPublicNIMChatroomController.h"
#import "TTRoomDisableViewController.h"
#import "TTPublicDisableView.h"


#import "TTPopup.h"

@implementation TTPublicChatUserCardFunctionItemConfig

+ (NSMutableArray<TTUserCardFunctionItem *> *)getFunctionItemsInPublicChatRoomWithUid:(UserID)uid {
    NSMutableArray *items = [NSMutableArray array];
    
    TTUserCardFunctionItem *item = [[TTUserCardFunctionItem alloc]init];
    item.normalTitle = @"主页";
    item.actionId = uid;
    item.isDisable = NO;
    item.type = TTUserCardFunctionItemType_PersonPage;
    [item setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
        
        [TTPopup dismiss];
        
        UIViewController *personalVC = [[XCMediator sharedInstance]ttPersonalModule_personalViewController:uid];
        [[[XCCurrentVCStackManager shareManager]currentNavigationController] pushViewController:personalVC animated:YES];
    }];
    [items addObject:item];
    return items;
}

+ (RACSignal *)getCenterFunctionItemsInPublicChatRoomWithUid:(UserID)uid vc:(TTPublicNIMChatroomController *)vc {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (uid == [GetCore(AuthCore) getUid].userIDValue) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }
        NSMutableArray *items = [NSMutableArray array];
        
        TTUserCardFunctionItem *gift = [[TTUserCardFunctionItem alloc]init];
        gift.normalIcon = [UIImage imageNamed:@"usercard_sendgift_enable_icon"];
        gift.normalTitle = @"送礼物";
        gift.disableIcon = [UIImage imageNamed:@"usercard_sendgift_disable_icon"];
        gift.disableTitle = @"送礼物";
        [gift setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
            
            [TTPopup dismiss];

            TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_PublcChat roomUid:0];
            UserInfo *userInfo = [[UserInfo alloc] init];
            userInfo.uid = uid;
            giftView.targetInfo = userInfo;
            giftView.delegate = vc;
            giftView.sessionId = vc.session.sessionId;
            TTPopupConfig *config = [[TTPopupConfig alloc] init];
            config.contentView = giftView;
            config.style = TTPopupStyleActionSheet;
            
            [TTPopup popupWithConfig:config];
            
        }];
        gift.type = TTUserCardFunctionItemType_SendGift;
        gift.isDisable = NO;
        [items addObject:gift];
        
        TTUserCardFunctionItem *message = [[TTUserCardFunctionItem alloc]init];
        message.normalIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        message.normalTitle = @"私聊";
        message.disableIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        message.disableTitle = @"私聊";
        message.type = TTUserCardFunctionItemType_RoomChat;
        message.isDisable = NO;
        [items addObject:message];
        
        
        TTUserCardFunctionItem *dress = [[TTUserCardFunctionItem alloc]init];
        dress.normalIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
        dress.normalTitle = @"送装扮";
        dress.disableIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
        dress.disableTitle = @"送装扮";
        [dress setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
            
            [TTPopup dismiss];
            
            UIViewController *vc = [[XCMediator sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:uid index:0];
            [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
        }];
        dress.type = TTUserCardFunctionItemType_SendDress;
        dress.isDisable = NO;
        [items addObject:dress];
        
        
        TTUserCardFunctionItem *find = [[TTUserCardFunctionItem alloc]init];
        find.normalIcon = [UIImage imageNamed:@"usercard_find_enable_icon"];
        find.normalTitle = @"踩Ta";
        find.disableIcon = [UIImage imageNamed:@"usercard_find_enable_icon"];
        find.disableTitle = @"踩Ta";
        [find setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
            [[GetCore(RoomCoreV2)rac_getUserInterRoomInfo:uid]subscribeNext:^(id x) {
                if (x) {
                    [TTPopup dismiss];
                    RoomInfo *room = (RoomInfo *)x;
                    if (room.uid <= 0) {
                        [XCHUDTool showErrorWithMessage:@"该用户不在房间噢"];
                        return;
                    }
                    [[XCMediator sharedInstance]ttRoomMoudle_presentRoomViewControllerWithRoomUid:room.uid];
                }else {
                    [XCHUDTool showErrorWithMessage:@"用户不在房间噢～"];
                }
            }];
        }];
        find.type = TTUserCardFunctionItemType_Find;
        find.isDisable = NO;
        [items addObject:find];
        
        [[GetCore(ImPublicChatroomCore) rac_queryPublicChartRoomMemberByUid:GetCore(AuthCore).getUid] subscribeNext:^(id x) {
            
            NIMChatroomMember *targetMember  = (NIMChatroomMember *)x;
            
            if (targetMember.type == NIMChatroomMemberTypeManager) {
                //禁言
                TTUserCardFunctionItem *disableItem = [[TTUserCardFunctionItem alloc] init];
                disableItem.isDisable = NO;
                disableItem.normalIcon = [UIImage imageNamed:@"usercard_disableTalk_icon"];
                disableItem.normalTitle = @"禁言";
                [disableItem setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                    
                    [[BaiduMobStat defaultStat] logEvent:@"public_chat_banword" eventLabel:@"公聊大厅-资料卡禁言操作"];
#ifdef DEBUG
                    NSLog(@"public_chat_banword");
#else
                    
#endif
                    [TTPopup dismiss];
                    
                    TTPublicDisableView *disableView = [[TTPublicDisableView alloc] initWithFrame:CGRectZero withUserID:uid];

                    [TTPopup popupView:disableView style:TTPopupStyleAlert];
                }];
                disableItem.type = TTUserCardFunctionItemType_DisableSendMsg;
                [items addObject:disableItem];
            }
        }];
        
        @weakify(items);
        [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
            BOOL isLike = [x boolValue];
            @strongify(items);
            __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
            foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
            foucus.normalTitle = @"关注Ta";
            foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
            foucus.disableTitle = @"取消关注";
            foucus.isDisable = isLike;
            [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                if (item.isDisable) { //没关注
                    [[GetCore(PraiseCore)rac_cancel:[GetCore(AuthCore)getUid].userIDValue beCanceledUid:uid]subscribeCompleted:^{
                        item.isDisable = !item.isDisable;
                    }];
                }else {//已经关注
                    [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                        item.isDisable = !item.isDisable;
                    }];
                }
            }];
            foucus.type = TTUserCardFunctionItemType_Foucs;
            [items insertObject:foucus atIndex:3];
           
            [subscriber sendNext:items];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendNext:items];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


+ (RACSignal *)getCenterFunctionItemsInLittleWorldTeamWithUid:(UserID)uid vc:(TTLittleWorldSessionViewController *)vc {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (uid == [GetCore(AuthCore) getUid].userIDValue) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }
        NSMutableArray *items = [NSMutableArray array];
        
        TTUserCardFunctionItem *gift = [[TTUserCardFunctionItem alloc]init];
        gift.normalIcon = [UIImage imageNamed:@"usercard_sendgift_enable_icon"];
        gift.normalTitle = @"送礼物";
        gift.disableIcon = [UIImage imageNamed:@"usercard_sendgift_disable_icon"];
        gift.disableTitle = @"送礼物";
        [gift setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
            
            [TTPopup dismiss];
            
            TTSendGiftView *giftView = [[TTSendGiftView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) usingPlace:XCSendGiftViewUsingPlace_Team roomUid:0];
            UserInfo *userInfo = [[UserInfo alloc] init];
            userInfo.uid = uid;
            giftView.targetInfo = userInfo;
            giftView.delegate = vc;
            giftView.sessionId = vc.session.sessionId;
            
            TTPopupConfig *config = [[TTPopupConfig alloc] init];
            config.contentView = giftView;
            config.style = TTPopupStyleActionSheet;
            
            [TTPopup popupWithConfig:config];
            
        }];
        gift.type = TTUserCardFunctionItemType_SendGift;
        gift.isDisable = NO;
        [items addObject:gift];
        
        TTUserCardFunctionItem *message = [[TTUserCardFunctionItem alloc]init];
        message.normalIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        message.normalTitle = @"私聊";
        message.disableIcon = [UIImage imageNamed:@"usercard_roomchat_enable_icon"];
        message.disableTitle = @"私聊";
        message.type = TTUserCardFunctionItemType_RoomChat;
        message.isDisable = NO;
        [items addObject:message];
        
        
        TTUserCardFunctionItem *dress = [[TTUserCardFunctionItem alloc]init];
        dress.normalIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
        dress.normalTitle = @"送装扮";
        dress.disableIcon = [UIImage imageNamed:@"usercard_sendDress_enable_icon"];
        dress.disableTitle = @"送装扮";
        [dress setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
            
            [TTPopup dismiss];
            
            UIViewController *vc = [[XCMediator sharedInstance]ttPersonalModule_DressUpShopViewControllerWithUid:uid index:0];
            [[[XCCurrentVCStackManager shareManager]currentNavigationController]pushViewController:vc animated:YES];
        }];
        dress.type = TTUserCardFunctionItemType_SendDress;
        dress.isDisable = NO;
        [items addObject:dress];
        
        
        TTUserCardFunctionItem *find = [[TTUserCardFunctionItem alloc]init];
        find.normalIcon = [UIImage imageNamed:@"usercard_find_enable_icon"];
        find.normalTitle = @"踩Ta";
        find.disableIcon = [UIImage imageNamed:@"usercard_find_enable_icon"];
        find.disableTitle = @"踩Ta";
        [find setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
             [TTPopup dismiss];
            [[GetCore(RoomCoreV2)rac_getUserInterRoomInfo:uid]subscribeNext:^(id x) {
                if (x) {
                    RoomInfo *room = (RoomInfo *)x;
                    if (room.uid <= 0) {
                        [XCHUDTool showErrorWithMessage:@"该用户不在房间噢"];
                        return;
                    }
                    [[XCMediator sharedInstance]ttRoomMoudle_presentRoomViewControllerWithRoomUid:room.uid];
                }else {
                    [XCHUDTool showErrorWithMessage:@"用户不在房间噢～"];
                }
            }];
        }];
        find.type = TTUserCardFunctionItemType_Find;
        find.isDisable = NO;
        [items addObject:find];
    
        
        @weakify(items);
        [[GetCore(PraiseCore)rac_queryIsLike:[GetCore(AuthCore)getUid].userIDValue isLikeUid:uid]subscribeNext:^(id x) {
            BOOL isLike = [x boolValue];
            @strongify(items);
            __block TTUserCardFunctionItem *foucus = [[TTUserCardFunctionItem alloc]init];
            foucus.normalIcon = [UIImage imageNamed:@"usercard_focus_enable_icon"];
            foucus.normalTitle = @"关注Ta";
            foucus.disableIcon = [UIImage imageNamed:@"usercard_focus_disable_icon"];
            foucus.disableTitle = @"取消关注";
            foucus.isDisable = isLike;
            [foucus setActionBolock:^(UserID uid, NSIndexPath *indexPath, TTUserCardFunctionItem *item) {
                if (item.isDisable) { //没关注
                    [[GetCore(PraiseCore)rac_cancel:[GetCore(AuthCore)getUid].userIDValue beCanceledUid:uid]subscribeCompleted:^{
                        item.isDisable = !item.isDisable;
                    }];
                }else {//已经关注
                    [[GetCore(PraiseCore)rac_praise:[GetCore(AuthCore)getUid].userIDValue WithBePraisedUid:uid]subscribeCompleted:^{
                        item.isDisable = !item.isDisable;
                    }];
                }
            }];
            foucus.type = TTUserCardFunctionItemType_Foucs;
            [items insertObject:foucus atIndex:3];
            
            [subscriber sendNext:items];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendNext:items];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
