//
//  TTAppEvaluate.m
//  TuTu
//
//  Created by gzlx on 2018/12/14.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTAppEvaluate.h"
#import <StoreKit/StoreKit.h>
#import "SSCustomKeychain.h"

#import "AppScoreClient.h"
#import "VersionCore.h"
#import "XCCurrentVCStackManager.h"

#define SCORESERVERNAME     @"SCORESERVER"
@interface TTAppEvaluate ()<AppScoreClient>
@end


@implementation TTAppEvaluate

+ (instancetype)mainCenter{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        AddCoreClient(AppScoreClient, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}


- (void)ttaddAppReview:(NSString *)account{
    BOOL canContinue = NO;
    if ([[SSCustomKeychain passwordForService:SCORESERVERNAME account:account] integerValue] >= 1) { //之前已经弹过
        return;
    }else {
        [SSCustomKeychain setPassword:@"1" forService:SCORESERVERNAME account:account];
    }
    if (GetCore(VersionCore).loadingData) {
        return;
    }
    //    [SSCustomKeychain setPassword:encodeJson forService:@"json" account:@"face"];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"喜欢APP 么?给个五星好评吧亲!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //跳转APPStore 中应用的撰写评价页面
    UIAlertAction *review = [UIAlertAction actionWithTitle:@"我要吐槽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1449021132"]];//换成你应用的 APPID
        CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
        if (version >= 10.0) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:appReviewUrl];
        }
    }];
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:@"用用再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC removeFromParentViewController];
    }];
    
    //判断系统,是否添加五星好评的入口
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:@"五星好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }];
        [alertVC addAction:review];
        [alertVC addAction:noReview];
        [alertVC addAction:fiveStar];
    }else {
        [alertVC addAction:noReview];
        [alertVC addAction:review];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[XCCurrentVCStackManager shareManager]getCurrentVC]presentViewController:alertVC animated:YES completion:nil];
    });
}

- (void)needShowScoreView:(NSString *)account {
    [self ttaddAppReview:account];
}


@end
