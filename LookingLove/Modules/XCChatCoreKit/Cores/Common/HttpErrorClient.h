//
//  HttpErrorClient.h
//  BberryCore
//
//  Created by chenran on 2017/6/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpErrorClient <NSObject>
@optional
- (void) onTicketInvalid;
- (void) networkDisconnect;
- (void) requestFailureWithMsg:(NSString *)msg;
- (void) requestAccountWasBlockWith:(NSDictionary *)data;
@end
