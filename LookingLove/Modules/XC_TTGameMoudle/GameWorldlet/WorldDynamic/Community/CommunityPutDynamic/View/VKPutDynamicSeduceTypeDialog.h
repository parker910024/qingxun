//
//  VKPutDynamicSeduceTypeDialog.h
//  UKiss
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VKPutDynamicSeduceType) {
    VKPutDynamicSeduceTypeText = 1,         //文字私聊
    VKPutDynamicSeduceTypeVoice,        //语音私聊
};

@interface VKPutDynamicSeduceTypeDialog : UIView

///勾搭方式
@property (nonatomic, assign) VKPutDynamicSeduceType type;
///选择回调
@property (nonatomic, copy) void (^selectedBlock)(VKPutDynamicSeduceType type);

@end
