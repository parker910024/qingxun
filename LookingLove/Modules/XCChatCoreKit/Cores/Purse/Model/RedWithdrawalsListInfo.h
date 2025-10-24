//
//  RedWithdrawalsListInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/3.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RedWithdrawalsListInfo : BaseObject

//"packetId":1,
//"packetNum":100,
//"prodStauts":1,
//"seqNo":1

@property (assign, nonatomic) NSInteger packetId;
@property (assign, nonatomic) NSInteger packetNum;
@property (assign, nonatomic) NSInteger prodStauts;
@property (assign, nonatomic) NSInteger seqNo;

@end
