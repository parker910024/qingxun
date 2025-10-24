//
//  SearchCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchCoreClient <NSObject>
@optional
- (void)onUserSearchSuccess:(NSArray *)results;
- (void)onUserSearchFailth:(NSString *)message;
- (void)onSearchSuccess:(NSArray *)arr;
- (void)onSearchFailth:(NSString *)message;
@end
