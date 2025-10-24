//
//  XCProjectType.m
//  XCConstKit
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "XCProjectType.h"

@implementation XCProjectType

+ (instancetype)sharedProjectType {
    static XCProjectType *projectType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projectType = [[self alloc] init];
        [projectType initProjectType];
    });
    return projectType;
}

- (void)initProjectType {
    if ([MyAppName isEqualToString:@"轻寻"]) {
        self.projectType = ProjectType_LookingLove;
    } else {
        self.projectType = ProjectType_LookingLove;
    }
}

@end
