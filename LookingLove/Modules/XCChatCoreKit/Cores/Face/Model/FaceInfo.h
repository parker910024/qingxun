//
//  FaceInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface FaceInfo : BaseObject

@property (assign, nonatomic) NSInteger faceId;
@property (copy, nonatomic) NSString *faceName;
@property (assign, nonatomic) NSInteger faceParentId;
@property (copy, nonatomic) NSString *facePicUrl;
@property (assign, nonatomic) BOOL hasGifUrl;
@property (copy, nonatomic) NSString *faceGifUrl;
@property (assign, nonatomic) BOOL show;
@property (strong, nonatomic) NSArray *children;
@property (assign, nonatomic) NSInteger faceValue;
@end
