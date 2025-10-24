//
//  TTGameRoomViewController+OppositeSex.h
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import "TTGameRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRoomViewController (OppositeSex)

/* 添加到异性匹配池 */
- (void)addOppositeSexMatchPool;

/* 移出异性匹配池 */
- (void)removeOppositeSexMatchPool;

/* 陪伴房加进房限制 移出异性匹配池 */
- (void)c_CPRoomAddEnterRoomLimitType;

/* 陪伴房取消进房限制 添加异性匹配池 */
- (void)c_CPRoomCancelEnterRoomLimitType;

/* 普通房加密码 移出异性匹配池 */
- (void)c_NormalRoomAddEnterRoomPassword;

/* 普通房取消房间密码 添加异性匹配池 */
- (void)c_NormalRoomCancelEnterRoomPassword;
@end

NS_ASSUME_NONNULL_END
