//
//  CallInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface CallInfo : BaseObject

@property(assign, nonatomic)UserID uid;
@property(copy, nonatomic)NSString *nick;
@property(copy, nonatomic)NSDictionary *encodeAttchment;
@end
