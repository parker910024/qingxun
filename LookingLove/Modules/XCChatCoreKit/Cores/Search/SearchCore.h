//
//  SearchCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/16.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface SearchCore : BaseCore

/**
 通过关键字搜索
 
 @param key 关键字
 */
- (void)searchWithKey:(NSString *)key;


- (void)searchUser:(NSString *)key pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize;
- (void)searchRoom:(NSString *)key;
@end
