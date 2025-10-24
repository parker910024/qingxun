//
//  HostUrlManager.m
//  Bberry
//
//  Created by KevinWang on 2018/6/2.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "HostUrlManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "XCPingManager.h"
#import "CommonFileUtils.h"

@interface HostUrlManager ()
//备用ip(不可ping)
@property (nonatomic, copy) NSString *optionIpHost;
//lbs ip
@property (nonatomic, copy) NSString *lbsIpHost;
//硬编码域名
@property (nonatomic, strong) NSArray *localHostList;

//本地缓存的域名
@property (nonatomic, copy)NSString * hostNameUrl;

@end

@implementation HostUrlManager

static HostUrlManager * instance = nil;
static NSString *kHostNameKey = @"kHostNameOptionKey";
static NSString *kHostNameURLKey = @"kHostNameURLKey";

+ (void)load{
    [[HostUrlManager shareInstance] hostUrl];
}

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[HostUrlManager alloc]init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            [self _configLookingLoveHost];
        } else if (projectType() == ProjectType_Haha) {
            [self _configHaHaHost];
        } else if (projectType() == ProjectType_BB) {
            [self _configMengShengHost];
        } else if (projectType() == ProjectType_Pudding || projectType() == ProjectType_TuTu) {
            [self _configTuTuHost];
        }

    }
    return self;
}

- (EnvironmentType)currentEnvironment {

#ifdef DEBUG
    EnvironmentType env = [[NSUserDefaults standardUserDefaults]integerForKey:kAppNetWorkEnv];
    if (env < 1) {
        env = TestType;
        [[NSUserDefaults standardUserDefaults]setInteger:env forKey:kAppNetWorkEnv];
    }
    return env;
#else
    return ReleaseType;
#endif
}

- (NSString*)hostUrl{
    
    NSString * url = @"";
    
#ifdef DEBUG
    
    EnvironmentType env = [[NSUserDefaults standardUserDefaults]integerForKey:kAppNetWorkEnv];
    if (env < 1) {
        env = TestType;
        [[NSUserDefaults standardUserDefaults]setInteger:env forKey:kAppNetWorkEnv];
    }
    if (env==DevType){
        url = keyWithType(KeyType_BaseURL, YES);
    }else if (env==TestType){
        url = keyWithType(KeyType_BaseURL, YES);
    }else if (env==Pre_ReleaseType){
        url = keyWithType(KeyType_BaseURL_Pre_Release, NO);
    }else if (env==ReleaseType){
        url = keyWithType(KeyType_BaseURL, NO);
    }else{
        //默认是测试环境
        url = keyWithType(KeyType_BaseURL, YES);
    }
    
    url = self.hostNameUrl.length > 0 ? self.hostNameUrl : url;
#else
    
    url = self.hostNameUrl.length > 0 ? self.hostNameUrl : keyWithType(KeyType_BaseURL, NO);
    
#endif
    
    return url;
}

- (void)updatHostUrl:(NSString *)hostUrl {
    
    self.hostNameUrl = hostUrl;
    [CommonFileUtils writeObject:hostUrl toUserDefaultWithKey:kHostNameURLKey];
}

- (void)setEnv:(EnvironmentType)Env{
    
    _Env = Env;
    NSUserDefaults * userDeffaults = [NSUserDefaults standardUserDefaults];
    [userDeffaults setInteger:Env forKey:kAppNetWorkEnv];
    [userDeffaults synchronize];
}

- (RACSignal *)rac_getFasterHostName:(NSArray *)hostList {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[XCPingManager sharedManager] getBestAddress:hostList completionHandler:^(NSString *hostName, NSArray *sortedAddress) {
            
            [subscriber sendNext:sortedAddress];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (void)saveHostList:(NSArray *)hostList {
    
    [CommonFileUtils writeObject:hostList toUserDefaultWithKey:kHostNameKey];
}

- (NSArray *)getHostListFromMemory {
    
    return self.localHostList;
}

- (NSArray *)getHostListFromDisk {
    
    NSArray *array = [CommonFileUtils readObjectFromUserDefaultWithKey:kHostNameKey];
    return array;
}

- (RACSignal *)rac_getIpHost {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
        [[XCPingManager sharedManager] getFatestAddress:@[self.lbsIpHost] completionHandler:^(NSString *hostName, NSArray *sortedAddress) {
            @strongify(self);
            XCAddressItem *addressItem = sortedAddress.firstObject;
            int timeOutCount = 0;
            if (addressItem.delayTimes.count) {
                for (NSNumber *delayTime in addressItem.delayTimes) {
                    if (delayTime.doubleValue - 1000 >= 0) {
                        timeOutCount += 1;
                    }
                }
            }
            if ( timeOutCount <= 1 ) {
                [subscriber sendNext:addressItem.hostName];
                [subscriber sendCompleted];
            } else {
                [subscriber sendNext:self.optionIpHost];
                [subscriber sendCompleted];
            }
            
        }];
        return nil;
    }];

}

#pragma mark - private method
- (void)_configTuTuHost {
#ifdef DEBUG
    
    self.localHostList = @[@"http://beta.wimhe.com"];
#else
    
    self.localHostList = @[@"https://www.wimhe.com"];
    self.hostNameUrl = [CommonFileUtils readObjectFromUserDefaultWithKey:kHostNameURLKey];
#endif
}

- (void)_configLookingLoveHost {
    

    self.localHostList = @[@"https://dev-api.gehe.chat"];
    self.optionIpHost = @"https://dev-api.gehe.chat";
    self.lbsIpHost = @"https://dev-api.gehe.chat";

}

- (void)_configHaHaHost {
    
#ifdef DEBUG
    self.optionIpHost = @"http://47.104.94.151";
    self.lbsIpHost = @"http://47.104.94.151";
    self.localHostList = @[@"http://beta.ceerjiaoyou.com",
                           @"http://beta.qingxunjiaoyou.com",
                           @"http://beta.paopaoyuyin.com"];
#else
    self.optionIpHost = @"http://120.79.234.104";
    self.lbsIpHost = @"http://47.106.27.13";
    self.localHostList = @[@"https://api.qingxunjiaoyou.com:10003",
                           @"https://api.ceerjiaoyou.com:10003",
                           @"https://www.paopaoyuyin.com"];
    self.hostNameUrl = [CommonFileUtils readObjectFromUserDefaultWithKey:kHostNameURLKey];
#endif
    
}

- (void)_configMengShengHost {
    
#ifdef DEBUG
    self.optionIpHost = @"http://114.215.68.206";
    self.lbsIpHost = @"http://114.215.68.206";
    self.localHostList = @[@"http://beta.letusmix.com",
                           @"http://beta.letusmix.com"];
#else
    self.optionIpHost = @"http://139.129.106.6";
    self.lbsIpHost = @"http://139.129.106.6";
    self.localHostList = @[@"https://www.letusmix.com",
                           @"https://www.letusmix.com",
                           @"https://www.letusmix.com"];
    self.hostNameUrl = [CommonFileUtils readObjectFromUserDefaultWithKey:kHostNameURLKey];
#endif
    
}

//vkiss使用
- (NSString *)hostH5Url{
    NSString * url = @"";
    
#ifdef DEBUG
    
    EnvironmentType env = [[NSUserDefaults standardUserDefaults]integerForKey:kAppNetWorkEnv];
    if (env < 1) {
        env = TestType;
        [[NSUserDefaults standardUserDefaults]setInteger:env forKey:kAppNetWorkEnv];
    }
    if (env==DevType){
        url = keyWithType(KeyType_BaseH5URL, YES);
    }else if (env==TestType){
        url = keyWithType(KeyType_BaseH5URL, YES);
    }else if (env==Pre_ReleaseType){
        url = keyWithType(KeyType_BaseH5URL, NO);
    }else if (env==ReleaseType){
        url = keyWithType(KeyType_BaseH5URL, NO);
    }else{
        //默认是测试环境
        url = keyWithType(KeyType_BaseH5URL, YES);
    }
#else
    url = keyWithType(KeyType_BaseH5URL, NO);
#endif
    
    return url;
}
@end
