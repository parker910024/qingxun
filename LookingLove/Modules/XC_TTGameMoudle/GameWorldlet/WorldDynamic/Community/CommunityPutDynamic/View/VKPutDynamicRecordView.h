//
//  VKPutDynamicRecordView.h
//  UKiss
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019 yizhuan. All rights reserved.
//  发布动态页的录音界面

#import <UIKit/UIKit.h>
#import "VKRecordButton.h"
@class VKPutDynamicRecordView;

@protocol VKPutDynamicRecordViewDelegate <NSObject>
///状态改变
- (void)putDynamicRecordView:(VKPutDynamicRecordView *)recordView changeRecordStatusCallBack:(VKRecordViewStatus)status;
///删除回调
- (void)deleteRecordFileCallBack;
///确定回调
- (void)finishedActionCallBack;
@end

@interface VKPutDynamicRecordView : UIView

///录音状态
@property (nonatomic, assign) VKRecordViewStatus status;

@property (nonatomic, weak) id<VKPutDynamicRecordViewDelegate> delegate;

@property (nonatomic, copy) NSString *titleStr;
//进度
@property (nonatomic, assign) CGFloat progress;

@end
