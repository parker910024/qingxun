//
//  YYHudToastView.h
//  YYMobile
//
//  Created by 武帮民 on 14-8-12.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYHudToastView : UIView

+ (instancetype)HudToastViewWithAttributedMessage:(NSAttributedString *)attributed
                                           inRect:(CGRect)lastViewRect;

- (void)toastBackgroudColor:(UIColor *)color;

@end
