//
//  TTDatePickView.h
//  TuTu
//
//  Created by Macx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTDatePickViewDelegate<NSObject>
@optional
//取消
- (void)ttDatePickCancelAction;
//确认选择  年月日   时间
- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date;
//不满足  限制
- (void)ttDatePickLimitAction;
- (void)ttDatePickEnsureActionStartTime:(NSString *)startYMd endTime:(NSString *)endYMD date:(NSDate *)date;
@end

@interface TTDatePickView : UIView
@property (nonatomic, weak) id<TTDatePickViewDelegate>  delegate;//
// 时间显示格式 YYYY-MM-dd 或者 是 YYYY年MM月dd日
@property (nonatomic, copy) NSString *dateFormat;
@property (nonatomic, assign) int limitAge;//
//YYYY-MM-dd 设置当前日期
@property (nonatomic, strong) NSString  *atTime;//
// 设置当前日期  时间戳
@property (nonatomic, assign) NSTimeInterval time;//
//最大日期
@property (nonatomic, strong) NSDate  *maximumDate;//
//最小日期
@property (nonatomic, strong) NSDate  *minimumDate;//
// 每周显示
@property (nonatomic, assign) BOOL isWeek;
@end
