//
//  NSMutableArray+QueueAdditions.m
//  YYMobileFramework
//
//  Created by yangmengjun on 15/1/13.
//  Copyright (c) 2015年 YY Inc. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray(QueueAdditions)

- (id) pop {
    
    if ([self count] == 0) {
        return nil;
    }
    
    id headObject = [self firstObject];
    if (headObject != nil) {
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

- (void) push:(id)object {
    [self addObject:object];
}

@end
