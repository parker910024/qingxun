//
//  XCKeyWordTool.m
//  XCToolKit
//
//  Created by KevinWang on 2018/10/13.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCKeyWordTool.h"
#import "XCMacros.h"

@interface XCKeyWordTool ()


@end

@implementation XCKeyWordTool

+ (instancetype)sharedInstance{
    
    static XCKeyWordTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[XCKeyWordTool alloc] init];
    });
    return tool;
}


- (NSString *)xcz{
    
    NSString *s1 = [self.dataSource[0] substringWithRange:NSMakeRange(0, 1)];
    NSString *s2 = [self.dataSource[1] substringWithRange:NSMakeRange(1, 1)];
    
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xczAccount{
    
    NSString *s1 = [self.dataSource[0] substringWithRange:NSMakeRange(0, 1)];
    NSString *s2 = [self.dataSource[1] substringWithRange:NSMakeRange(1, 1)];
    NSString *s3 = [self.dataSource[2] substringWithRange:NSMakeRange(2, 1)];
    return [NSString stringWithFormat:@"%@%@%@",s1,s2,s3];
}

- (NSString *)xcGetCF{
    
    NSString *s1 = [self.dataSource[3] substringWithRange:NSMakeRange(3, 1)];
    NSString *s2 = [self.dataSource[4] substringWithRange:NSMakeRange(4, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcRedColor{
    
    NSString *s1 = [self.dataSource[5] substringWithRange:NSMakeRange(5, 1)];
    NSString *s2 = [self.dataSource[6] substringWithRange:NSMakeRange(6, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcExchangeMethod{
    
    NSString *s1 = [self.dataSource[7] substringWithRange:NSMakeRange(7, 1)];
    NSString *s2 = [self.dataSource[8] substringWithRange:NSMakeRange(8, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcIn{
    
    NSString *s1 = [self.dataSource[9] substringWithRange:NSMakeRange(9, 1)];
    NSString *s2 = [self.dataSource[10] substringWithRange:NSMakeRange(10, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcCF{
    
    NSString *s1 = [self.dataSource[11] substringWithRange:NSMakeRange(11, 1)];
    NSString *s2 = [self.dataSource[12] substringWithRange:NSMakeRange(12, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcShare{
 
    NSString *s1 = [self.dataSource[13] substringWithRange:NSMakeRange(13, 1)];
    NSString *s2 = [self.dataSource[14] substringWithRange:NSMakeRange(14, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcRabbit {
    NSString *s1 = [self.dataSource[15] substringWithRange:NSMakeRange(15, 1)];
    NSString *s2 = [self.dataSource[16] substringWithRange:NSMakeRange(16, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)xcForLight {
    NSString *s1 = [self.dataSource[17] substringWithRange:NSMakeRange(16, 1)];
    NSString *s2 = [self.dataSource[17] substringWithRange:NSMakeRange(16, 1)];
    return [NSString stringWithFormat:@"%@%@",s1,s2];
}

- (NSString *)myAppName {
    return MyAppName;
}

@end
