//
//  TTPositionViewDatasourceImpl.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionViewDatasourceImpl.h"
//categray
#import "NSArray+Safe.h"
#import "NSString+JsonToDic.h"

//core
#import "ChatRoomMicSequence.h"
#import "FaceImageTool.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "AuthCore.h"
#import "TTGameStaticTypeCore.h"
#import "ImMessageCore.h"
//view
#import "TTPositionItem.h"
#import "TTPositionDragView.h"
//tool
#import <YYText.h>
#import "TTPositionUIManager.h"
#import "TTPositionCoreManager.h"
#import "TTRoomPositionConfig.h"
#import "TTPositionHelper.h"

@interface TTPositionViewDatasourceImpl ()
/** 坑位的样式*/
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle  style;
/** 房间的模式*/
@property (nonatomic, assign) TTRoomPositionViewType positonViewType;
/** 所有的麦位*/
@property (nonatomic, strong) NSArray *positions;
/** 龙珠的动画是不是开始了*/
@property (nonatomic, assign) BOOL isDranonStart;
/** 是自己的龙珠还是别人的龙珠*/
@property (nonatomic, assign) BOOL isShowingMyDragon;
/** 麦序信息*/
@property (strong, nonatomic) NSMutableDictionary<NSString *, ChatRoomMicSequence *> *mircoList;

/** 坑位的配置*/
@property (nonatomic,strong) TTRoomPositionConfig *config;

@end


@implementation TTPositionViewDatasourceImpl

- (id)initDatasourceImplStyle:(TTRoomPositionViewLayoutStyle)style positonViewType:(TTRoomPositionViewType)positonViewType{
    if (self = [super init]) {
        self.config= [TTRoomPositionConfig globalConfig];
        self.style = style;
        self.positonViewType = positonViewType;
    }
    return self;
}

- (void)updatePostionMicWithSqueue:(NSMutableDictionary *)micDic {
    self.mircoList = micDic;;
    self.positions = [TTPositionUIManager shareUIManager].positionItems;
    NSInteger itemCount;
    if (self.style == TTRoomPositionViewTypeNormal || self.style == TTRoomPositionViewLayoutStyleLove) {
        itemCount = 9;
    }else{
        itemCount = 2;
    }
    
    ChatRoomMicSequence *mySequence = nil;
    if ([GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue]) {
        NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue];
        mySequence = [micDic objectForKey:position];
    }
    
    for (int i = 0; i<itemCount; i++) {
        NSMutableDictionary * micQueue = GetCore(ImRoomCoreV2).micQueue;
        NSString *position = [NSString stringWithFormat:@"%d",i-1];
        ChatRoomMicSequence *sequence = [micQueue objectForKey:position];
        
        TTPositionItem *item = [[TTPositionUIManager shareUIManager].positionItems safeObjectAtIndex:i];
        if ((i - 1) != -1) {
            item.mySequence = mySequence;
        } else {
            item.mySequence = nil;
        }
         item.sequence = sequence;//再根据数据布局
        ///判断是否显示礼物值
        item.showGiftValue = NO;
        item.showGiftValue = [TTPositionCoreManager shareCoreManager].isShowGiftValue;
        if (!sequence.userInfo) {
            if (!([position isEqualToString:@"-1"] && self.positonViewType == TTRoomPositionViewTypeOwnerLeave)) {
                  [item resetGiftValue];
            }
        }
    }
}

//处理 龙珠
- (void)dealDragonWithRecieveInfos:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos state:(CustomNotificationDragon)state {
    if (state == Custom_Noti_Sub_Dragon_Start || state == Custom_Noti_Sub_Dragon_Continue) {
        //开始龙珠
        //这里需要处理 自己和别人展示的
        for (FaceReceiveInfo *item in faceRecieveInfos) {
            NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:item.uid];
            if (position != nil ) {
                __block   TTPositionDragView *imageView = [self findTheDragonImageViewByPosition:position];
                //自己
                if(item.uid == GetCore(AuthCore).getUid.longLongValue){
                    self.isShowingMyDragon = YES;
                    self.isDranonStart = YES;
                    @weakify(self);
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearPositionMicDragonImageWith:) object:imageView.flanimationView];
                    [[FaceImageTool shareFaceImageTool] queryImage:item imageView:imageView.flanimationView dragon:YES needAniomation:YES success:^(FaceReceiveInfo *info, UIImage *lastImage) {
                        @strongify(self);
                        imageView.flanimationView.image = lastImage;
                        self.isShowingMyDragon = NO;
                    } failure:^(NSError *error) {
                        @strongify(self);
                        self.isShowingMyDragon = NO;
                    } isFinish:^(BOOL isFinish) {
                        @strongify(self);
                        self.isShowingMyDragon = NO;
                        self.isDranonStart = NO;
                    }];
                    
                    
                }else {
                    //别人
                    if (projectType() == ProjectType_CeEr || projectType() == ProjectType_LookingLove) {
                        
                        item.resultIndexes = @[@(GetCore(FaceCore).dragonConfigInfo.animEndPos)].mutableCopy;
                        
                        [[FaceImageTool shareFaceImageTool]queryImage:item imageView:imageView.flanimationView dragon:YES needAniomation:YES success:^(FaceReceiveInfo *info,UIImage *lastImage) {
                            imageView.flanimationView.image = lastImage;
                        } failure:^(NSError *error) {
                            
                        }];
                        
                    }else {
                        item.resultIndexes = @[@(0),@(0),@(0)].mutableCopy;
                        [[FaceImageTool shareFaceImageTool]queryImage:item imageView:imageView.flanimationView dragon:YES needAniomation:YES success:^(FaceReceiveInfo *info,UIImage *lastImage) {
                            imageView.flanimationView.image = lastImage;
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                }
            }
        }
    }else if (state == Custom_Noti_Sub_Dragon_Finish){
        //开龙珠
        for (FaceReceiveInfo *item in faceRecieveInfos) {
            NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:item.uid];
            if (position != nil ) {
                TTPositionDragView *imageView = [self findTheDragonImageViewByPosition:position];
                if(item.uid == GetCore(AuthCore).getUid.longLongValue){
                    self.isShowingMyDragon = YES;
                    //自己的龙珠
                    @weakify(self);
                    //如果是上一个动画还没有结束的话 就先停止动画 直接显示内容
                    if (self.isDranonStart) {
                        [imageView.layer removeAllAnimations];
                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearPositionMicDragonImageWith:) object:imageView.flanimationView];
                        [[FaceImageTool shareFaceImageTool]queryImage:item imageView:imageView.flanimationView dragon:YES needAniomation:NO success:^(FaceReceiveInfo *info,UIImage *lastImage) {
                            @strongify(self);
                            imageView.flanimationView.image = lastImage;
                            [self performSelector:@selector(clearPositionMicDragonImageWith:) withObject:imageView.flanimationView afterDelay:3];
                        } failure:^(NSError *error) {
                            
                        }];
                    }else{
                        [self performSelector:@selector(clearPositionMicDragonImageWith:) withObject:imageView.flanimationView afterDelay:3];
                    }
                }else {
                    //别人
                    [imageView.layer removeAllAnimations];
                    [[FaceImageTool shareFaceImageTool]queryImage:item imageView:imageView.flanimationView dragon:YES needAniomation:NO success:^(FaceReceiveInfo *info,UIImage *lastImage) {
                        imageView.flanimationView.image = lastImage;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            imageView.flanimationView.image = nil;
                            
                        });
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }
        }
    }else {
        //放弃龙珠
        for (FaceReceiveInfo *item in faceRecieveInfos) {
            
            if(item.uid == GetCore(AuthCore).getUid.longLongValue){
                self.isShowingMyDragon = NO;
            }
            NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:item.uid];
            if(position != nil) {
                TTPositionDragView *imageView = [self findTheDragonImageViewByPosition:position];
                imageView.flanimationView.image = nil;
            }
        }
    }
    
}

- (void)clearPositionMicDragonImageWith:(UIImageView *)imageView {
    self.isDranonStart = NO;
    self.isShowingMyDragon = NO;
    imageView.image = nil;
    [imageView.layer removeAllAnimations];
}

//获取播放龙珠的img
- (TTPositionDragView *)findTheDragonImageViewByPosition:(NSString *)position {
    TTPositionDragView * dragView = [[TTPositionUIManager shareUIManager].dragonImageViewArr safeObjectAtIndex:([position integerValue]+1)];
    return dragView;
}

//清除麦位上没人龙珠残留
- (void)clearMicNotPeopelDragon {
    for (int i = -1; i< 8; i++) {
        self.mircoList= GetCore(ImRoomCoreV2).micQueue;
        NIMChatroomMember *member = [self.mircoList objectForKey:[NSString stringWithFormat:@"%d",i]].chatRoomMember;
        if (!member) {
            TTPositionDragView *imageView = [self findTheDragonImageViewByPosition:[NSString stringWithFormat:@"%d",i]];
            imageView.flanimationView.image = nil;
        }
    }
}
#pragma mark - 设置说话的光圈
//设置speak光圈动画
- (void)reloadTheSpeakingView {
    NSMutableArray *arr = GetCore(RoomCoreV2).positionArr;
    int arrCount = 0;
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP){
        arrCount = 1;
    }else{
        arrCount = 8;
    }
    
    for (int i = -1; i < arrCount; i++) {
        TTPositionSpeakingView *speakingView = [[TTPositionUIManager shareUIManager].speakingAnimationViews safeObjectAtIndex:i+1];
        if (!speakingView) {
            continue;
        }
        NIMChatroomMember *member = [self.mircoList objectForKey:[NSString stringWithFormat:@"%d",i]].chatRoomMember;
        NSDictionary *nobleInfoExt = [NSString dictionaryWithJsonString:member.roomExt];
        SingleNobleInfo *info = [SingleNobleInfo modelWithJSON:nobleInfoExt[member.userId]];
    
        if (info.headwear) {
            speakingView.borderColor = (UIColor *)info.halo;
            speakingView.circleColor = (UIColor *)info.halo;
        }else{
            speakingView.borderColor = [UIColor whiteColor];
            speakingView.circleColor = [UIColor whiteColor];
        }
        
        CGFloat w_h = 50;
        if (self.style == TTRoomPositionViewLayoutStyleCP) {
            w_h = self.config.NormalOwnerItemWidth - 5;
        }else{
            if (self.positonViewType == TTRoomPositionViewTypeNormal || self.positonViewType == TTRoomPositionViewTypeLove) {//房主光圈特殊处理
                if (i == -1) {
                    w_h = self.config.NormalOwnerItemWidth - 5;
                }else {
                    w_h = self.config.NormalItemWidth - 5;
                }
            }
        }
       
        speakingView.bounds = CGRectMake(0, 0, w_h, w_h);
        speakingView.center = [[arr safeObjectAtIndex:(i+1)] CGPointValue];
        speakingView.layer.cornerRadius = w_h/2;
        if ([self checkUserIsSpeakingWithUserId:member.userId.userIDValue]) {
            [speakingView start:(int)speakingView.tag];
        }
    }
}

//判断麦上的人是否在说话
- (BOOL)checkUserIsSpeakingWithUserId:(UserID)userId{
    
    NSArray *speakerList = GetCore(RoomCoreV2).speakingList;
    for (NSNumber *speaker in speakerList) {
        if (speaker.userIDValue == userId) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - face
- (void)showFaceInPositionViewWith:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos{
    for (FaceReceiveInfo *item in faceRecieveInfos) {
        NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:item.uid];
        if (position != nil ) {
            FLAnimatedImageView *imageView = [self findTheImageViewByPosition:position];
            FaceConfigInfo *faceInfo = [GetCore(FaceCore) findFaceInfoById:item.faceId];
            [[FaceImageTool shareFaceImageTool] queryImage:item imageView:imageView dragon:NO needAniomation:YES success:^(FaceReceiveInfo *info,UIImage *lastImage) {
                
            } failure:^(NSError *error) {
                
            }];
            if (item.uid == [GetCore(AuthCore) getUid].userIDValue && faceInfo.resultCount > 0) {
                GetCore(FaceCore).isShowingFace = YES;
            }
        }
    }
}

//获取播放表情的img
- (FLAnimatedImageView *)findTheImageViewByPosition:(NSString *)position {
    return [[TTPositionUIManager shareUIManager].faceImageViewArr safeObjectAtIndex:([position integerValue]+1)];
}

#pragma mark Gift Value Handle
/**
 更新坑位的礼物值
 
 @param giftValue 礼物值
 @param uid 接收礼物用户的uid
 @param updateTime 接收礼物时间
 */
- (void)updatePostionItemGiftValue:(long long)giftValue
                               uid:(UserID)uid
                        updateTime:(NSString *)updateTime {
    
    BOOL leaveMode = self.positonViewType == TTRoomPositionViewTypeOwnerLeave;
    BOOL isOwnerUid = uid == GetCore(ImRoomCoreV2).roomOwnerInfo.uid;
    NSString *ownerPositionFlag = @"-1";
    TTPositionItem *updateItem;
    for (TTPositionItem *item in [TTPositionUIManager shareUIManager].positionItems) {
        BOOL isOwnerPosition = [item.position isEqualToString:ownerPositionFlag];
        if (leaveMode && isOwnerUid && isOwnerPosition) {
            //离开模式房主位礼物值更新
            updateItem = item;
            break;
        }
        
        if (item.sequence.userInfo == nil) {
            if (!(leaveMode && isOwnerPosition)) {
                [item resetGiftValue];
            }
            
        } else {
            if (item.sequence.userInfo.uid == uid) {
                updateItem = item;
                break;
            }
        }
    }
    
    if (updateItem == nil) {
        return;
    }
    
    [updateItem updateGiftValue:giftValue updateTime:updateTime];
}

/**
 清除礼物值同步自定义消息
 
 @param model 当前所有麦位礼物值信息
 */
- (void)cleanGiftValueSyncCustomNotify:(RoomOnMicGiftValue *)model {
    
    Attachment *attach = [[Attachment alloc] init];
    attach.first = Custom_Noti_Header_GiftValue;
    attach.second = Custom_Noti_Sub_GiftValue_sync;
    attach.data = [model model2dictionary];
    
    NSString *sessionId = @(GetCore(ImRoomCoreV2).currentRoomInfo.roomId).stringValue;
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attach
                                               sessionId:sessionId
                                                    type:NIMSessionTypeChatroom];
}

#pragma mark - 房间话题
- (void)updatePositionTopicLableWith:(TTPositionTopicModel *)model {
    NSMutableAttributedString * topicAttributeding = [[TTPositionHelper shareHelper] createTuTuTopicAtttibutedStringWith:model];
    [topicAttributeding yy_setTextHighlightRange:NSMakeRange(0, topicAttributeding.length) color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    } longPressAction:nil];
    [TTPositionUIManager shareUIManager].topicLabel.attributedText = topicAttributeding;
    
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP) {
        [TTPositionUIManager shareUIManager].topicLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        [TTPositionUIManager shareUIManager].topicLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)updateRoomPositionTypeWith:(TTRoomPositionViewType)positionType {
    _positonViewType = positionType;
    [TTPositionCoreManager shareCoreManager].positonViewType = _positonViewType;
}

@end
