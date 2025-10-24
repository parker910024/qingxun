//
//  TTFamilyShareAlertView.h
//  TuTu
//
//  Created by gzlx on 2018/11/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFamilyAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilyShareAlertViewDelegate <NSObject>
/** 取消*/
- (void)cancleActionDismissAlertView:(UIButton *)sender;
/**确认按钮可以做的事情*/
- (void)sureButtonActionWith:(UIButton *)sender;

@end

@interface TTFamilyShareAlertView : UIView

@property (nonatomic, assign) id<TTFamilyShareAlertViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame config:(TTFamilyAlertModel *)config;

@end

NS_ASSUME_NONNULL_END
