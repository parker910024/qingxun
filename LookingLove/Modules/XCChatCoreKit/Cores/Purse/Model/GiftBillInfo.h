//
//  GiftBillInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/18.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface GiftBillInfo : BaseObject

@property (copy, nonatomic) NSString *targetNick;
@property (copy, nonatomic) NSString *goldNum;
@property (copy ,nonatomic) NSString *diamondNum;
@property (copy, nonatomic) NSString *giftPict;
@property (copy, nonatomic) NSString *giftName;
@property (assign, nonatomic) NSInteger giftNum;
@property (assign, nonatomic) double recordTime;


@end
