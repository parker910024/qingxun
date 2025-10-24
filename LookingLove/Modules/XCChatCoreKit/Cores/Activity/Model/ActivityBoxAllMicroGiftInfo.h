//
//  ActivityBoxAllMicroGiftInfo.h
//  XCChatCoreKit
//
//  Created by Macx on 2018/10/9.
//

#import "BaseObject.h"

@interface ActivityBoxAllMicroGiftInfo : BaseObject

@property (nonatomic, strong) NSString  *code;//验证码
@property (nonatomic, assign) NSInteger  giftId;//礼物id
@property (nonatomic, assign) NSInteger  giftNum;//礼物数量
@property (nonatomic, assign) NSInteger  recordId;//中奖记录id
@property (nonatomic, assign) NSInteger  roomUid;//房主id
@property (nonatomic, assign) NSInteger  uid;//中奖人id

@end
