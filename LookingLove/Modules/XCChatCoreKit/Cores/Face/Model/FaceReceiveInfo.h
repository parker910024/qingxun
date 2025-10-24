//
//  FaceReceiveInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"
#import "BaseObject.h"

@interface FaceReceiveInfo : BaseObject

@property (assign, nonatomic)UserID uid;
@property (copy, nonatomic) NSString *nick;
@property (assign, nonatomic) NSInteger faceId;
@property (strong, nonatomic) UIImage *resultImage;
@property (strong, nonatomic) NSMutableArray *resultIndexes;//骰子数
@end
