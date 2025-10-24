//
//  XCFamilyModel.m
//  BberryCore
//
//  Created by gzlx on 2018/6/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCFamilyModel.h"
#import "XCKeyWordTool.h"

@implementation XCFamilyModel

- (NSString *)name
{
    if (_name) {
        return _name;
    }else{
        return @"暂无昵称";
    }
}

- (NSString *)erbanNo
{
    if (_erbanNo) {
        return _erbanNo;
    }else{
        return [NSString stringWithFormat:@"暂无%@号", [XCKeyWordTool sharedInstance].myAppName];
    }
}

- (NSString *)icon
{
    if (_icon.length > 0) {
        return _icon;
    }else{
        return @"https://img.erbanyy.com/logo.png";
    }
}


@end

