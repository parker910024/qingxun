//
//  PanelInfor.h
//  BberryCore
//
//  Created by gzlx on 2018/4/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "panelId":4,
 "panelName":"打怪兽",
 "skipType":3,
 "skipUrl":"http://beta.erbanyy.com/modules/monster/intro.html",
 "panelPic":"https://img.erbanyy.com/Fng-fgNDxlE3uA-IDhAGMqpT-R9F?imageslim",
 "seqNo":4
 */
typedef NS_ENUM(NSInteger, PanleSkipType){
    PanleSkipTypePage =1,
    PanleSkipTypeRoom =2,
    PanleSkipTypeWeb= 3,
};




@interface PanelInfor : NSObject

@property (nonatomic, strong) NSString *panelId;//面板id
@property (nonatomic, strong) NSString *panelName;//面板名称
@property (nonatomic, assign) int skipType;//跳转类型 1跳app页面，2跳聊天室，3跳h5页面
@property (nonatomic, strong) NSString *skipUrl;//跳转地址
@property (nonatomic, strong) NSString *panelPic;//面板背景图
@property (nonatomic, assign) int seqNo;//排序
@end
