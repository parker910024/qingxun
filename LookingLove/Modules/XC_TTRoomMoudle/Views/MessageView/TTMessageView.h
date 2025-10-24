//
//  TTMessageView.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAttrbutedStringHandler+RoomMessage.h"
#import "TTMessageHelper.h"
#import "TTNobleSourceHandler.h"
//cell
#import "TTMessageCell.h"
#import "TTMessageTextCell.h"
#import "TTMessageFaceCell.h"

#import <YYText/YYText.h>

//t
#import "UserID.h"
#import "XCTheme.h"
#import "NSString+SpecialClean.h"
#import "UIImageView+QiNiu.h"

//IM
#import <NIMSDK/NIMSDK.h>
#import "Attachment.h"

//core
#import "AuthCore.h"
#import "UserCore.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClient.h"

#import "RoomCoreV2.h"
#import "RoomCoreClient.h"
#import "RoomQueueCoreV2.h"

#import "GiftCore.h"
#import "GiftCoreClient.h"
#import "GiftSendAllMicroAvatarInfo.h"

#import "FaceCore.h"
#import "FaceSendInfo.h"
#import "FaceReceiveInfo.h"

//model
#import "TTMessageDisplayModel.h"
//privider
#import "TTMessageContentProvider.h"

@class TTMessageView;

@protocol TTMessageViewDelegate <NSObject>
@optional
- (void)messageTableView:(TTMessageView *)messageTableView needShowUserInfoCardWithUid:(UserID)uid;

- (void)messageTableView:(TTMessageView *)messageTableView updateRoomNormalGameMessage:(TTMessageDisplayModel *)messageModel;

- (void)messageTableView:(TTMessageView *)messageTableView updateRoomNormalGameForAcceptMessage:(TTMessageDisplayModel *)messageModel;

- (void)messageTableView:(TTMessageView *)messageTableView littleWorldWithModel:(TTMessageDisplayModel *)messageModel;

- (void)messageTableView:(TTMessageView *)messageTableView littleWorldPraiseWithModel:(TTMessageDisplayModel *)messageModel;

/// 已发送进房欢迎语
- (void)messageTableView:(TTMessageView *)messageTableView enterRoomHadSendGreetingWithModel:(TTMessageDisplayModel *)messageModel;

/// 点击游戏
- (void)messageTableView:(TTMessageView *)messageTableView enterRoomGameWithModel:(TTMessageDisplayModel *)messageModel;
/// 收到游戏消息
- (void)messageTableView:(TTMessageView *)messageTableView receiveRoomGameWithModel:(TTMessageDisplayModel *)messageModel;
@end

@interface TTMessageView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<TTMessageDisplayModel *>* messages;
@property (nonatomic, strong) NSCache *attributedStringContent;
@property (nonatomic, weak) id<TTMessageViewDelegate> delegate;

- (void)reloadChatList:(BOOL)animate;

@end
