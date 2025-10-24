//
//  TTGameRoomViewController+MentoringShip.m
//  TTPlay
//
//  Created by gzlx on 2019/2/18.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+MentoringShip.h"
#import "TTGameRoomViewController+Private.h"

#import "MentoringShipCore.h"
#import "ImMessageCore.h"
#import "MentoringInviteModel.h"

#import "XCCurrentVCStackManager.h"
#import "XCMediator+TTMessageMoudleBridge.h"


@implementation TTGameRoomViewController (MentoringShip)

/**师傅给徒弟发送邀请的链接 */
- (void)masterSendInviteToApprentice{
    //邀请进房判断师徒任务是否有效
    if (GetCore(MentoringShipCore).masterUid && GetCore(MentoringShipCore).inviteApprenticeUid) {
        if (GetCore(MentoringShipCore).masterUid == GetCore(AuthCore).getUid.userIDValue) {
            [self mastetInviteApprentice];
        }
    }
}

- (void)mastetInviteApprentice{
    UserInfo * userInfor = [GetCore(UserCore) getUserInfoInDB:GetCore(MentoringShipCore).masterUid];
    MentoringInviteModel * inviteModel = [[MentoringInviteModel alloc] init];
    inviteModel.avatar = self.roomInfo.avatar;
    inviteModel.nick = userInfor.nick;
    inviteModel.roomUid = self.roomInfo.uid;
    inviteModel.apprenticeUid =GetCore(MentoringShipCore).inviteApprenticeUid;
    inviteModel.masterUid = self.roomInfo.uid;
    inviteModel.expired = YES;
    
    Attachment * attach = [[Attachment alloc] init];
    attach.first = Custom_Noti_Header_Mentoring_RelationShip;
    attach.second =  Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite;
    attach.data = [inviteModel model2dictionary];
    
    [GetCore(ImMessageCore)sendCustomMessageAttachement:attach sessionId:[NSString stringWithFormat:@"%lld", GetCore(MentoringShipCore).inviteApprenticeUid] type:NIMSessionTypeP2P];
}

- (void)onLogout{
    //退出登录的时候 需要把这个东西 值为默认 不然一个徒弟进房任务完成的时候 直接在登录一个师傅的号 就会显示去免费送花 author fengshuo
    GetCore(MentoringShipCore).countDownStatus = TTMasterCountDownStatusDefult;
}


#pragma mark - TTMasterTimeViewDelegate
- (void)masterTimeView:(TTMasterTimeView *)view didClickTimeView:(UIView *)timeView {
    // 最小化 返回聊天页面
    @KWeakify(self);
     [[TTRoomModuleCenter defaultCenter] dismissChannelViewWithQuitCurrentRoom:NO
                                                                     animation:YES completion:^{
                                                                         @KStrongify(self);
                                                                         [self gotoMentoringShipSessiontionView];
                                                                     }];
}

- (void)gotoMentoringShipSessiontionView {
    if ([XCCurrentVCStackManager shareManager].getCurrentVC.navigationController &&
        [XCCurrentVCStackManager shareManager].getCurrentVC.navigationController.viewControllers.count > 0) {
        
        @KWeakify(self);
        
        __block BOOL isHaveSession;
        
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @KStrongify(self);
            
            NSString *sessionId = [[XCMediator sharedInstance] ttMessageMoudle_GetSessionIdWithSessionViewController:obj];
            
            if (!sessionId) {
                isHaveSession = NO;
            } else {
                if (sessionId.userIDValue == self.roomInfo.uid) {
                   [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController popToViewController:obj animated:YES];
                } else {
                    UIViewController *contoller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:self.roomInfo.uid sessectionType:NIMSessionTypeP2P];
                    [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:contoller animated:YES];
                }
                isHaveSession = YES;
                *stop = YES;
            }
        }];
        
        if (!isHaveSession) {
            UIViewController * contoller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:self.roomInfo.uid sessectionType:NIMSessionTypeP2P];
            [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:contoller animated:YES];
        }
        
    } else {
       UIViewController * contoller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:self.roomInfo.uid sessectionType:NIMSessionTypeP2P];
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:contoller animated:YES];
    }
}

@end
