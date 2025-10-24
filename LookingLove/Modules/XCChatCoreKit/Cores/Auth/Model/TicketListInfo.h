//
//  TicketListInfo.h
//  CompoundUtil
//
//  Created by chenran on 2017/4/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface TicketListInfo : BaseObject<NSCopying,NSCopying>
@property(nonatomic, strong) NSString *issue_type;
@property(nonatomic, strong) NSArray* tickets;
@end
