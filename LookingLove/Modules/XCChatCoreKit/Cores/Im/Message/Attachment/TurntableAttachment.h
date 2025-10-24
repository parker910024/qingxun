//
//  TurntableInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 chenran. All rights reserved.
//
// 抽奖

#import <NIMSDK/NIMSDK.h>
#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

@interface TurntableAttachment : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>

//leftDrawNum = 1;
//totalDrawNum = 1;
//totalWinDrawNum = 0;
//uid = 90971;

@property (nonatomic, assign) NSInteger leftDrawNum;
@property (nonatomic, assign) NSInteger totalDrawNum;
@property (nonatomic, assign) NSInteger totalWinDrawNum;
@property (nonatomic, assign) UserID uid;
@end
