//
//  TTAlertView.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPopupConstants.h"

@class TTAlertConfig;

NS_ASSUME_NONNULL_BEGIN

@interface TTAlertView : UIView

@property (nonatomic, strong) TTAlertConfig *config;// 配置

@property (nonatomic, copy) TTPopupCompletionHandler cancelAction;
@property (nonatomic, copy) TTPopupCompletionHandler confirmAction;
@property (nonatomic, copy) TTPopupCompletionHandler dismissAction;

@end

NS_ASSUME_NONNULL_END
