//
//  TTTopAlertViewTool.m
//  TuTu
//
//  Created by Macx on 2018/11/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTTopAlertViewTool.h"
#import "AppDelegate.h"
#import "XCMacros.h"
#import "TTPopup.h"
#import "ClientCore.h"


@interface TTTopAlertViewTool ()
@property (nonatomic, assign) BOOL hadShow;
@property (nonatomic, strong) UIWindow *alWindow;
@end

@implementation TTTopAlertViewTool

+ (instancetype)shareTTTopAlertViewTool
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)ttShowUpdateViewWithDesc:(NSString *)desc version:(NSString *)version {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    NSDate *agoDate = [userDefault objectForKey:@"nowDate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *ageDateString = [dateFormatter stringFromDate:agoDate];
    NSString *nowDateString = [dateFormatter stringFromDate:now];
    NSString *message = [NSString stringWithFormat:@"升级提示:%@",version];
    if  (![ageDateString isEqualToString:nowDateString]){
            NSDate *nowDate = [NSDate date];
            
            [userDefault setObject:nowDate forKey:@"nowDate"];
            [userDefault synchronize];
        
            NSString *message = [NSString stringWithFormat:@"升级提示:%@",version];
            @KWeakify(self);
            LLForceUpdateView * view = [[LLForceUpdateView alloc] initWithTitle:message descriptionText:desc isForced:NO update:^{
                [TTPopup dismiss];
                @KStrongify(self);
                NSURL *url = [NSURL URLWithString:GetCore(ClientCore).updateUrl];
                if (iOS10) {
                    if([[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url options:@{}completionHandler:^(BOOL success) {
                        }];
                    }
                } else {
                    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            } close:^{
                [TTPopup dismiss];
            }];
            [TTPopup popupView:view style:TTPopupStyleAlert];
        }
}


- (void)ttShowForceUpdateViewWithDesc:(NSString *)desc version:(NSString *)version {
    NSString *message = [NSString stringWithFormat:@"升级提示:%@",version];
    @KWeakify(self);
    LLForceUpdateView * view = [[LLForceUpdateView alloc] initWithTitle:message descriptionText:desc isForced:YES update:^{
        @KStrongify(self);
        NSURL *url = [NSURL URLWithString:GetCore(ClientCore).updateUrl];
        if (iOS10) {
            if([[UIApplication sharedApplication] canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url options:@{}completionHandler:^(BOOL success) {
                }];
            }
        } else {
            if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } close:^{
        [TTPopup dismiss];
    }];
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = view;
    service.style = TTPopupStyleAlert;
    service.shouldDismissOnBackgroundTouch = NO;
    [TTPopup popupWithConfig:service];
}

- (void)ttShowBadNetworkAlertView {
    @KWeakify(self);
    if (!self.badNetworkAlertView) {
        self.badNetworkAlertView = [[XCBadNetworkAlertView alloc]initWithFrame:CGRectZero title:@"温馨提示" desc:@"请检查网络配置或确定设备是否联网" cancel:^{
            [TTPopup dismiss];
            @KStrongify(self);
            self.badNetworkAlertView = nil;
        } confirm:^{
            [TTPopup dismiss];
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (iOS10) {
                
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }else {
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        self.badNetworkAlertView.frame =  CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width * 0.7, 95);
        self.hadShow = YES;
        [TTPopup popupView:self.badNetworkAlertView style:TTPopupStyleAlert];
    }
}



@end
