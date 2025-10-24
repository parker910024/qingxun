//
//  TTFunctionMenuButton.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TTFunctionMenuButtonType_OfficalManager,      //官方管理
    TTFunctionMenuButtonType_MicroSwitch,         //麦克风
    TTFunctionMenuButtonType_VolumeSwitch,        //喇叭
    TTFunctionMenuButtonType_Chat,                //聊天
    TTFunctionMenuButtonType_Face,                //表情
    TTFunctionMenuButtonType_More,                //更多
    TTFunctionMenuButtonType_Gift,                //礼物
    TTFunctionMenuButtonType_QueueMike,           // 排麦
    TTFunctionMenuButtonType_Game,                // 游戏
     TTFunctionMenuButtonType_RoomMessage,        //房间的私聊入口
} TTFunctionMenuButtonType;


@interface TTFunctionMenuButton : UIButton

@property (nonatomic, assign) TTFunctionMenuButtonType type;
@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *disableImage;
@property (nonatomic, copy) NSString *selectedImage;

- (void)setButtonNormalImage:(NSString *)normalImage disableImage:(NSString *)disableImage selectedImage:(NSString *)selectedImage;

@end
