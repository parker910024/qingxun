//
//  ChatRoomQueueNotifyModel.h
//  BberryCore
//
//  Created by Mac on 2018/3/31.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

@interface ChatRoomQueueNotifyModel : BaseObject
/** 安卓使用的是Uid  所以加了一个这样的属性*/
@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) UserID handleUid;
@property (nonatomic, copy) NSString *handleNick;
@property (nonatomic, assign) UserID targetUid;
@property (nonatomic, copy) NSString *targetNick;
@end
