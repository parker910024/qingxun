//
//  XCLoggerTool.m
//  BberryCore
//
//  Created by Mac on 2018/4/12.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCLoggerTool.h"
#import <objc/runtime.h>
#import "MonsterGameModel.h"
#import "GameLuckyResult.h"

@implementation XCLoggerTool

+ (id)completeLogData:(id)logData{
    
    id tfClass = object_getClass(logData);
    
    unsigned int count ,i;
    Ivar *members = class_copyIvarList(tfClass, &count);
    objc_property_t *properties = class_copyPropertyList(tfClass, &count);
    for (i = 0; i < count; i++) {
         Ivar var = members[i];
        const char *memberName = ivar_getName(var);
        const char *memberType = ivar_getTypeEncoding(var);
        
//        Ivar ivar = class_getInstanceVariable(tfClass, memberName);
        NSString *typeStr = [NSString stringWithCString:memberType encoding:NSUTF8StringEncoding];
        NSLog(@"%s----%s---%@", memberName, memberType,typeStr);
        
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        if ([typeStr isEqualToString:@"@\"NSString\""]) {
            if ([logData valueForKey:key] == nil) {
                [logData setValue:@"" forKey:key];
            }
        }else if ([typeStr isEqualToString:@"@\"LuckMan\""]){
            if ([logData valueForKey:key] == nil) {
                LuckMan *luckMan = [LuckMan new];
                luckMan.erbanNo = @"";
                [logData setValue:luckMan forKey:key];
            }
            if ([logData valueForKey:@"awards"] == nil) {
                [logData setValue:[NSArray new] forKey:@"awards"];
            }
            if ([logData valueForKey:@"ranking"] == nil) {
                [logData setValue:[NSArray new] forKey:@"ranking"];
            }
        }else if ([typeStr isEqualToString:@"@\"MonsterGameModel\""]){
            if ([logData valueForKey:key] == nil) {
                MonsterGameModel *model = [MonsterGameModel new];
                model.monsterId = @"";
                model.monsterStatus = 0;
                model.beforeAppearSeconds = -1;
                model.beforeDisappearSeconds = -1;
                model.remainBlood = -1;
                [logData setValue:model forKey:key];
            }
        }else{
            if ([logData valueForKey:key] == nil) {
                [logData setValue:@(0) forKey:key];
            }
        }
    }
    
  
    
    return logData;
}

@end
