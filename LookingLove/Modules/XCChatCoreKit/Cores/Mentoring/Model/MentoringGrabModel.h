//
//  MentoringGrabModel.h
//  XCChatCoreKit
//
//  Created by Macx on 2019/4/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"
#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MentoringGrabModel : BaseObject
/** 抢徒弟倒计时的时间 */
@property (nonatomic, assign) NSInteger countdown;

@property (nonatomic, assign) UserID uid;
@property (nonatomic, copy) NSString *erbanNo;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nick;
/** 性别 */
@property (nonatomic, assign) UserGender gender;
@end

NS_ASSUME_NONNULL_END
