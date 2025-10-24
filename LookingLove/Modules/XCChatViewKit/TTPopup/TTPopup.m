//
//  TTPopup.m
//  XC_TTChatViewKit
//
//  Created by lvjunhang on 2019/5/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPopup.h"
#import "TTAlertView.h"
#import "TTActionSheetView.h"
#import "TTPopupService.h"
#import "TTPopupManagerService.h"

static CGFloat const kActionSheetViewPadding = 15.f;
static CGFloat const kActionSheetViewCellHeight = 52.f;
static CGFloat const kActionSheetViewCancelViewHeight = 67.f;
static CGFloat const kActionSheetViewBottomPadding = 15.f;
static CGFloat const kMixHeight = 200.f;
static CGFloat const kMaxHeight = 450.f;

@implementation TTPopup

#pragma mark - Public Methods
#pragma mark Alert
+ (void)alertWithMessage:(NSString *)message
          confirmHandler:(TTPopupCompletionHandler)confirmHandler
           cancelHandler:(TTPopupCompletionHandler)cancelHandler {
    
    [self alertWithMessage:message
                    config:nil
              cancelHandler:cancelHandler
             confirmHandler:confirmHandler];
}

+ (void)alertWithConfig:(TTAlertConfig *)config
         confirmHandler:(TTPopupCompletionHandler)confirmHandler
          cancelHandler:(TTPopupCompletionHandler)cancelHandler {
    
    [self alertWithMessage:nil
                    config:config
              cancelHandler:cancelHandler
             confirmHandler:confirmHandler];
}

+ (void)alertWithMessage:(NSString *)message
                  config:(TTAlertConfig *)config
            cancelHandler:(TTPopupCompletionHandler)cancelHandler
           confirmHandler:(TTPopupCompletionHandler)confirmHandler {
    
    if (!config) {
        config = [[TTAlertConfig alloc] init];
        config.message = message;
    }
    
    if (config.message.length <= 0) {
        NSAssert(NO, @" message can not be nil, 弹窗文案不可以为空");
        return;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 40 * 2;
    CGFloat height = ([self messageSize:config.message width:width].height + 160);
    
    // 最小 200， 最大 450 
    if (height < kMixHeight) {
        height = kMixHeight;
    } else if (height > kMaxHeight) {
        height = kMaxHeight;
    }
    
    TTAlertView *contentView = [[TTAlertView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    contentView.config = config;
    contentView.cancelAction = cancelHandler;
    contentView.confirmAction = confirmHandler;
    
    if (!contentView.config.disableAutoDismissWhenClickButton) {
        // 设置弹窗按钮自动消除
        contentView.dismissAction = ^{
            [TTPopup dismiss];
        };
    }
    
    [self popupView:contentView style:TTPopupStyleAlert config:config];
}

#pragma mark Action Sheet
+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items {
    
    [TTPopup actionSheetWithItems:items showCancelItem:YES cancelHandler:nil];
}

+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items
              showCancelItem:(BOOL)showCancelItem {
    
    [TTPopup actionSheetWithItems:items showCancelItem:showCancelItem cancelHandler:nil];
}

+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items cancelHandler:(TTActionSheetClickAction)cancelHandler {
    
    [TTPopup actionSheetWithItems:items showCancelItem:YES cancelHandler:cancelHandler];
}

+ (void)actionSheetWithItems:(NSArray<TTActionSheetConfig *> *)items
              showCancelItem:(BOOL)showCancelItem
                cancelHandler:(TTActionSheetClickAction)cancelHandler {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - kActionSheetViewPadding * 2;
    CGFloat height = kActionSheetViewCellHeight * items.count + kActionSheetViewBottomPadding;
    
    // 如果需要显示取消按钮则增加响应的高度
    if (showCancelItem) {
        // 按钮的高度和间距
        height += kActionSheetViewCancelViewHeight;
    }
    
    if (@available(iOS 11.0, *)) {
        // 如果是 iPhone X 系列(刘海屏幕系列) 底部则需要添加 34 的高度
        height += [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    TTActionSheetView *sheetView = [[TTActionSheetView alloc] initWithFrame:rect
                                                                 needCancel:showCancelItem
                                                                      items:items];
    sheetView.cancelAction = cancelHandler;

    // 设置弹窗按钮自动消除
    sheetView.dismissAction = ^{
        [TTPopup dismiss];
    };
    
    [self popupView:sheetView style:TTPopupStyleActionSheet];
}


#pragma mark Popup
+ (void)popupView:(UIView *)customView
            style:(TTPopupStyle)style {
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.style = style;
    service.contentView = customView;
    
    [self popupWithConfig:service];
}

+ (void)popupView:(UIView *)customView
            style:(TTPopupStyle)style
           config:(TTAlertConfig *)config {
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.style = style;
    service.contentView = customView;
    service.shouldDismissOnBackgroundTouch = config.shouldDismissOnBackgroundTouch;
    service.maskBackgroundAlpha = config.maskBackgroundAlpha;
    [self popupWithConfig:service];
}


+ (void)popupWithConfig:(TTPopupService *)config {
    
    if (![config.contentView isKindOfClass:UIView.class]) {
        NSAssert(NO, @"TTPopup customView should inherit from UIView.");
        return;
    }
    
    [[TTPopupManagerService sharedInstance] addPopupService:config];
}

#pragma mark Dismiss
+ (void)dismiss {
    [[TTPopupManagerService sharedInstance] removePopupService];
}

#pragma mark Query
/**
 当前是否有显示弹窗
 */
+ (BOOL)hasShowPopup {
    return [TTPopupManagerService sharedInstance].currentPopupService != nil;
}

#pragma mark - Privite
+ (CGSize)messageSize:(NSString *)text width:(CGFloat)width {
    CGRect stringRect = [text boundingRectWithSize:CGSizeMake(width - 2 * 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil];
    return stringRect.size;
}

@end
