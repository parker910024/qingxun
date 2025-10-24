//
//  FaceSendInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface FaceSendInfo : BaseObject

@property (strong, nonatomic) NSArray *data; //faceRecieveInfos
@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSDictionary *encodeAttachemt;
@end
