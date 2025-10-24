
//  XCLogger.m
//  BberryFramework
//
//  Created by 卫明何 on 2018/3/14.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCLogger.h"

#import "LogClient.h"
#import "LogGroup.h"
#import "Log.h"
#import "LogCore.h"
#import "AuthCore.h"


@interface XCLogger ()

@property (nonatomic, strong)NSMutableDictionary<NSString *,LogGroup *> *logContent;
@property (strong, nonatomic)NSMutableDictionary<NSString *,LogGroup *> *tempLogContent;
@property (nonatomic, strong)LogClient *client;
@end

@implementation XCLogger

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)shareXClogger {
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initWithAccessKeyID:(NSString *)accessKeyId accessKeySecret:(NSString *)accessKeysecret token:(NSString *)token  {
    NSString *logEndPoint = keyWithType(KeyType_AliyunLogEndPoint, NO);
    NSString *logProject = keyWithType(KeyType_AliyunLogProject, NO);
    LogClient *client = [[LogClient alloc]initWithApp:logEndPoint accessKeyID:accessKeyId accessKeySecret:accessKeysecret projectName:logProject];
    [client SetToken:token];
    self.client = client;
    
}



#pragma mark - puble method
- (void)sendLog:(NSDictionary<NSString*,NSString*>*)logContent error:(nullable NSError *)error topic:(nonnull NSString *)topic logLevel:(XCLogLevel)logLevel {
    NSString *ipAddress = [YYUtility ipAddress];
    Log *logObj = [[Log alloc]init];
    //common
    [logObj PutContent:[GetCore(AuthCore)getUid] withKey:@"uid"];
    [logObj PutContent:ipAddress withKey:@"ip"];
    [logObj PutContent:@"iOS" withKey:@"OS"];
    [logObj PutContent:[YYUtility modelType] withKey:@"model"];
    [logObj PutContent:[YYUtility systemVersion] withKey:@"OSVersion"];
    [logObj PutContent:[YYUtility appVersion] withKey:@"AppVersion"];
    [logObj PutContent:[YYUtility carrierName]?[YYUtility carrierName]:@"" withKey:@"carrierName"];
    [logObj PutContent:[YYUtility deviceUniqueIdentification] withKey:@"device_id"];
    [logObj PutContent:[NSString stringWithFormat:@"%ld",(long)[YYUtility networkStatus]] withKey:@"networkStatus"];
    
    //error
    if (error!=nil) {
        NSMutableString *errorStr = [error.description mutableCopy];
        [errorStr appendString:[NSString stringWithFormat:@"(%ld)",error.code]];
        [logObj PutContent:errorStr withKey:@"error"];
    }
    //level
    [logObj PutContent:[NSString stringWithFormat:@"%lu",(unsigned long)logLevel] withKey:@"LogLevel"];
    
    //content
    if (logContent) {
        NSArray *keys = [logContent allKeys];
        for (NSString *key in keys) {
            NSString *value = logContent[key];
            [logObj PutContent:value withKey:key];
        }

    }
    [self postLogWithTopic:topic log:logObj];
}


#pragma mark - private method
- (void)postLogWithTopic:(NSString *)topic log:(Log *)log {
    LogGroup *group = [self.logContent valueForKey:topic];
    if (group) { //证明已经有同Topic的日志已经输出过一次
        group = [self.logContent valueForKey:topic];
        [group PutLog:log];
    }else { //如果没有该Key下的Group，就证明这Topic的Log是第一次输出，所以要新建一个Group
        group = [[LogGroup alloc]initWithTopic:topic andSource:[YYUtility ipAddress]];
        [group PutLog:log];
        [self.logContent setObject:group forKey:topic];
    }
    
    if (group._mContent.count >= POST_GROUP_LIMIT) { //如果日志数大于设定数目，就进行上传
        [self.tempLogContent setObject:group forKey:topic];
        [self.logContent removeObjectForKey:topic];
        
        @weakify(self);
        NSString *logStore = keyWithType(KeyType_AliyunLogStore, NO);
        [self.client PostLog:group logStoreName:logStore call:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
            @strongify(self);
            if (error) { //如果提交log失败，就重新请求ak
                if (error.code != -1009) {
                   [GetCore(LogCore)requestLogSk];
                }
            }else {
                [self.tempLogContent removeObjectForKey:topic];
            }
        }];
    }
}


#pragma mark - Getter

- (NSMutableDictionary *)logContent {
    if (_logContent == nil) {
        _logContent = [NSMutableDictionary dictionary];
    }
    return _logContent;
}

- (NSMutableDictionary<NSString *,LogGroup *> *)tempLogContent {
    if (_tempLogContent == nil) {
        _tempLogContent = [NSMutableDictionary dictionary];
    }
    return _tempLogContent;
}


#pragma mark - Setter

- (void)setSk:(LogSK *)sk {
    _sk = sk;
    [self initWithAccessKeyID:sk.accessKeyId accessKeySecret:sk.accessKeySecret token:sk.securityToken];
}

@end
