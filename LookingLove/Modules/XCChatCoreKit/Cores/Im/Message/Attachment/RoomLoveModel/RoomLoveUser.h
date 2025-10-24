//
//  RoomLoveUser.h
//  WanBan
//
//  Created by Lee on 2020/10/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomLoveUser : BaseObject

@property (nonatomic, copy) NSString *nick;         // 昵称
@property (nonatomic, copy) NSString *choseNick;    // 对象昵称
@property (nonatomic, assign) UserID uid;           
@property (nonatomic, assign) UserID erbanNo;
@property (nonatomic, assign) UserID choseUid;
@property (nonatomic, assign) UserID choseErbanNo;

@end

NS_ASSUME_NONNULL_END
