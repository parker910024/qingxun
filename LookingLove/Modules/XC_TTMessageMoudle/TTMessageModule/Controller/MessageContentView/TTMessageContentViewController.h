//
//  TTMessageContentViewController.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ZJScrollPageView.h"
#import "TTSendPresentUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageVCType) {
    MessageVCType_RoomChat,//房间内消息
    MessageVCType_SendHeaderWear,//赠送头饰
    MessageVCType_AtPerson,//@人的时候
    MessageVCType_Contacts,//消息中的联系人
    MessageVCType_Default,//默认的
};


typedef void(^MessageSelectPresentBlock)(NSDictionary *user);

@interface TTMessageContentViewController : BaseUIViewController<ZJScrollPageViewChildVcDelegate>
/** 是否是消息 中的 联系人 VC */
@property (nonatomic, assign) BOOL isContacts;
/**
 选择赠送人的回调
 */
@property (nonatomic, copy) MessageSelectPresentBlock selectPresentBlock;

@end

NS_ASSUME_NONNULL_END
