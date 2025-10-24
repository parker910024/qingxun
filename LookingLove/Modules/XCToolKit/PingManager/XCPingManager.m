//
//  XCPingManager.m
//  XCToolKit
//
//  Created by KevinWang on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCPingManager.h"
#import "XCSinglePing.h"
#include <arpa/inet.h>
#include <resolv.h>
#include <netdb.h>

@interface XCAddressItem ()

@property (nonatomic, copy, readwrite) NSString *hostName;
@property (nonatomic, assign, readwrite) double delayMillSeconds;

@end

@implementation XCAddressItem

- (instancetype)initWithHostName:(NSString *)hostName {
    if (self = [super init]) {
        self.hostName = hostName;
        self.delayTimes = [NSMutableArray array];
    }
    return self;
}

- (double)delayMillSeconds {
    
    if (self.delayTimes.count) {
        double allDelayTime = 0;
        for (NSNumber *delayTime in self.delayTimes) {
            allDelayTime += delayTime.doubleValue;
        }
        return allDelayTime / self.delayTimes.count;
    }
    return 1000.0;
}

@end

@interface XCPingManager ()

@property (nonatomic, strong) NSMutableArray *singlePingerArray;

@end

static XCPingManager *instance;

@implementation XCPingManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[XCPingManager alloc]init];
    });
    
    return instance;
    
}

- (void)getFatestAddress:(NSArray *)addressList completionHandler:(CompletionHandler)completionHandler {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (addressList.count == 0) {
            NSLog(@"addressList can't be empty");
            return;
        }
        NSMutableArray *singlePingerArray = [NSMutableArray array];
        self.singlePingerArray = singlePingerArray;
        NSMutableArray *needRemoveAddressArray = [NSMutableArray array];
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        for (NSString *address in addressList) {
            [resultDict setObject:[NSNull null] forKey:address];
        }
        dispatch_group_t group = dispatch_group_create();
        
        for (NSString *address in addressList) {
            dispatch_group_enter(group);
            XCSinglePing *singlePinger = [XCSinglePing startWithHostName:address count:3 pingCallBack:^(XCPingItem *pingitem) {
                switch (pingitem.status) {
                    case XCSinglePingStatusDidStart:
                        break;
                    case XCSinglePingStatusDidFailToSendPacket:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        break;
                    }
                    case XCSinglePingStatusDidReceivePacket:
                    {
                        XCAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        if ([item isEqual:[NSNull null]]) {
                            item = [[XCAddressItem alloc] initWithHostName:pingitem.hostName];
                        }
                        [item.delayTimes addObject:@(pingitem.millSecondsDelay)];
                        [resultDict setObject:item forKey:pingitem.hostName];
                        if (![resultArray containsObject:item]) {
                            [resultArray addObject:item];
                        }
                        break;
                    }
                    case XCSinglePingStatusDidReceiveUnexpectedPacket:
                        break;
                    case XCSinglePingStatusDidTimeOut:
                    {
                        // 超时按1s计算
                        XCAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        if ([item isEqual:[NSNull null]]) {
                            item = [[XCAddressItem alloc] initWithHostName:pingitem.hostName];
                        }
                        [item.delayTimes addObject:@(1000.0)];
                        [resultDict setObject:item forKey:pingitem.hostName];
                        if (![resultArray containsObject:item]) {
                            [resultArray addObject:item];
                        }
                        break;
                    }
                    case XCSinglePingStatusDidError:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        dispatch_group_leave(group);
                        break;
                    }
                    case XCSinglePingStatusDidFinished:
                    {
                        NSLog(@"%@ 完成",pingitem.hostName);
                        dispatch_group_leave(group);
                        break;
                    }
                    default:
                        break;
                }
            }];
            [singlePingerArray addObject:singlePinger];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"计算延迟");
            for (XCAddressItem *item in resultArray) {
                if ( (item.delayTimes.count == 0 && ![needRemoveAddressArray containsObject:item.hostName]) ||
                    item.delayMillSeconds == 0) {
                    [needRemoveAddressArray addObject:item.hostName];
                }
            }
            
            for (NSString *removeHostName in needRemoveAddressArray) {
                [resultArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.hostName != %@",removeHostName]];
            }
            
            if (resultArray.count == 0) {
                completionHandler(nil,nil);
                return;
            }
            
            [resultArray sortUsingComparator:^NSComparisonResult(XCAddressItem * item1, XCAddressItem * item2) {
                return item1.delayMillSeconds > item2.delayMillSeconds;
            }];
            
            NSMutableArray *array = [NSMutableArray array];
            for (XCAddressItem *item in resultArray) {
                [array addObject:item];
            }
            XCAddressItem *item = resultArray.firstObject;
            NSLog(@"最快的地址速度是: %.2f ms",item.delayMillSeconds);
            completionHandler(item.hostName, [array copy]);
        });
    }];
}

- (void)getBestAddress:(NSArray *)addressList completionHandler:(CompletionHandler)completionHandler {
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        if (addressList.count == 0) {
            NSLog(@"addressList can't be empty");
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        
        dispatch_group_t group = dispatch_group_create();
        
        for (NSString *address in addressList) {
            
            dispatch_group_enter(group);
            
            NSString *resultIpAddress = [self parsingIPAddress:address];
            
            if (resultIpAddress.length > 0) {
                
                [resultArray addObject:address];
                [resultDict setObject:resultIpAddress forKey:address];
            }
            
            dispatch_group_leave(group);
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            if (resultArray.count == 0) {
                completionHandler(nil,nil);
                return;
            }
            completionHandler(resultArray.firstObject, [resultArray copy]);
        });
    }];
}

#pragma mark - private method
- (NSString *)parsingIPAddress:(NSString*)strHostName {
    NSURL *url = [NSURL URLWithString:strHostName];
    if (url.host.length <= 0) {
        return nil;
    }
    const char* szname = [url.host UTF8String];
    struct hostent* phot ;
    @try
    {
        phot = gethostbyname(szname);
    }
    @catch (NSException * e)
    {
        return nil;
    }
    
    struct in_addr ip_addr;
    if (phot == NULL) {
        return @"";
    }
    memcpy(&ip_addr,phot->h_addr_list[0],4);
    
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    
    return strIPAddress;
}
@end
