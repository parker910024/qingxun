//
//  TTGameCPPrivateChatModel.h
//  TTPlay
//
//  Created by new on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "TTCPGameCustomInfo.h"

typedef enum : NSUInteger {
    TTGameStatusTypeTimeing = 1, // 倒计时中
    TTGameStatusTypeAccept = 2,  // 游戏被接受
    TTGameStatusTypeInvalid = 3,  //  游戏失效
} TTGameSelectStatusType;

NS_ASSUME_NONNULL_BEGIN

@interface TTGameCPPrivateChatModel : BaseObject

@property (nonatomic, assign) UserID startTime;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) UserID winerUid;
@property (nonatomic, strong) TTCPGameCustomInfo *gameInfo;
@property (nonatomic, strong) NSString *uuId;
@property (nonatomic, strong) NSString *gameUrl;
@property (nonatomic, assign) UserID startUid;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, assign) UserID acceptUid;
@end

NS_ASSUME_NONNULL_END
