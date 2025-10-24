//
//  SearchCore.m
//  BberryCore
//
//  Created by chenran on 2017/5/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "SearchCore.h"
#import "SearchCoreClient.h"
#import "HttpRequestHelper+Search.h"

@implementation SearchCore

- (void)searchWithKey:(NSString *)key {
    [HttpRequestHelper requestInfoWithKey:key Success:^(NSArray *list) {
        NotifyCoreClient(SearchCoreClient, @selector(onSearchSuccess:), onSearchSuccess:list);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(SearchCoreClient, @selector(onSearchFailth:), onSearchFailth:message);
    }];
}

- (void)searchUser:(NSString *)key pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize
{
    [HttpRequestHelper searchUser:key pageNo:pageNo pageSize:pageSize success:^(NSArray *userInfos) {
        NotifyCoreClient(SearchCoreClient, @selector(onUserSearchSuccess:), onUserSearchSuccess:userInfos);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(SearchCoreClient, @selector(onUserSearchFailth:), onUserSearchFailth:message);
    }];
}

- (void)searchRoom:(NSString *)key
{
    
}

@end
