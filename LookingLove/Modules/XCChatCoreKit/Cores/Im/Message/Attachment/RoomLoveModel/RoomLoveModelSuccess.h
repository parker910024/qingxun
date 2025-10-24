//
//  RoomLoveModelSuccess.h
//  WanBan
//
//  Created by Lee on 2020/10/23.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  相亲结果通知模型

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomLoveModelSuccess : BaseObject

@property (nonatomic, copy) NSString *choseAvatar;
@property (nonatomic, copy) NSString *nickStr;//昵称拼接
@property (nonatomic, assign) UserID erbanNo;
//相亲结果 111-失败, 112-普通, 1-等级一, 2-等级二, 3-等级三
@property (nonatomic, assign) NSInteger resultType;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *vggUrl;//动效
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) UserID choseUid;
@property (nonatomic, assign) NSInteger choseErbanNo;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *choseNick;

@end

NS_ASSUME_NONNULL_END
