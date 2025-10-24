//
//  NSObject+RandomNumber.m
//  XChatFramework
//
//  Created by 卫明何 on 2018/4/26.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NSObject+RandomNumber.h"

@implementation NSObject (RandomNumber)

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
