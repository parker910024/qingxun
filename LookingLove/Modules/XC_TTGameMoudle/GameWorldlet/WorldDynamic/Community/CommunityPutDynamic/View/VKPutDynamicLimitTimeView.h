//
//  VKPutDynamicLimitTimeView.h
//  UKiss
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 yizhuan. All rights reserved.
//  限时功能

#import <UIKit/UIKit.h>
@class VKPutDynamicLimitTimeView;
typedef NS_ENUM(NSInteger, VKPutDynamicLimitTimeType) {
    VKPutDynamicLimitTimeTypeSeduce = 1,      //勾搭方式
    VKPutDynamicLimitTimeTypeRedPackage,      //发红包
};

@protocol VKPutDynamicLimitTimeViewDelegate <NSObject>

///点击回调
- (void)clickLimitTimeWithLimitTimeType:(VKPutDynamicLimitTimeType)type;

@end

@interface VKPutDynamicLimitTimeView : UIView
///类型
@property (nonatomic, assign) VKPutDynamicLimitTimeType type;
///提示文本
@property (nonatomic, copy) NSString *detailsStr;
///图片名称
@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, weak) id<VKPutDynamicLimitTimeViewDelegate> delegate;

///创建方式
- (instancetype)initWithFrame:(CGRect)frame type:(VKPutDynamicLimitTimeType)type;

@end
