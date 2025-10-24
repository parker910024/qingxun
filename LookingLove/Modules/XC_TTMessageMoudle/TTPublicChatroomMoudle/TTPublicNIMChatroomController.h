//
//  TTPublicNIMChatroomController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/11.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "NIMSessionViewController.h"
#import "ZJScrollPageViewDelegate.h"

#import "TTPublicChatInputView.h"

#import "TTSendGiftView.h"
#import "TTCPGameListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicNIMChatroomController : NIMSessionViewController
<
    ZJScrollPageViewChildVcDelegate,
    TTSendGiftViewDelegate
>

//公聊大厅的输入框
@property (strong, nonatomic) TTPublicChatInputView *publicChatInputView;

/**
 初始化方法
 
 @param session 所属回话
 @param isPublicChat 是否公聊大厅，因为公聊大厅需要特殊处理
 @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session isPublicChat:(BOOL)isPublicChat;

// 保存当前被接受的消息id
@property (nonatomic, strong) NSString *acceptMessageID;
@property (nonatomic, strong) TTCPGameListView *listView;

@property (nonatomic, strong) NSMutableArray *gameListArray;
@end

NS_ASSUME_NONNULL_END
