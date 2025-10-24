//
//  TTBindSuccessView.h
//  TuTu
//
//  Created by lee on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTBindViewDismissHandler)(void);
@interface TTBindSuccessView : UIView

@property (nonatomic, copy) TTBindViewDismissHandler dismissHandler;

+ (void)showBindSuccessViewWithHandler:(TTBindViewDismissHandler)handler;

@end

NS_ASSUME_NONNULL_END
