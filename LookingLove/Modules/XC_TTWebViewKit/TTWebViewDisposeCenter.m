//
//  TTWebViewHandleCenter.m
//  TuTu
//
//  Created by 卫明 on 2018/11/20.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTWebViewDisposeCenter.h"
//core
#import "NobleCore.h"
//client
#import "NobleCoreClient.h"
//toast
#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"
//const
#import "XCMacros.h"
#import "XCHtmlUrl.h"
//host
#import "HostUrlManager.h"

@interface TTWebViewDisposeCenter ()
<
NobleCoreClient
>
@end

@implementation TTWebViewDisposeCenter

static TTWebViewDisposeCenter *instance;

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(NobleCoreClient, self);
    }
    return self;
}

#pragma mark - public method

- (void)disposeNobleOrder:(NSDictionary *)params {
    [GetCore(NobleCore)requestNobleOrderByProductId:params[@"iosNobleId"]
                                            nobleId:params[@"nobleId"]
                                       nobleOptType:[params[@"nobleOptType"] intValue]];
}

#pragma mark - NobleCoreClient
//下单失败
- (void)addNobleRechargeOrderFail:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool hideHUD];
        [self popToRootVC];
    });
}

//查询商品
- (void)entryNobleRequestProductProgressStatus:(BOOL)Status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool hideHUD];
        if (Status == YES) {
            [XCHUDTool showSuccessWithMessage:@"正在发起购买，请耐心等待"];
        } else {
            [XCHUDTool showErrorWithMessage:@"网络异常，发起购买失败"];
            [self popToRootVC];
        }
    });
}
//进入购买流程
- (void)entryNoblePurchaseProcessStatus:(XCPaymentStatus)Status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool hideHUD];
        switch (Status) {
            case XCPaymentStatusPurchased:
            {
                [XCHUDTool showSuccessWithMessage:@"正在验证"];
            }
                break;
            case XCPaymentStatusPurchasing:
            {
                [XCHUDTool showSuccessWithMessage:@"购买中"];
            }
                break;
            case XCPaymentStatusFailed:
            {
                //            [UIView showToastInKeyWindow:@"购买失败" duration:2.0 position:YYToastPositionCenter];
                [XCHUDTool showErrorWithMessage:@"购买失败"];
                [self popToRootVC];
            }
                break;
            case XCPaymentStatusDeferred:
            {
                [XCHUDTool showErrorWithMessage:@"出现未知错误，请重新尝试"];
                
                [self popToRootVC];
            }
                break;
            default:
                break;
        }
    });
}
//二次验证成功
- (void)entryNobleCheckReceiptSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool showSuccessWithMessage:@"购买成功"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[HostUrlManager shareInstance].hostUrl,HtmlUrlKey(kNobilitySuccessURL)]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    });
}

- (void)entryNobleCheckReceiptFaildWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XCHUDTool showSuccessWithMessage:@"验证失败，请稍后再试"];
        [self popToRootVC];
    });
}

#pragma mark - private method

- (void)popToRootVC {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XCCurrentVCStackManager shareManager].currentNavigationController popToRootViewControllerAnimated:YES];
    });
}

@end

