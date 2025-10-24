//
//  YYLogger.h
//  Commons
//
//  Created by daixiang on 14-6-3.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    LogLevelVerbose,
    LogLevelDebug,
    LogLevelInfoDev,
    LogLevelInfo,
    LogLevelWarn,
    LogLevelError
} LogLevel;

typedef enum : NSUInteger {
    LogFilePolicyNoLogFile,
    LogFilePolicyPerDay,
    LogFilePolicyPerLaunch,
} LogFilePolicy;

@interface LogConfig : NSObject

@property (nonatomic, strong) NSString *dir;                       // log文件目录
@property (nonatomic, assign) LogFilePolicy policy;                // log文件策略
@property (nonatomic, assign) LogLevel outputLevel;                // 输出级别，大于等于此级别的log才会输出
@property (nonatomic, assign) LogLevel fileLevel;                  // 输出到文件的级别，大于等于此级别的log才会写入文件

@end

@interface YYLogger : NSObject

+ (void)config:(LogConfig *)cfg;

+ (YYLogger *)getYYLogger:(NSString *)tag;

+ (NSString *)logFilePath;

+ (NSArray *)sortedLogFileArray;

+ (NSString *)logFileDir;

+ (void)log:(NSString *)tag level:(LogLevel)level message:(NSString *)format, ...NS_FORMAT_FUNCTION(3, 4);

+ (void)verbose:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)debug:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)infoDev:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)info:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)warn:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)error:(NSString *)tag message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

+ (void)cleanLogFiles;

- (void)log:(LogLevel)level message:(NSString *)format, ...NS_FORMAT_FUNCTION(2, 3);

- (void)verbose:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

- (void)debug:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

- (void)info:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

- (void)warn:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

- (void)error:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

@end


//非类形式的另一个打Log函数，为方便使用
#define LogVerbose(tag, format, arg...)  [YYLogger verbose:tag message:format, ##arg]
#define LogDebug(tag, format, arg...)  [YYLogger debug:tag message:format, ##arg]
#define LogInfoDev(tag, format, arg...)  [YYLogger info:tag message:format, ##arg]
#define LogInfo(tag, format, arg...)  [YYLogger info:tag message:format, ##arg]
#define LogWarn(tag, format, arg...)  [YYLogger warn:tag message:format, ##arg]
#define LogError(tag, format, arg...)  [YYLogger error:tag message:format, ##arg]

