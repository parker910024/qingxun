//
//  Tikect.h
//  CompoundUtil
//
//  Created by chenran on 2017/4/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface TicketInfo : BaseObject<NSCopying,NSCopying>
@property(nonatomic, strong)NSString *ticket;
@property(nonatomic, strong)NSNumber *expires_in;
@end
