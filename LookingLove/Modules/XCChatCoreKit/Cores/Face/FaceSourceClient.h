//
//  FaceSourceClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/12/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FaceSourceClient <NSObject>

@optional
//下载资源成功
- (void)loadFaceSourceSuccess;

@end
