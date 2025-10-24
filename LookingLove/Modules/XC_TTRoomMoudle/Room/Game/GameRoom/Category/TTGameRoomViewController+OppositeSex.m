//
//  TTGameRoomViewController+OppositeSex.m
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import "TTGameRoomViewController+OppositeSex.h"

@implementation TTGameRoomViewController (OppositeSex)

/* 陪伴房加进房限制 移出异性匹配池 */
- (void)c_CPRoomAddEnterRoomLimitType {
    [self removeOppositeSexMatchPool];
}

/* 陪伴房取消进房限制 添加异性匹配池 */
- (void)c_CPRoomCancelEnterRoomLimitType {
    [self addOppositeSexMatchPool];
}

/* 普通房加密码 移出异性匹配池 */
- (void)c_NormalRoomAddEnterRoomPassword {
    [self removeOppositeSexMatchPool];
}

/* 普通房取消房间密码 添加异性匹配池 */
- (void)c_NormalRoomCancelEnterRoomPassword {
    [self addOppositeSexMatchPool];
}

- (void)addOppositeSexMatchPool {
    if (self.roomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
        [GetCore(CPGameCore) roomOwnerAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue WithRoomId:self.roomInfo.roomId];
    }
}

- (void)removeOppositeSexMatchPool {
    if (self.roomInfo.uid == GetCore(AuthCore).getUid.userIDValue) {
        [GetCore(CPGameCore) roomOwnerRemoveOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
    }
}
@end
