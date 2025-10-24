//
//  XCApplicationSharement.m
//  BberryCore
//
//  Created by gzlx on 2018/6/13.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "XCApplicationSharement.h"
#import "NSObject+YYModel.h"

@implementation XCApplicationSharement


- (NSString *)cellContent:(NIMMessage *)message{
    
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCApplicationSharement *customObject = (XCApplicationSharement*)object.attachment;
    
    if(customObject.second == Custom_Noti_Sub_Share_Commnunity) {
        return @"XCCommunityShareMessageContentView";
    }
    return @"XCApplicationContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
    XCApplicationSharement *customObject = (XCApplicationSharement*)object.attachment;
    
    if(customObject.second == Custom_Noti_Sub_Share_Commnunity) {
        return CGSizeMake(268, 107);
    }
    
    if (!(customObject.avatar.length > 0 && customObject.title.length > 0)) {
        customObject = [XCApplicationSharement yy_modelWithJSON:customObject.data];
    }
    CGFloat height = [customObject.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, height + 65);
}


@end
