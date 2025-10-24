//
//  ShareSendInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/23.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ShareSendInfo : BaseObject

@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString *nick;
@property (assign, nonatomic) UserID targetUid;
@property (copy, nonatomic) NSString *targetNick;
@property(nonatomic, strong)NSDictionary *encodeAttachemt;
@end
