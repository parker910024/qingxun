//
//  VersionCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/11/9.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "VersionCore.h"
#import "VersionCoreClient.h"
#import "HttpRequestHelper+version.h"
#import "YYUtility.h"
#import <AFNetworkReachabilityManager.h>
#import "VersionInfo.h"
#import "NSObject+YYModel.h"
#import "AuthCoreClient.h"

@interface VersionCore () <AuthCoreClient>



@end


@implementation VersionCore

+ (void)load{
    GetCore(VersionCore);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(AuthCoreClient, self);
        self.loadingData = YES;
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}



//查询当前比例
- (NSString *)getExchangeRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *exchangeRate = [defaults stringForKey:@"exchangeRate"]; //

    if (!exchangeRate.length) {
        exchangeRate = @"0";
    }

    return exchangeRate;
}

- (void)setExchangeRate:(NSString *)exchangeRate {
    _exchangeRate = exchangeRate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_exchangeRate forKey:@"exchangeRate"];
    [defaults synchronize];
}


//查询是否在审核中
- (void)isLoadingData {
    BOOL needRequest = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"isLoading"]) {
        NSString *isLoading = [defaults stringForKey:@"isLoading"]; //YES为审核中 NO为审核完毕 YES／NO 为字符串
        if ([isLoading isEqualToString:@"YES"]) {
            needRequest = YES;
            [defaults setObject:@"YES" forKey:@"isLoading"];
        }else if ([isLoading isEqualToString:@"NO"]){
            needRequest = NO;
            self.loadingData = NO;
            [defaults setObject:@"NO" forKey:@"isLoading"];
        }
    }else {
        needRequest = YES;
    }
    
    if ([defaults objectForKey:@"AppVersion"]) {
        NSString *appVersion = [defaults stringForKey:@"AppVersion"];
        if ([appVersion compare:[YYUtility appVersion] options:NSNumericSearch] == NSOrderedDescending)
        {
            //缓存里的 appVersion 更大
            needRequest = NO;
            self.loadingData = NO;
        }
        else    {
            //当前appVersion更大
            if ([appVersion isEqualToString:[YYUtility appVersion]]) {
                needRequest = NO;
                self.loadingData = NO;
            }else {
                needRequest = YES;
            }
            
        }
        [defaults setObject:[YYUtility appVersion] forKey:@"AppVersion"];
    }else {
        [defaults setObject:[YYUtility appVersion] forKey:@"AppVersion"];
        needRequest = YES;
    }
    //        1线上版本,2审核中版本,3强制更新版本,4建议更新版本,5已删除版本
    //    if (needRequest) {
    @weakify(self);
    self.loadingData = YES;
    [HttpRequestHelper checkLoadingWithVersion:[YYUtility appVersion] success:^(VersionInfo *info) {
        @strongify(self);
        self.versionInfo = info;
        NSLog(@"version:%@",info);
        switch (info.status) {
            case Version_Online:
                self.loadingData = NO;
                [defaults setObject:@"NO" forKey:@"isLoading"];
                break;
            case Version_Loading:
                if (needRequest) {
                    self.loadingData = YES;
                    if (self.loadingData) {
                        [defaults setObject:@"YES" forKey:@"isLoading"];
                    }else {
                        [defaults setObject:@"NO" forKey:@"isLoading"];
                    }
                }
                break;
            case Version_ForceUpdate:
                self.loadingData = NO;
                [defaults setObject:@"NO" forKey:@"isLoading"];
                NotifyCoreClient(VersionCoreClient, @selector(appNeedForceUpdateWithDesc:version:), appNeedForceUpdateWithDesc:info.updateVersionDesc version:info.updateVersion);
                break;
            case Version_Suggest:
                self.loadingData = NO;
                [defaults setObject:@"NO" forKey:@"isLoading"];
                NotifyCoreClient(VersionCoreClient, @selector(appNeedUpdateWithDesc:version:), appNeedUpdateWithDesc:info.updateVersionDesc version:info.updateVersion);
                break;
            case Version_IsDeleted:
                self.loadingData = NO;
                [defaults setObject:@"NO" forKey:@"isLoading"];
                NotifyCoreClient(VersionCoreClient, @selector(appNeedForceUpdateWithDesc:version:), appNeedForceUpdateWithDesc:info.updateVersionDesc version:info.updateVersion);
                break;
            default:
                break;
        }
    
        NotifyCoreClient(VersionCoreClient, @selector(onRequestVersionStatusSuccess:), onRequestVersionStatusSuccess:info);
        [defaults synchronize];
    } failure:^(NSNumber *resCode, NSString *message) {
        
    }];
    
    //    }
    [defaults synchronize];
    
}

#pragma mark - AuthCoreClient

- (void)onLoginSuccess {
    if (projectType() != ProjectType_VKiss) {
        [self isLoadingData];
    }
}



- (void)getVestBagShowErBanLogin{
    [HttpRequestHelper vestBagShowErBanLoginSuccess:^(id message) {
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            VersionInfo *model = message;
            NotifyCoreClient(VersionCoreClient, @selector(getVestBagLoginDescriptionDictSuccess:), getVestBagLoginDescriptionDictSuccess:model);
        } else {
            NotifyCoreClient(VersionCoreClient, @selector(getVestBagLoginDescriptionSuccess:), getVestBagLoginDescriptionSuccess:message);
        }
    } failure:^(NSNumber * code, NSString * message) {
        
    }];
}

@end
