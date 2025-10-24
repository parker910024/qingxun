//
//  TTFunctionMenuItem.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TTFunctionMenuItemTag_Room_OfficalManager,
    TTFunctionMenuItemTag_GiftEffect_Close,
    TTFunctionMenuItemTag_GiftEffect_Open,
    TTFunctionMenuItemTag_RoomMessage_Close,
    TTFunctionMenuItemTag_RoomMessage_Open,
    TTFunctionMenuItemTag_Room_Share,
    TTFunctionMenuItemTag_Room_Setting,
    TTFunctionMenuItemTag_Room_Manager,
    TTFunctionMenuItemTag_Room_Limit,
    TTFunctionMenuItemTag_Room_Game,
    TTFunctionMenuItemTag_Room_GuildManager,//模厅管理
    TTFunctionMenuItemTag_GiftValue_Close,//礼物值关
    TTFunctionMenuItemTag_GiftValue_Open,//礼物值开
    TTFunctionMenuItemTag_Redbag_Open,//红包开
    TTFunctionMenuItemTag_Redbag_Close//红包关
} TTFunctionMenuItemTag;

@interface TTFunctionMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) TTFunctionMenuItemTag functionTag;

+ (instancetype)itemWithFunctionTag:(TTFunctionMenuItemTag)functionTag title:(NSString *)title imageName:(NSString *)imageName;

@end
