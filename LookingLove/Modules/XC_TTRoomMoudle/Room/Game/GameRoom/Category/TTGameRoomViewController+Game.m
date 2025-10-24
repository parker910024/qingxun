//
//  TTGameRoomViewController+Game.m
//  TuTu
//
//  Created by zoey on 2018/12/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController+Game.h"
#import "ImRoomCoreV2.h"
#import "RoomCoreV2.h"

@implementation TTGameRoomViewController (Game)

- (void)onClickGameStartBtn:(UIButton *)btn {
    [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Start];
}

- (void)onClickGameOpenBtn:(UIButton *)btn {
//    [GetCore(RoomCoreV2) clearDragonWithRoomUid:self.roomInfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
    [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Finish];

}

- (void)onClickGameCancelBtn:(UIButton *)btn {
    [GetCore(FaceCore) sendDragonWithState:Custom_Noti_Sub_Dragon_Cancel];
//    [GetCore(RoomCoreV2) clearDragonWithRoomUid:self.roomInfo.uid uid:GetCore(AuthCore).getUid.longLongValue];
}
//currenDragonFaceSendInfo

#pragma mark - FaceCoreClient

- (void)onDragonSendSuccess {
    //存在结果 状态变更为 开龙珠 或 丢弃
    if(GetCore(RoomCoreV2).currenDragonFaceSendInfo){
        self.gameCancelBtn.hidden = NO;
        self.gameOpenBtn.hidden = NO;
        self.gameStartBtn.enabled = NO;
        
    }else {
        self.gameStartBtn.enabled = YES;
        self.gameCancelBtn.hidden = YES;
        self.gameOpenBtn.hidden = YES;
    }
    
}

- (void)onDragonSendFailth:(NSString *)msg {
//    NSString *errorStr = [NSString stringWithFormat:@"龙珠异常:%@",msg];
//    [UIView showToastInKeyWindow:errorStr duration:3 position:YYToastPositionCenter];
}

@end
