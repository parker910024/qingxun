//
//  CTInputBarItemType.h
//  CTKit
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 NetEase. All rights reserved.
//

#ifndef CTInputBarItemType_h
#define CTInputBarItemType_h

typedef NS_ENUM(NSInteger,CTInputBarItemType){
    CTInputBarItemTypeVoice,         //录音文本切换按钮
    NIMInputBarItemTypeTextAndRecord, //文本输入框或录音按钮
    CTInputBarItemTypeEmoticon,      //表情贴图
    CTInputBarItemTypeMore,          //更多菜单
    CTInputBarItemTypeCP,          //图片
    CTInputBarItemTypePicture,          //cp
    CTInputBarItemTypeSendButton, // 发送按钮
};




#endif /* CTInputBarItemType_h */
