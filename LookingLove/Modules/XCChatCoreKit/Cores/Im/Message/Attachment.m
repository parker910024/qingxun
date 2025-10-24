//
//  Attachment.m
//  BberryCore
//
//  Created by chenran on 2017/6/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "Attachment.h"
#import "NSObject+YYModel.h"

@implementation Attachment

- (NSString *)encodeAttachment {
    
    return [self yy_modelToJSONString];
}
@end
