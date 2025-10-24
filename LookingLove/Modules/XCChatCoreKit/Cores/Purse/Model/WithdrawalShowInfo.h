//
//  WithdrawalShowInfo.h
//  BberryCore
//
//  Created by demo on 2017/12/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface WithdrawalShowInfo : BaseObject

@property (strong, nonatomic)NSString * nick;
@property (strong, nonatomic)NSString * packetNum;
@property (strong, nonatomic)NSString * createTime;

@end
