//
//  AppScoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2018/7/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCORE_ONCEOPENROOM_ACCOUNTNAME       @"SCORE_ONCEOPENROOM_ACCOUNT" //第一次开房间
#define SCORE_WITHDRAW_ACCOUNTNAME       @"SCORE_WITHDRAW_ACCOUNT" //xcGetCF
#define SCORE_NEWRED_ACCOUNTNAME         @"SCORE_NEWRED_ACCOUNT" //新用户领xcRedColor时候
#define SCORE_ONCEINTERROOM_ACCOUNTNAME    @"SCORE_ONCEINTERROOM_ACCOUNT" //第一次进房间

@protocol AppScoreClient <NSObject>
@optional
- (void)needShowScoreView:(NSString *)account;
@end
