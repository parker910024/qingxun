//
//  TTPositionItem.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
// 基本的坑位的UI 头像 光圈 名字  几号麦  闭麦  锁坑 头饰

#import <UIKit/UIKit.h>
#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"
#import "ChatRoomMicSequence.h"
#import <YYText/YYLabel.h>
#import "TTPositionViewUIProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class TTPositionItem;
@protocol TTPostionItemDelegate

@required
- (void)roomPostionItem:(TTPositionItem *)postionItem didSelectItemAtPosition:(NSString *)position;

@end

@interface TTPositionItem : UIView

/**
初始化 基本的坑位信息
 @param type 房间的模式
 @param position 坑位
 @return 坑位的View
 */
- (instancetype)initWithStyle:(TTRoomPositionViewType)type position:(NSString *)position;

/** 当前的麦位是几麦*/
@property (nonatomic,strong) NSString  *position;

/** 昵称*/
@property (nonatomic, strong) YYLabel *nickNameLabel;

/** 相亲房昵称*/
@property (nonatomic, strong) UIButton *loveRoomNameButton;

/** 当前麦位上的信息*/
@property (nonatomic, strong) ChatRoomMicSequence *sequence;

/** 相亲房专用，当前我在麦位上，并且不是大头麦*/
@property (nonatomic, strong) ChatRoomMicSequence *mySequence;

/** 相亲房专用，当前我在麦位上，并且不是大头麦 我的麦位用户信息*/
@property (nonatomic, strong) UserInfo *myUserInfo;

/** 给VIp坑位赋值 传一个图片的名字*/
@property (nonatomic, strong) NSString *vipItemName;

/** 是不是显示房主离开*/
@property (nonatomic, assign) BOOL iSShowLeave;

/**是否显示礼物值，默认：NO*/
@property (nonatomic, assign, getter=isShowGiftValue) BOOL showGiftValue;

@property (nonatomic,assign) id<TTPostionItemDelegate> delegate;

/**
 重置礼物值
 */
- (void)resetGiftValue;

/**
 更新坑位礼物值
 
 @param giftValue 礼物值
 @param updateTime 礼物接收时间
 */
- (void)updateGiftValue:(long long)giftValue updateTime:(NSString *)updateTime;

@end

NS_ASSUME_NONNULL_END
