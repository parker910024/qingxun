//
//  VKPutDynamicInputBar.h
//  UKiss
//
//  Created by apple on 2019/2/18.
//  Copyright © 2019 yizhuan. All rights reserved.
// 发布动态页的底部bar

#import <UIKit/UIKit.h>
@class VKPutDynamicInputBar;

typedef NS_ENUM(NSInteger, VKInputBarStatus) {
    VKInputBarStatusAudio = 1,          //录音
    VKInputBarStatusText,           //文字键盘
    VKInputBarStatusEmoticon,        //表情键盘
    VKInputBarStatusVideoAndPicture,          //视频或图片
};

@protocol VKPutDynamicInputBarDelegate <NSObject>

///图片选择
- (void)putDynamicInputSelectedPictureCallBack;
///改变键盘模式
- (void)putDynamicInputBar:(VKPutDynamicInputBar *)inputBar changeInputBarStatus:(VKInputBarStatus)status;

@end

@interface VKPutDynamicInputBar : UIView
///选择图片按钮
@property (nonatomic, strong, readonly) UIButton *pictureBtn;
///录音按钮
@property (nonatomic, strong, readonly) UIButton *recordBtn;

@property (nonatomic, weak) id<VKPutDynamicInputBarDelegate> delegate;
///当前状态
@property (nonatomic, assign) VKInputBarStatus status;
///是否已经显示了键盘
@property (nonatomic, assign) BOOL isShowKeyboard;

@end
