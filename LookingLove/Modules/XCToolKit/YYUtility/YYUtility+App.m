//
//  YYUtility+App.m
//  YYMobileFramework
//
//  Created by wuwei on 14-5-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "YYUtility.h"
#import "XCMacros.h"

@implementation YYUtility (App)

+ (id)valueInPlistForKey:(NSString *)key
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:key];
}

+ (NSString *)appVersion
{
    static NSString *appVersion = nil;
    if (!appVersion) {
        appVersion = [self valueInPlistForKey:@"CFBundleShortVersionString"];
    }
    return appVersion;
}

+ (NSString *)appName {
    if (projectType() == ProjectType_TuTu || projectType() == ProjectType_Pudding) {
        return @"tutu";
    }else if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) {
        return @"mengsheng";
    } else if (projectType() == ProjectType_Haha) {
        return @"hameng";
    } else if (projectType() == ProjectType_VKiss) {
        return @"vkiss";
    } else if (projectType() == ProjectType_LookingLove) {
        return @"qingxun";
    } else if (projectType() == ProjectType_Planet) {
        return @"planet";
    } else if (projectType() == ProjectType_DontSilent) {
        return @"bmuoo";
    } else if (projectType() == ProjectType_CatASMR) {
        return @"catchear";
    } else if (projectType() == ProjectType_CeEr) {
        return @"ear";
    } else {
        return @"other";
    }
}

+ (NSString *)appBuild
{
    static NSString *appBuild = nil;
    if (!appBuild) {
        appBuild = [self valueInPlistForKey:(NSString *)kCFBundleVersionKey];
    }
    return appBuild;
}

+ (NSString *)appBundleId
{
    static NSString *appBundleId = nil;
    if (!appBundleId) {
        appBundleId = [self valueInPlistForKey:(NSString *)kCFBundleIdentifierKey];
    }
    return appBundleId;
}


+ (NSString *)svnVersion
{
    static NSString *svnVersion = nil;
    if (!svnVersion) {
        svnVersion = [self valueInPlistForKey:@"SvnBuildVersion"];
    }
    return svnVersion;
}

static NSString * const kMobileFrameworkResourceBundleName = @"YYMobileFrameworkRes";

+ (NSURL *)URLForMobileFrameworkResourceBundle
{
    return [[NSBundle mainBundle] URLForResource:kMobileFrameworkResourceBundleName
                                   withExtension:@"bundle"];
}

+ (NSString *)pathForMobileFrameworkResourceBundle
{
    return [[NSBundle mainBundle] pathForResource:kMobileFrameworkResourceBundleName
                                           ofType:@"bundle"];
}

+ (NSString *)buildType
{
#ifdef DEBUG
    return @"DEBUG";
#else
    return @"RELEASE";
#endif
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        NSLog(@"File %@ dosen't exist!", fileURL);
        return NO;
    }
    
    NSError *error = nil;
    BOOL result = [fileURL setResourceValue:[NSNumber numberWithBool:YES]
                                     forKey:NSURLIsExcludedFromBackupKey
                                      error:&error];
    if (!result) {
        NSLog(@"Error excluding '%@' from backup, error: %@.", fileURL, error);
    }
    
    return result;
}

static NSString *_from = nil;

+ (NSString *)getAppSource
{
    if (_from == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sourceid.dat" ofType:nil];
        
        NSError *error;
        NSString *from = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        // 去除换行及空格
        if (from) {
            from = [self removeSpaceAndNewline:from];
        }
        
        // 如果读到有值且不为0
        if (!error
            && ![from isEqualToString:@"0"]
            && ![from isEqualToString:@""]) {
            _from = from;
        } else {
            if (projectType() == ProjectType_TuTu) {
                _from =  @"appstore_tt";
            }else if (projectType() == ProjectType_Pudding) {
                _from =  @"appstore_pudding";
            }else if (projectType() == ProjectType_BB) {
                _from =  @"appstore_ms";
            }else if (projectType() == ProjectType_Haha) {
                _from =  @"hameng_appstore";
            } else if (projectType() == ProjectType_LookingLove) {
                _from =  @"qingxun_appstore";
            } else if (projectType() == ProjectType_Planet) {
                _from =  @"planet_appstore";
            } else if (projectType() == ProjectType_DontSilent) {
                _from =  @"bmuoo_appstore";
            } else if (projectType() == ProjectType_CatASMR) {
                _from =  @"catchear_appstore";
            } else if (projectType() == ProjectType_CeEr) {
                _from =  @"ear_appstore";
            } else {
                _from =  @"appstore";
            }
            
        }
    }
    
    return _from;
}

+ (BOOL)isFromAppStore
{
    if([[[YYUtility getAppSource] lowercaseString] isEqualToString:@"appstore"])
    {
        return YES;
    }
    return NO;
}


+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

@end
