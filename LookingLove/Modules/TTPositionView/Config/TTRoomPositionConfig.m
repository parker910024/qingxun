//
//  TTRoomPositionConfig.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTRoomPositionConfig.h"
#import "XCMacros.h"
#import "TTPositionUIManager.h"
#import "UIView+NTES.h"

@implementation TTRoomPositionConfig
+ (TTRoomPositionConfig *)globalConfig {
    
    static TTRoomPositionConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [TTRoomPositionConfig new];
    });
    return config;
}

- (instancetype)init {
    if(self=[super init]) {
//        [self tutuPositionItemConfig];
    }
    return self;
}

#pragma mark - private method
- (void)tutuPositionItemConfig {
    
    self.PositionPaddingAndNickHeight = 20;//坑位下padding与昵称的总高度
    
    self.NormalOwnerItemWidth = 65; //房主坑宽
    self.NormalOwnerItemHeight = (self.NormalOwnerItemWidth+self.PositionPaddingAndNickHeight);//房主坑高
    self.NormalItemWidth = 55;//普通坑宽
    self.NormalItemHeight = (self.NormalItemWidth+self.PositionPaddingAndNickHeight);//普通坑高
    
    self.padding = 15;//item上下距离
    self.messageAndPositonPadding = 0;//公屏与位置view的距离
    self.kSpeakingAnimationDuration = 1.8;//光圈动画时长
    self.headwearVSAvater = 1.31;//头饰vs头像 的比例
}

// 相亲房坑位
- (void)loveRoomPositionItemConfig {
    self.PositionPaddingAndNickHeight = 19;//坑位下padding与昵称的总高度
    
    self.NormalOwnerItemWidth = 60; //房主坑宽
    self.NormalOwnerItemHeight = (self.NormalOwnerItemWidth + self.PositionPaddingAndNickHeight);//房主坑高
    self.NormalItemWidth = 50;//普通坑宽
    self.NormalItemHeight = (self.NormalItemWidth + self.PositionPaddingAndNickHeight);//普通坑高 头像的宽度+名字的高度加上padding+ padding+礼物值的高度
    
    self.padding = 15;//item上下距离
    self.messageAndPositonPadding = 0;//公屏与位置view的距离
    self.kSpeakingAnimationDuration = 1.8;//光圈动画时长
    self.headwearVSAvater = 1.31;//头饰vs头像 的比例
}

/** 更新整体麦位的高度*/
- (CGFloat)updateTTPositionHeight:(TTRoomPositionViewLayoutStyle)style positionType:(TTRoomPositionViewType)positionType {
    CGFloat heigt;
    
    CGFloat mvheight = 198;
    if (KScreenHeight < 667) {
        mvheight = 210;
    }
    if (style == TTRoomPositionViewLayoutStyleCP) {
        if (positionType == TTRoomPositionViewTypeCPGame){
            heigt =  KScreenWidth * 0.58 + 154;
        }else{
            heigt = 195;
        }
    }else if (style == TTRoomPositionViewLayoutStyleNormal){
        heigt = 312;
    } else if (style == TTRoomPositionViewLayoutStyleLove) {
        heigt = 267;
    } else {
        heigt = 0;
    }
    [TTPositionUIManager shareUIManager].positionView.size = CGSizeMake(KScreenWidth, heigt);
    return heigt;
}


@end
