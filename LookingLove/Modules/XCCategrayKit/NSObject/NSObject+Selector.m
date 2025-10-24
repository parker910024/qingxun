//
//  NSObject+Selector.m
//  Test
//
//  Created by Mac on 2017/12/29.
//  Copyright © 2017年 KevinWang. All rights reserved.
//

#import "NSObject+Selector.h"
#import <objc/runtime.h>

//@implementation RootRobot
//- (void)getCrashMsg{
//    NSLog(@"%@",_crashMsg);
//}
//@end
//
//@implementation NSObject (Selector)
//
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([NSStringFromClass([self class]) hasPrefix:@"_"]||
//        [self isKindOfClass:NSClassFromString(@"UITextInputController")]||
//        [NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"]||
//        [NSStringFromClass([self class]) hasPrefix:@"NIM"]||
//        [methodName isEqualToString:@"dealloc"]) {
//        
//        return nil;
//    }
//    
//    RootRobot * rootRobot = [RootRobot new];
//    rootRobot.crashMsg =[NSString stringWithFormat:@"NSObject+Selector: [%@ %p %@]: unrecognized selector sent to instance",NSStringFromClass([self class]),self,NSStringFromSelector(aSelector)];
//    class_addMethod([RootRobot class], aSelector, [rootRobot methodForSelector:@selector(getCrashMsg)], "v@:");
//    
//    return rootRobot;
//}
//@end

