//
//  LogClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogClient <NSObject>
- (void)requestLogSKSuccess;
- (void)reuqestLogSKFailth;
@end
