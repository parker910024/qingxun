//
//  NobleSourceInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleSourceInfo.h"
#import "UIColor+UIColor_Hex.h"


@implementation NobleSourceInfo

- (void)setValues:(NSMutableArray *)values {
    if (values.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        
        if (![values.firstObject isKindOfClass:[NSString class]]) {
            _values = values;
            return;
        }
        
        if ([[values.firstObject substringToIndex:4]containsString:@"http"]) {//如果字符串第一个为"h"则为url
            _sourceType = NobleSourceTypeURL;
            for (NSString *item in values) {
                NSURL *url = [NSURL URLWithString:item];
                [temp addObject:url];
            }
            _values = temp;
        }else if ([[values.firstObject substringToIndex:1]containsString:@"#"]) {//如果字符串第一个为"#"则为颜色
            _sourceType = NobleSourceTypeColor;
            for (NSString *item in values) {
                UIColor *color = [UIColor colorWithHexString:item];
                [temp addObject:color];
            }
            _values = temp;
        }else { //其余的都为int
            _sourceType = NobleSourceTypeID;
            for (NSString *item in values) {
                [temp addObject:item];
            }
            _values = temp;
        }
        
    }
}

@end
