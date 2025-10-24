//
//  TicketListInfoStorage.h
//  BberryCore
//
//  Created by chenran on 2017/5/5.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketListInfo.h"

@interface TicketListInfoStorage : NSObject
+ (TicketListInfo *)getCurrentTicketListInfo;
+ (void) saveTicketListInfo:(TicketListInfo *)ticketListInfo;
@end
