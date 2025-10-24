//
//  TTChannalGiftManager.h
//  TuTu
//
//  Created by KevinWang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftChannelNotifyInfo.h"
#import "GiftNotifyDisplayInfo.h"
#import "AnnualBroadcastNotifyInfo.h"

@interface TTChannalGiftManager : NSObject

+(instancetype)shareManager;
- (void)showGiftBoradCast:(GiftChannelNotifyInfo *)giftNotifyInfo;
- (void)showNamePlate:(NSArray *)array;//铭牌全服通知
- (void)showAnnualBroadcast:(AnnualBroadcastNotifyInfo *)info jumpHandler:(void(^)(void))jumpHandler;//全服年度通知
@end




typedef void(^completeBlock)(BOOL finished);

@interface GiftBoradCastView : UIView

@property (nonatomic,assign,getter=isFinished) BOOL finished;
@property (nonatomic, copy) completeBlock block;
@property (nonatomic, copy) void(^userInteractionHandler)(void);//点击交互

- (instancetype)initWithFrame:(CGRect)frame andDisplayType:(GiftChannelNotifyType)displayType;
- (void)giftViewAnimateWithCompleteBlock:(completeBlock)completed;
- (void)boradCastByGiftNotifyInfo:(GiftChannelNotifyInfo *)giftNotifyInfo;
- (void)boradCastByNamePlate:(NSArray *)array;//铭牌全服通知
- (void)broadcastByAnnualInfo:(AnnualBroadcastNotifyInfo *)info;//全服年度通知

@end

typedef void(^completeBlock)(BOOL finished);

@interface GiftBoradAdminCastView : UIView

@property (nonatomic, copy) completeBlock block;

- (instancetype)initWithFrame:(CGRect)frame andDisplayType:(GiftChannelNotifyType)displayType;

- (void)giftViewAnimateWithCompleteBlock:(completeBlock)completed;
- (void)boradCastByGiftNotifyInfo:(GiftChannelNotifyInfo *)giftNotifyInfo;
@end



@interface GiftAnimOperation : NSOperation

@property (nonatomic,strong) GiftBoradCastView *giftBoradCastView;

@property (nonatomic, strong) GiftBoradAdminCastView *giftBoradAdminView;
@property (nonatomic, assign) BOOL isAdmin;

+ (instancetype)animOperationWithGiftBoradCastView:(GiftBoradCastView *)giftBoradCastView finishedBlock:(void(^)(BOOL result))finishedBlock;

+ (instancetype)animOperationWithGiftBoradAdminView:(GiftBoradAdminCastView *)giftBoradAdminView isAdmin:(BOOL)isAdmin finishedBlock:(void (^)(BOOL))finishedBlock;
@end




@interface GiftNotifySourceControl : NSObject

+ (GiftNotifyDisplayInfo *)getSourceByType:(GiftChannelNotifyType)displayType;

@end
