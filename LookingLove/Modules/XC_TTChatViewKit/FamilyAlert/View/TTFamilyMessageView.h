//
//  TTFamilyMessageView.h
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFamilyAlertModel.h"

@protocol TTFamilyMessageViewDelegate <NSObject>
/** 文字编辑*/
- (void)textFiledChangeWith:(UITextField *)textFiled;
/** 处理点击取消*/
- (void)cancleDismissWith:(UIButton *)sender;
/**处理点击确认*/
- (void)sureButtonActionWith:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyMessageView : UIView

- (id)initWithFrame:(CGRect)frame withConfig:(TTFamilyAlertModel *)config;

@property (nonatomic, assign) id<TTFamilyMessageViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
