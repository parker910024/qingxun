//
//  TTPositionViewUIImpl.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionViewUIImpl.h"
//tool
#import "TTPositionUIManager.h"
#import "TTPositionCoreManager.h"
#import "TTRoomPositionConfig.h"
#import "TTPositionHelper.h"
#import "XCMacros.h"
//view
#import "TTPositionItem.h"
//categary
#import "NSArray+Safe.h"
#import "UIView+NTES.h"
//core
#import "RoomQueueCoreV2.h"
#import "ImRoomCoreV2.h"
#import "RoomCoreV2.h"
#import "TTGameStaticTypeCore.h"

@interface TTPositionViewUIImpl ()
/** 坑位的样式*/
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle  style;
/** 房间的模式*/
@property (nonatomic, assign) TTRoomPositionViewType positonViewType;
/** 麦位位置的配置*/
@property (nonatomic,strong) TTRoomPositionConfig *config;
@end


@implementation TTPositionViewUIImpl

- (instancetype)initPositionUIImplStyle:(TTRoomPositionViewLayoutStyle)style positonViewType:(TTRoomPositionViewType)positonViewType{
    if (self = [super init]) {
        self.style = style;
        self.positonViewType = positonViewType;
        self.config = [TTRoomPositionConfig globalConfig];
    }
    return self;
}


- (void)isShowPositionVipViewWithRoomInfor:(RoomInfo *)info {
    if (self.style == TTRoomPositionViewLayoutStyleNormal) {
        NSArray  * positions = [GetCore(ImRoomCoreV2).micQueue allKeys];
        for (NSString * position in positions) {
            if ([position isEqualToString:@"7"]) {
                [[TTPositionUIManager shareUIManager].positionVipView hiddenPositionVipView];
                //如果是牌照房 或者是新秀的话
                BOOL showVip = [[TTPositionHelper shareHelper] showTTPositionVipViewWith:self.style];
                if (showVip) {
                    [[TTPositionUIManager shareUIManager].positionVipView showPositionVipView];
                }
            }
            break;
        }
    }
}

/** 房间信息更新的时候 更新房主离开模式*/
- (void)configRoonInfoUpdateToUpOwnerPositionView {
    // 离开模式按钮
    TTPositionItem * item = [[TTPositionUIManager shareUIManager].positionItems firstObject];
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
        GetCore(TTGameStaticTypeCore).openRoomStatus != OpenRoomType_CP) {  // 如果是房主位且开启了离开模式
        item.iSShowLeave = YES;
    } else {
        item.iSShowLeave = NO;;
    }
}


/**
 重置所有坑位礼物值
 */
- (void)resetAllPositionItemGiftValue {
    for (TTPositionItem *item in [TTPositionUIManager shareUIManager].positionItems) {
        [item resetGiftValue];
    }
}

/**
 清空关闭离开模式后房主位遗留的礼物值
 */
- (void)clearOwnerPositionGiftValueWhenOffLeaveMode {
    
    BOOL notLeaveMode = self.positonViewType != TTRoomPositionViewTypeOwnerLeave;
    notLeaveMode = YES;
    NSString *ownerPositionFlag = @"-1"; // 房主位
    UserInfo *ownerPositionInfo = [GetCore(ImRoomCoreV2).micQueue objectForKey:ownerPositionFlag].userInfo;
    BOOL isShowGiftValue = [TTPositionCoreManager shareCoreManager].isShowGiftValue;
    if (isShowGiftValue && notLeaveMode && ownerPositionInfo == nil) {
        for (TTPositionItem *item in [TTPositionUIManager shareUIManager].positionItems) {
            if ([item.position isEqualToString:ownerPositionFlag]) {
                [item resetGiftValue];
                break;
            }
        }
    }
}


//坑位布局
#pragma mark --- 坑位的布局 ---
- (void)updateRoomPositionTypeWith:(TTRoomPositionViewType)positonViewType {
    //如果新的模式和以前的模式一样的话 就不需要更新
    TTPositionUIManager * manager = [TTPositionUIManager shareUIManager];
     [[TTRoomPositionConfig globalConfig] updateTTPositionHeight:self.style positionType:[[TTPositionHelper shareHelper] configTTRoomPositionViewType:self.style]];
    self.positonViewType = positonViewType;
    //更换类型的时候 清空以前存储的位置信息
    [manager.positionLoactionArray removeAllObjects];
    TTPositionItem *ownerItem = [TTPositionUIManager shareUIManager].positionItems.firstObject;
    CGFloat maxY = [TTPositionUIManager shareUIManager].positionView.height;
    //如果是普通模式(九个坑位)
    if (self.style == TTRoomPositionViewLayoutStyleNormal) {
        if (self.positonViewType == TTRoomPositionViewTypeNormal) {
            //普通模式的话 要重新更新一下 麦位的frame
            [self layoutSubItems:maxY ownerItem:ownerItem uiManager:manager];
        } else {
            //为了防止某个模式没有的时候 如果重新赋值的话 会有问题
            [self layoutSubItems:maxY ownerItem:ownerItem uiManager:manager];
        }
    }else if (self.style == TTRoomPositionViewLayoutStyleCP) {
        if (self.positonViewType == TTRoomPositionViewTypeCP) {
            [self layoutStyleCpRoomPositionTypeNormalWith:maxY ownerItem:ownerItem uiManager:manager];
        } else if (self.positonViewType == TTRoomPositionViewTypeCPGame) {
            [self layoutStyleCpRoomPositionTypeCPGameWith:maxY ownerItem:ownerItem uiManager:manager];
        }else{
            [self layoutStyleCpRoomPositionTypeNormalWith:maxY ownerItem:ownerItem uiManager:manager];
        }
    } else if (self.style == TTRoomPositionViewLayoutStyleLove) {
        if (self.positonViewType == TTRoomPositionViewTypeLove) {
            [self loveRoomLayoutSubItems:maxY ownerItem:ownerItem uiManager:manager];
        }
    }
    [manager setupContainerVeiwConstraints];
}

//CP房的游戏
- (void)layoutStyleCpRoomPositionTypeCPGameWith:(CGFloat)maxY ownerItem:(TTPositionItem *)ownerItem uiManager:(TTPositionUIManager *)manager {
    ownerItem.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
    ownerItem.right = manager.positionView.width / 2 - 23 - 25;
    CGFloat centerX = ownerItem.centerX;
    CGFloat centerY = manager.positionView.height - ((156 - 50) / 2) - 25;
    ownerItem.center = CGPointMake(centerX, centerY);
    
    manager.topicLabel.frame = CGRectMake(17, CGRectGetMaxY(ownerItem.frame) + 24, manager.positionView.width - 17, 15);
    
    CGPoint owenCenter = CGPointMake(centerX, centerY - self.config.PositionPaddingAndNickHeight/2);
    
    [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:owenCenter]];
    
    for (int i = 1; i < 2; i++) {
        //item的frame
        TTPositionItem *item = [manager.positionItems objectAtIndex:i];
        item.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
        item.left = manager.positionView.width / 2 + 23 + 25;
        
        CGFloat centerX = item.centerX;
        CGFloat centerY = manager.positionView.height - ((156 - 50) / 2) - 25;
        
        item.center = CGPointMake(centerX, centerY);
        
        //计算item头像中点，保存到RoomCoreV2
        CGPoint center = CGPointMake(centerX, centerY-self.config.PositionPaddingAndNickHeight/2);
        [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:center]];
    }
    [GetCore(RoomCoreV2) savePosition:manager.positionLoactionArray];
}

//普通房的普通模式
- (void)layoutSubItems:(CGFloat)maxY ownerItem:(TTPositionItem *)ownerItem uiManager:(TTPositionUIManager *)manager {
    
    maxY -= self.config.messageAndPositonPadding;//坑位最大Y值
    //房主位frame
    ownerItem.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
    ownerItem.center = CGPointMake(manager.positionView.width/2, self.config.NormalOwnerItemHeight/2);
    //计算房主位头像中点，保存到RoomCoreV2
    CGPoint ownerItemCenter = CGPointMake(manager.positionView.width/2, (self.config.NormalOwnerItemHeight-self.config.PositionPaddingAndNickHeight)/2);
    [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:ownerItemCenter]];
    
    //主题frame
    manager.topicLabel.frame = CGRectMake(0, CGRectGetMaxY(ownerItem.frame)+8, manager.positionView.width, 15);
    
    //position的间距
    CGFloat margin_gap = 25*KScreenWidth/375;
    CGFloat margin_ww = (manager.positionView.width-self.config.NormalItemWidth*4-margin_gap*2)/(4-1);
    
    for (int i = 1; i < manager.positionItems.count; i++) {
        //item的frame
        TTPositionItem *item = [manager.positionItems objectAtIndex:i];
        item.frame = CGRectMake(0, 0, self.config.NormalItemWidth, self.config.NormalItemHeight);
        [item layoutIfNeeded];
        //最左边间距 row *间距 + row * 宽度 + 宽度的一半
        int row = (i-1)%4;
        CGFloat centerX = margin_gap + margin_ww*row + self.config.NormalItemWidth*row + self.config.NormalItemWidth/2;
        
        //y:y从底部开始布局 maxY - (昵称高度+宽度一半)*i - (宽度一半 +item上下间距)*i
        //(2-(i-1)/4): 1-4的位置需要为2 5-8需要为1
        // abs((i-1)/4-1)) :1-4的位置需要为1  5-8为0
        CGFloat centerY = maxY-(self.config.PositionPaddingAndNickHeight+self.config.NormalItemWidth/2)*(2-(i-1)/4)-(self.config.NormalItemWidth/2+self.config.padding)*abs((i-1)/4-1);
        
        item.center = CGPointMake(centerX, centerY);
        
        //计算item头像中点，保存到RoomCoreV2
        CGPoint center = CGPointMake(centerX, centerY-self.config.PositionPaddingAndNickHeight/2);
        [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:center]];
    }
    //保存一个下 麦位的frame
    [GetCore(RoomCoreV2) savePosition:manager.positionLoactionArray];
}


//cp房的普通模式
- (void)layoutStyleCpRoomPositionTypeNormalWith:(CGFloat)maxY ownerItem:(TTPositionItem *)ownerItem uiManager:(TTPositionUIManager *)manager {
    manager.topicLabel.frame = CGRectMake(17, manager.positionView.height - 15, manager.positionView.width - 17, 15);
    ownerItem.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
    ownerItem.right = manager.positionView.width / 2 - 23 - 25;
    
    CGFloat centerX = ownerItem.centerX;
    
    //y:y从底部开始布局 maxY - (昵称高度+宽度一半)*i - (宽度一半 +item上下间距)*i
    //(2-(i-1)/4): 1-4的位置需要为2 5-8需要为1
    // abs((i-1)/4-1)) :1-4的位置需要为1  5-8为0
    CGFloat centerY = manager.positionView.height / 2;
    
    ownerItem.center = CGPointMake(centerX, centerY);
    
    CGPoint owenCenter = CGPointMake(centerX, centerY - self.config.PositionPaddingAndNickHeight/2);
    
    [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:owenCenter]];
    
    for (int i = 1; i < manager.positionItems.count; i++) {
        //item的frame
        TTPositionItem *item = [manager.positionItems objectAtIndex:i];
        item.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
        item.left = manager.positionView.width / 2 + 23 + 25;
        //最左边间距 row *间距 + row * 宽度 + 宽度的一半
        //            int row = (i)%4;
        CGFloat centerX = item.centerX;
        
        //y:y从底部开始布局 maxY - (昵称高度+宽度一半)*i - (宽度一半 +item上下间距)*i
        //(2-(i-1)/4): 1-4的位置需要为2 5-8需要为1
        // abs((i-1)/4-1)) :1-4的位置需要为1  5-8为0
        CGFloat centerY = manager.positionView.height / 2;
        
        item.center = CGPointMake(centerX, centerY);
        
        //计算item头像中点，保存到RoomCoreV2
        CGPoint center = CGPointMake(centerX, centerY-self.config.PositionPaddingAndNickHeight/2);
        [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:center]];
    }
    //保存一个下 麦位的frame
    [GetCore(RoomCoreV2) savePosition:manager.positionLoactionArray];
}

// 相亲房的普通模式
- (void)loveRoomLayoutSubItems:(CGFloat)maxY ownerItem:(TTPositionItem *)ownerItem uiManager:(TTPositionUIManager *)manager {
    
    maxY -= self.config.messageAndPositonPadding;//坑位最大Y值
    //房主位frame
    ownerItem.frame = CGRectMake(0, 0, self.config.NormalOwnerItemWidth, self.config.NormalOwnerItemHeight);
    ownerItem.center = CGPointMake(manager.positionView.width/2, self.config.NormalOwnerItemHeight/2);
    //计算房主位头像中点，保存到RoomCoreV2
    CGPoint ownerItemCenter = CGPointMake(manager.positionView.width/2, (self.config.NormalOwnerItemHeight-self.config.PositionPaddingAndNickHeight)/2);
    [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:ownerItemCenter]];
    
    //主题frame
    manager.topicLabel.frame = CGRectMake(0, CGRectGetMaxY(ownerItem.frame)+5, manager.positionView.width, 15);
    
    //position的间距
    CGFloat margin_gap = 15.5;
    CGFloat topPadding = self.config.padding;
    CGFloat margin_ww = 20 * KScreenWidth/375;
    CGFloat topFloat = CGRectGetMaxY(manager.topicLabel.frame) + 15;
    
    for (int i = 1; i < manager.positionItems.count; i++) {
        CGFloat centerX = 0.0;
        CGFloat centerY = 0.0;
        //item的frame
        TTPositionItem *item = [manager.positionItems objectAtIndex:i];
        item.frame = CGRectMake(0, 0, self.config.NormalItemWidth, self.config.NormalItemHeight);
        [item layoutIfNeeded];
        
        if (i < 5) {
            int row = (i - 1) % 2;
            centerX = margin_gap + margin_ww * row + self.config.NormalItemWidth * row + self.config.NormalItemWidth / 2;
            int row1 = (i - 1) / 2;
            //y:y从顶部开始布局 计算头像的中心点
            centerY = self.config.NormalItemHeight / 2 + (self.config.NormalItemHeight) * row1 + topFloat + topPadding * row1;
        } else {
            int row = i % 2;
            centerX = KScreenWidth - (margin_gap + margin_ww * row + self.config.NormalItemWidth * row + self.config.NormalItemWidth / 2);
            int row1 = (i - 3) / 4;
            //y:y从顶部开始布局 计算头像的中心点
            centerY = self.config.NormalItemHeight / 2 + (self.config.NormalItemHeight) * row1 + topFloat + topPadding * row1;
        }
        
        item.center = CGPointMake(centerX, centerY);
        
        //计算item头像中点，保存到RoomCoreV2
        CGPoint center = CGPointMake(centerX, centerY-self.config.PositionPaddingAndNickHeight/2);
        [manager.positionLoactionArray addObject:[NSValue valueWithCGPoint:center]];
    }
    //保存一个下 麦位的frame
    [GetCore(RoomCoreV2) savePosition:manager.positionLoactionArray];
}

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate {
    [[TTPositionUIManager shareUIManager] onCurrentRoomInfoUpdate];
}

/** 进入房间成功 */
- (void)enterChatRoomSuccess {
    [[TTPositionUIManager shareUIManager] enterChatRoomSuccess];
}

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager {
    [[TTPositionUIManager shareUIManager] updateCurrentUserRole:isManager];
}

#pragma mark  获取我自己是否上麦的状态
// 获取我自己是否上麦的状态
- (void)getRoomOnMicStatus:(RoomQueueUpateType)type position:(int)position {
    [[TTPositionUIManager shareUIManager] getRoomOnMicStatus:type position:position];
}
@end
