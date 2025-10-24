//
//  RedPacketRecordInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"

@interface RedPacketRecordInfo : BaseObject
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) double amount;
@property (nonatomic,assign) BOOL luckiest;
@property (strong, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger redPacketId;
@property (assign, nonatomic) UserID uid;
@end
