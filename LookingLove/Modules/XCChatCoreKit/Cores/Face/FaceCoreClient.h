//
//  FaceCoreClient.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceInfo.h"
#import "FaceReceiveInfo.h"
#import "FacePlayInfo.h"

@protocol FaceCoreClient <NSObject>
@optional	
- (void)onFaceIsResult:(FacePlayInfo *)info;
- (void)onReceiveFace:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos;
- (void)onGetFaceJsonSuccess;
//龙珠发送成功
- (void)onDragonSendSuccess;
- (void)onDragonSendFailth:(NSString *)msg;
@end
