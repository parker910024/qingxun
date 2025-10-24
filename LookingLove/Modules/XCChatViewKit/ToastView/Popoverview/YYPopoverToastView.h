//
//  YYPopoverToastView.h
//  YYMobile
//
//  Created by 武帮民 on 14-8-4.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYPopoverSide)
{
    YYPopoverSideUp,
    YYPopoverSideDown,
    YYPopoverSideLeft,
    YYPopoverSideRight,
    
    YYPopoverSideDefault = YYPopoverSideDown,
};

@interface YYPopoverToastView : UIView

+ (void)YYPopoverToastViewHide;

- (instancetype)initWithLiveNoticeInfo:(NSDictionary *)dic
                                       inView:(UIView *)inView
                                    arrowSide:(YYPopoverSide)side;

- (void)showPopoverViewWithTouchAction:(void(^)(NSDictionary *info))completion;

@end
