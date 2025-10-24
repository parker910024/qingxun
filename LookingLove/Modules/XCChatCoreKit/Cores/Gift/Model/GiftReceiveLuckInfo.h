//
//  GiftReceiveLuckInfo.h
//  XCChatCoreKit
//
//  Created by Macx on 2018/10/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseObject.h"

@interface GiftReceiveLuckInfo : BaseObject
@property (nonatomic, assign)NSInteger giftId;
@property (nonatomic, strong)NSString *giftName;
@property (nonatomic, assign)double goldPrice;
@property (nonatomic, copy)NSString *giftUrl;
@property (assign, nonatomic) BOOL hasVggPic;
@property (copy, nonatomic) NSString *vggUrl;
@property (assign, nonatomic) BOOL hasEffect; //是否特效

@end
