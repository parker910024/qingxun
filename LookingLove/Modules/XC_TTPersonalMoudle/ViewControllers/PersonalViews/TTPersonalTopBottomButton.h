//
//  TTPersonalTopBottomButton.h
//  TuTu
//
//  Created by Macx on 2018/11/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FunctionType) {
    FunctionType_Family = 0,//家族
    FunctionType_Income,  //收入
    FunctionType_Recharge, //充值
    FunctionType_Dressup, //装扮商城
    FunctionType_Nobile, //贵族特权
    FunctionType_Setting, //设置
    FunctionType_Follow,  //关注
    FunctionType_Fans,  //粉丝
    FunctionType_Level,  //等级
    FunctionType_Charm,  //魅力等级
};

@interface TTPersonalTopBottomButton : UIView
@property (nonatomic, assign,readonly) FunctionType type;//

@property (nonatomic, strong) NSString  *subTitle;//

/**
 创建图片文字

 @param title 标题
 @param image 图片
 @param type 类型
 @param action 回调block
 @return 图片文字 按钮
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(FunctionType)type action:(void(^)(FunctionType type))action;

/**
 创建文字
 
 @param title 标题
 @param subTitle 副标题
 @param type 类型
 @param action 回调block
 @return 图片文字 按钮
 */
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(FunctionType)type action:(void(^)(FunctionType type))action;

@end
