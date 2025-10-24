//
//  YYUtility+Device.m
//  YYMobileFramework
//
//  Created by wuwei on 14-5-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "YYUtility.h"
#import <sys/utsname.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>
#import "YYReachability.h"
#import <AdSupport/ASIdentifierManager.h>

#import <ifaddrs.h>
#import <net/if_dl.h>
#import <sys/socket.h>
#import "SSCustomKeychain.h"
#import "GCDHelper.h"


#if !defined(IFT_ETHER)
#define IFT_ETHER 0x6
#endif

#define kIOSCellular    @"pdp_ip0"
#define kIOSWifi        @"en0"
#define kIPAddrV4       @"ipv4"
#define kIPAddrV6       @"ipv6"
#define kAppName        @"yym51ip"

@implementation YYUtility (Device)

+ (NSString *)modelName
{
    static NSString *modelName = nil;
    if (!modelName) {
        struct utsname systemInfo;
        uname(&systemInfo);
        modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return modelName;
}

+ (NSString *)systemVersion
{
    // 调用非常频繁，主要在cleanSpecialText中
    static NSString* _systemVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemVersion = [UIDevice currentDevice].systemVersion;;
    });
    
    if (_systemVersion) {
        return _systemVersion;
    }
    
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)identifierForVendor
{
    static NSString *idfv = nil;
    if (!idfv) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return idfv;
}

+ (NSString *)deviceID
{
    NSString *deviceID = @"";
    if (!deviceID || deviceID.length == 0) {
        deviceID = [YYUtility identifierForVendor];
    }
    
    if (!deviceID) {
        deviceID = @"";
    }
    
    return deviceID;
}

+ (NSInteger)networkStatus
{
    return (self.reachability.currentReachabilityStatus);
}

+ (YYReachability *)reachability
{
    static YYReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [YYReachability reachabilityForInternetConnection];
    });
    return reachability;
}


+ (void)checkCameraAvailable:(void (^)(void))available denied:(void(^)(void))denied restriction:(void(^)(void))restriction
{
    available = available ? : ^{};
    denied = denied ? : ^{};
    restriction = restriction ? : ^{};
    
    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // iOS7下，需要检查iPhone的隐私和访问限制项
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusAuthorized:
            {
                available();
                break;
            }
            case AVAuthorizationStatusDenied:
            {
                // [设置->隐私->相机]中禁止了YY访问相机
                denied();
                break;
            }
            case AVAuthorizationStatusRestricted:
            {
                // NOTE: 这个跟[设置-通用-访问限制]似乎没有关系
                restriction();
                break;
            }
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    dispatch_main_sync_safe(^{
                        if (granted)
                        {
                            available();
                        }
                        else
                        {
                            denied();
                        }
                        
                    });
                    
                }];
            }
                
            default:
                break;
        }
    }
    else
    {
        restriction();
    }
}

+ (void)checkAssetsLibrayAvailable:(void (^)(void))available denied:(void(^)(void))denied restriction:(void(^)(void))restriction
{
    available = available ? : ^{};
    denied = denied ? : ^{};
    restriction = restriction ? : ^{};
    
    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ||
         [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusNotDetermined) {
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (*stop) {
                    available();
                    return;
                }
                *stop = TRUE;
            } failureBlock:^(NSError *error) {
                denied();
            }];
        }else if (author == ALAuthorizationStatusDenied) {
            denied();
        }else if(author == ALAuthorizationStatusRestricted) {
            restriction();
        }else if(author == ALAuthorizationStatusAuthorized) {
            available();
        }
    }else {
        restriction();
    }
}

+ (void)checkMicPrivacy:(void(^)(BOOL succeed))resultBlock
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(granted);
            });
        }
    }];
}

+ (NSString *)deviceUniqueIdentification {
    //    SSCustomKeychain
    NSString * currentDeviceUUIDStr = [SSCustomKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSCustomKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

+ (NSString *)ipAddress
{
    return [self ipAddress:YES];
}

+ (NSString *)ipAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ kIOSWifi @"/" kIPAddrV4, kIOSWifi @"/" kIPAddrV6, kIOSCellular @"/" kIPAddrV4, kIOSCellular @"/" kIPAddrV6 ] :
    @[ kIOSWifi @"/" kIPAddrV6, kIOSWifi @"/" kIPAddrV4, kIOSCellular @"/" kIPAddrV6, kIOSCellular @"/" kIPAddrV4 ] ;
    
    NSDictionary *addresses = [self getIpAddresses];
    
    __block NSString *addr;
    [searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        addr = addresses[obj];
        if (addr) {
            *stop = YES;
        }
    }];
    return addr ? : @"0.0.0.0";
}

+ (NSDictionary *)getIpAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionary];
    
    // retrieve the current interfaces - return 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface -> ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) + 2];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *ifaName = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *ifaType;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        ifaType = kIPAddrV4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        ifaType = kIPAddrV6;
                    }
                }
                if (ifaType) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", ifaName, ifaType];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
    }
    // free memory
    freeifaddrs(interfaces);
    return addresses;
}

+ (NSString *)macAddresss
{
    static NSMutableString *macAddress = nil;
    
    if ([macAddress length] > 0) {
        return macAddress;
    }
    
    do
    {
        struct ifaddrs* addrs;
        if ( getifaddrs( &addrs ) )
            break;
        
        const struct ifaddrs *cursor = addrs;
        while ( cursor )
        {
            if ( ( cursor->ifa_addr->sa_family == AF_LINK )
                && strcmp( "en0",  cursor->ifa_name ) == 0
                && ( ( ( const struct sockaddr_dl * )cursor->ifa_addr)->sdl_type == IFT_ETHER ) )
            {
                const struct sockaddr_dl *dlAddr = ( const struct sockaddr_dl * )cursor->ifa_addr;
                const uint8_t *base = ( const uint8_t * )&dlAddr->sdl_data[dlAddr->sdl_nlen];
                
                macAddress = [[NSMutableString alloc] initWithCapacity:64];
                
                for ( int i = 0; i < dlAddr->sdl_alen; i++ )
                {
                    if (i > 0) {
                        [macAddress appendFormat:@":%02X", base[i]];
                    }
                    else
                    {
                        [macAddress appendFormat:@"%02X", base[i]];
                    }
                }
                
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    } while (NO);
    
    if (macAddress == nil) {
        macAddress = [NSMutableString stringWithString:@""];
    }
    
    return macAddress;
}

+ (NSString *)idfa
{
    static NSString *idfa = nil;
    if (!idfa) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            idfa = @"";
        }
    }
    return idfa;
}


+ (NSString*)modelType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])return@"iPhone 6";

    if([platform isEqualToString:@"iPhone8,1"])return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"])return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"])return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"])return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"])return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])return@"iPhone Simulator";
    
    return platform;
    
}

// 当前设备是否低于, 等于 iPhone6
+ (BOOL)isIphone6AndLow {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])return YES;
    
    if([platform isEqualToString:@"iPhone1,2"])return YES;
    
    if([platform isEqualToString:@"iPhone2,1"])return YES;
    
    if([platform isEqualToString:@"iPhone3,1"])return YES;
    
    if([platform isEqualToString:@"iPhone3,2"])return YES;
    
    if([platform isEqualToString:@"iPhone3,3"])return YES;
    
    if([platform isEqualToString:@"iPhone4,1"])return YES;
    
    if([platform isEqualToString:@"iPhone5,1"])return YES;
    
    if([platform isEqualToString:@"iPhone5,2"])return YES;
    
    if([platform isEqualToString:@"iPhone5,3"])return YES;
    
    if([platform isEqualToString:@"iPhone5,4"])return YES;
    
    if([platform isEqualToString:@"iPhone6,1"])return YES;
    
    if([platform isEqualToString:@"iPhone6,2"])return YES;
    
    if([platform isEqualToString:@"iPhone7,1"])return YES;
    
    if([platform isEqualToString:@"iPhone7,2"])return YES;
    
    if ([platform isEqualToString:@"iPhone8,1"]) return YES;

    if ([platform isEqualToString:@"iPhone8,3"]) return YES;
    
    if ([platform isEqualToString:@"iPhone8,4"]) return YES;
    
    if ([platform isEqualToString:@"iPhone9,1"]) return YES;
    
    if ([platform isEqualToString:@"iPhone9,3"]) return YES;
    
    return NO;
}

@end
