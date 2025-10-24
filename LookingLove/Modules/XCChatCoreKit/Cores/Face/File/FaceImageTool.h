//
//  FaceImageTool.h
//  BberryCore
//
//  Created by 何卫明 on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceConfigInfo.h"
#import "FaceReceiveInfo.h"
#import "FaceCore.h"

typedef void(^IsFinish)(BOOL isFinish);

@interface FaceImageTool : NSObject

+ (instancetype)shareFaceImageTool;


/**
 查询并生成结果图
 
 @param receiveInfo 收到表情的对象
 @param imageView 展示表情的ImageView
 @param animation 是否展示表情动画
 @parm  dragon 是否是龙珠
 @param success 成功
 @param failure 失败
 @param isFinish 动画是不是结束了
 */
- (void)queryImage:(FaceReceiveInfo *)receiveInfo
         imageView:(UIImageView *)imageView
            dragon:(BOOL)dragon
    needAniomation:(BOOL)animation
           success:(void (^)(FaceReceiveInfo *info,UIImage *lastImage))success
           failure:(void (^)(NSError *))failure
          isFinish:(void (^)(BOOL isFinish))isFinish;

/**
 查询并生成结果图
 
 @param receiveInfo 收到表情的对象
 @param imageView 展示表情的ImageView
 @param animation 是否展示表情动画
 @parm  dragon 是否是龙珠
 @param success 成功
 @param failure 失败
 */

- (void)queryImage:(FaceReceiveInfo *)receiveInfo
         imageView:(UIImageView *)imageView
            dragon:(BOOL)dragon
    needAniomation:(BOOL)animation
           success:(void (^)(FaceReceiveInfo *info,UIImage *lastImage))success
           failure:(void (^)(NSError *))failure;

//- (void)saveImageWithArr:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos
//               imageView:(UIImageView *)imageView
//                 success:(void (^)(NSMutableArray<FaceReceiveInfo *> *))success
//                 failure:(void (^)(NSError *))failure;

@end
