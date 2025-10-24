//
//  RedInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface RedInfo : BaseObject
@property (copy, nonatomic) NSString *packetName;
@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString *packetNum;
@property (assign, nonatomic) BOOL needAlert;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger type;

@end
