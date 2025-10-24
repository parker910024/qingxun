//
//  NSArray+Safe.m
//  XChatFramework
//
//  Created by Mac on 2017/11/22.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)
-(id)safeObjectAtIndex:(NSUInteger)index
{
    if ([self isKindOfClass:[NSArray class]])
    {
        if (self.count)
        {
            if (self.count>index)
            {
                return self[index];
            }
        }
    }

    return nil;
}

@end
