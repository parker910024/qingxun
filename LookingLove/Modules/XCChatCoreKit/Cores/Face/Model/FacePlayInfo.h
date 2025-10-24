//
//  FacePlayInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceReceiveInfo.h"
#import "BaseObject.h"

@interface FacePlayInfo : BaseObject

@property (assign, nonatomic) double delay;
@property (strong, nonatomic) NIMMessage *message;
@property (strong, nonatomic) FaceReceiveInfo *faceReceiveInfo;

@end
