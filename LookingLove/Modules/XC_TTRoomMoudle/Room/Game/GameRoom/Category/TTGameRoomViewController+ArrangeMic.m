//
//  TTGameRoomViewController+ArrangeMic.m
//  TuTu
//
//  Created by gzlx on 2018/12/18.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+ArrangeMic.h"
#import "TTQueueMikeViewController.h"
#import "RoomQueueCoreV2.h"
#import "TTGameRoomViewController+RoomShare.h"
#import "TTGameRoomViewController+FunctionMenu.h"

@implementation TTGameRoomViewController (ArrangeMic)

- (void)ttShowArrangeMicVc {
    // 排麦
    if (self.roomInfo.roomModeType == RoomModeType_Open_Micro_Mode) {
        TTQueueMikeViewController *vc = [[TTQueueMikeViewController alloc] init];
        NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
        if(mineMember.type == NIMChatroomMemberTypeCreator || mineMember.type == NIMChatroomMemberTypeManager) {
            vc.isMyRoom = YES;
        } else {
            vc.isMyRoom = NO;
        }
        vc.roomInfo = self.roomInfo; // 房间信息
        
        vc.btnClickHander = ^(UIButton * _Nonnull btn) {
            [self ttShowRoomShareView]; // 去分享
        };
        
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

- (void)updateQueueMicStatus:(BOOL)status {
    [self.functionMenuView.items enumerateObjectsUsingBlock:^(TTFunctionMenuButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == TTFunctionMenuButtonType_QueueMike) {
            obj.selected = status;
            * stop = YES;
        }
    }];
}



@end
