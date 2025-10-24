//
//  RedPacketDetailInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/25.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "Attachment.h"
#import "RedPacketRecordInfo.h"
#import "XCCustomAttachmentInfo.h"

typedef enum : NSUInteger {
    RedPacketStatus_NotOpen = 1,    //未领取
    RedPacketStatus_DidOpen = 2,    //已领取
    RedPacketStatus_OutDate = 3,    //已过期
    RedPacketStatus_OutBouns = 4    //领取完
} RedPacketStatus;

@interface RedPacketDetailInfo : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) RedPacketStatus status;
@property (nonatomic,assign) NSInteger id; //[XCKeyWordTool sharedInstance].xcRedColorid
//@property (nonatomic,assign) UserID uid;
@property (nonatomic,assign) UserID senderUid;
@property (nonatomic,assign) UserID receiveUid;
@property (strong, nonatomic) NSString *receiveNick;
@property (nonatomic,assign) NSInteger family_id;
@property (nonatomic,assign) float amount;//[XCKeyWordTool sharedInstance].xcRedColor总数量
@property (nonatomic,assign) float claimedAmount; //已经领取的金额
@property (nonatomic,assign) NSInteger claimedNum;  //已经领取的[XCKeyWordTool sharedInstance].xcRedColor数量
@property (nonatomic,assign) NSInteger num; //[XCKeyWordTool sharedInstance].xcRedColor总数量
@property (strong, nonatomic) NSString *coinName; //金币名字
@property (strong, nonatomic) NSString *message; //消息
@property (nonatomic,assign) NSInteger tid;
@property (nonatomic,copy) NSString * moneyName;

@property (strong, nonatomic) NSArray<RedPacketRecordInfo *> *records;
@end
