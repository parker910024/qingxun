//
//  ChatBillInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ChatBillInfo : BaseObject

@property (strong, nonatomic) NSString *srcAvatar;
@property (strong, nonatomic) NSString *srcNick;
@property (strong, nonatomic) NSString *targetAvatar;
@property (strong, nonatomic) NSString *targetNick;
@property (strong, nonatomic) NSString *goldNum;
@property (strong, nonatomic) NSString *diamondNum;
@property (assign, nonatomic) double recordTime;

@end
