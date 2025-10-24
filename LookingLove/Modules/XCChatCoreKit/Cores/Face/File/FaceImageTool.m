//
//  FaceImageTool.m
//  BberryCore
//
//  Created by 何卫明 on 2017/12/8.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "FaceImageTool.h"
#import "FaceCoreClient.h"

#define SPACES 15
@interface FaceImageTool () <CAAnimationDelegate>

@property (nonatomic, copy) IsFinish isFinish;

@end




@implementation FaceImageTool {
    dispatch_queue_t faceQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        faceQueue = dispatch_queue_create("com.yy.face.xcface.creatFace", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


+ (instancetype)shareFaceImageTool
{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    @weakify(self);
    dispatch_main_sync_safe(^{
        @strongify(self);
        if (self.isFinish) {
           self.isFinish(flag);
        }

    });
}

- (void)queryImage:(FaceReceiveInfo *)receiveInfo
         imageView:(UIImageView *)imageView
            dragon:(BOOL)dragon
    needAniomation:(BOOL)animation
           success:(void (^)(FaceReceiveInfo *info,UIImage *lastImage))success
           failure:(void (^)(NSError *))failure {
    
    __block CGSize size = imageView.frame.size;
    UIImage * result;
    if (receiveInfo.resultIndexes.count > 0) {
        if (dragon) {
            result = [self dragoncombineImageInOne:receiveInfo size:size];
        }else {
            result = [self combineImageInOne:receiveInfo size:size];
        }
        
        receiveInfo.resultImage = result;
    }
    dispatch_main_sync_safe(^{
        success(receiveInfo,result);
        if(animation){
            [self addAnimateInImageView:imageView receiveInfo:receiveInfo];
        }
        
    });
}


- (void)queryImage:(FaceReceiveInfo *)receiveInfo
         imageView:(UIImageView *)imageView
            dragon:(BOOL)dragon
    needAniomation:(BOOL)animation
           success:(void (^)(FaceReceiveInfo *info,UIImage *lastImage))success
           failure:(void (^)(NSError *))failure
          isFinish:(void (^)(BOOL isFinish))isFinish{
    self.isFinish = isFinish;
    [self queryImage:receiveInfo imageView:imageView dragon:dragon needAniomation:animation success:success failure:failure];
}


- (void)addAnimateInImageView:(UIImageView *)imageView receiveInfo:(FaceReceiveInfo *)receiveInfo {
    FaceConfigInfo *configInfo = [GetCore(FaceCore)findFaceInfoById:receiveInfo.faceId];
    if (receiveInfo.resultIndexes.count > 0) {
        /*==================== 动画数组 ================= */
        //创建CAKeyframeAnimation
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = configInfo.animDuration / 1000.0;
        animation.delegate = self;
        animation.repeatCount = configInfo.animRepeatCount;
        animation.removedOnCompletion = YES;
        animation.calculationMode = kCAAnimationDiscrete;
        
        //存放图片的数组
        NSMutableArray *faceArray = [NSMutableArray array];
        
        for (int i = (short)configInfo.animStartPos; i <= (short)configInfo.animEndPos; i ++) {
            UIImage *image = [GetCore(FaceCore)findFaceImageByConfig:configInfo index:i];
            if (image) {
                CGImageRef cgimg = image.CGImage;
                [faceArray addObject:(__bridge UIImage *)cgimg];
            }else {
                break;
            }
            
        }
        if (faceArray.count > 0) {
            animation.values = faceArray;
        }else {
            return;
        }
        
        
        /*==================== 结果数组 ================= */
        CAKeyframeAnimation *resultAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        resultAnimation.duration = 3;
        resultAnimation.delegate = self;
        resultAnimation.beginTime = configInfo.animRepeatCount * configInfo.animDuration / 1000.0;
        //存放图片的数组
        NSMutableArray *resultArray = [NSMutableArray array];
        
        if (receiveInfo.resultImage) {
            [resultArray addObject:(__bridge UIImage *)receiveInfo.resultImage.CGImage];
        }else {
            return;
        }
        if (resultArray.count > 0) {
            resultAnimation.values = resultArray;
        }else {
            return;
        }
        
        resultAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[animation,resultAnimation];
        group.duration = 3 + (configInfo.animDuration / 1000.0) * configInfo.animRepeatCount;
        group.delegate = self;
        [imageView.layer addAnimation:group forKey:nil];
        
        //        [imageView setImage:receiveInfo.resultImage];
    } else {
        /*==================== 动画数组 ================= */
        //创建CAKeyframeAnimation
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = configInfo.animDuration / 1000.0;
        animation.delegate = self;
        animation.repeatCount = configInfo.animRepeatCount;
        animation.removedOnCompletion = YES;
        animation.calculationMode = kCAAnimationDiscrete;
        //存放图片的数组
        NSMutableArray *faceArray = [NSMutableArray array];
        
        for (int i = (short)configInfo.animStartPos; i <= (short)configInfo.animEndPos; i ++) {
            UIImage *image = [GetCore(FaceCore)findFaceImageByConfig:configInfo index:i];
            if (image) {
                CGImageRef cgimg = image.CGImage;
                [faceArray addObject:(__bridge UIImage *)cgimg];
            }else {
                break;
            }
        }
        if (faceArray.count > 0) {
            animation.values = faceArray;
            [imageView.layer removeAnimationForKey:@"face"];
            [imageView.layer addAnimation:animation forKey:@"face"];
        }else {
            return;
        }
    }
    
}

//- (void)saveImageWithArr:(NSMutableArray<FaceReceiveInfo *> *)faceRecieveInfos
//               imageView:(UIImageView *)imageView
//                 success:(void (^)(NSMutableArray<FaceReceiveInfo *> *))success
//                 failure:(void (^)(NSError *))failure{
//    __block CGSize size = imageView.frame.size;
//    @weakify(self);
//    dispatch_async(faceQueue, ^{
//        @strongify(self);
//        for (FaceReceiveInfo *item in faceRecieveInfos) {
//            if (item.resultIndexes.count > 0) { //运气表情
//
//                __block UIImage * result = [self combineImageInOne:item size:size];
//                item.resultImage = result;
//            }else { //普通表情
////                FaceConfigInfo *configInfo = [GetCore(FaceCore)findFaceInfoById:item.faceId];
////                UIImage *singleImage = [GetCore(FaceCore)findFaceImageById:faceInfo.faceId index:index];
////                item.resultImage =
//            }
//        }
//        dispatch_main_sync_safe(^{
//            success(faceRecieveInfos);
//        });
//    });
//
//}




- (UIImage *)combineImageInOne:(FaceReceiveInfo *)faceInfo size:(CGSize)size {
    UIImage *result;
    NSInteger faceCount = faceInfo.resultIndexes.count > 9 ? 9 : faceInfo.resultIndexes.count;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat width = 0.0;
    CGFloat height;
    CGFloat whBit = 174.0 / 128.0;
    switch (faceInfo.resultIndexes.count) {
        case 1:
        {
            width = size.width;
            height = width / whBit;
        }
            break;
            
        case 2:
        case 3:
        case 4:
        {
            width = size.width / 2;
            height = width / whBit;
            //            height = size.height / 2;
            //            height =
        }
            break;
            
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            width = size.width / 3;
            height = width / whBit;
        }
            break;
            
        default:
            width = 0;
            height = 0;
            break;
    }
    
    CGFloat spaceX3 = 0; //三张图时的X间距
    CGFloat spaceX2 = (size.width - width * 2) / 2; //两张图时的X边距
    CGFloat spaceX1 = (size.width - width) / 2; //一张图时的X边距
    
    CGFloat spaceY3 = 0; //三张图时的Y间距
    CGFloat spaceY2 = (size.height - height * 2) / 2; //两张图时的Y间距
    CGFloat spaceY1 = (size.height - height) / 2; //一张图时的Y间距
    
    y = faceCount > 6 ? spaceY3 : (faceCount >= 3 ? spaceY2 : spaceY1);
    x = faceCount % 3 == 0 && faceCount > 3 ? spaceX3 : (faceCount % 3 == 2 ? spaceX2 : spaceX1);
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    for (int i = 0; i < faceCount; i++) {
        NSInteger index = [faceInfo.resultIndexes[i] integerValue];
        FaceConfigInfo *configInfo = [GetCore(FaceCore)findFaceInfoById:faceInfo.faceId];
        UIImage *singleImage = [GetCore(FaceCore)findFaceImageById:faceInfo.faceId index:index];
        
        if (faceCount == 1) { //只有一张图片的时候直接返回不做处理
            return singleImage;
            break;
        }
        
        if (configInfo.displayType == XCFaceDisplayTypeFlow) {
            [singleImage drawInRect:CGRectMake(x, y, width, height)];
            //            x = width * (i % 3);
            if (i % 3 == 0) {   // 换行
                y += (height + spaceY3);
                x = spaceX3;
            }
            else if (i == 2 && faceCount == 3) {  // 换行，只有三个时
                y += (height + spaceY3);
                x = spaceX2;
            }
            else {
                x += (width + spaceX3);
            }
            //            y =
        }else if (configInfo.displayType == XCFaceDisplayTypeOverLay) {
            CGFloat whBit = singleImage.size.width / singleImage.size.height;
            width = size.width - (faceInfo.resultIndexes.count - 1) * SPACES;
            height = width / whBit;
            x = 0 + i * SPACES;
            y = size.height / 2 - height / 2;
            [singleImage drawInRect:CGRectMake(x, y, width, height)];
        }
        
        
    }
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

//龙珠处理


- (UIImage *)dragoncombineImageInOne:(FaceReceiveInfo *)faceInfo size:(CGSize)size {
    UIImage *result;
    NSInteger faceCount = faceInfo.resultIndexes.count > 9 ? 9 : faceInfo.resultIndexes.count;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat width = 0.0;
    CGFloat height;
    //    CGFloat whBit = 74 / 106.0;
    CGFloat whBit = 1;
    switch (faceInfo.resultIndexes.count) {
        case 1:
        {
            width = size.width;
            height = width / whBit;
        }
            break;
            
        case 2:
        case 3:
        case 4:
        {
            width = size.width / 2;
            height = width / whBit;
        }
            break;
            
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            width = size.width / 3;
            height = width / whBit;
        }
            break;
            
        default:
            width = 0;
            height = 0;
            break;
    }
    
    CGFloat spaceX3 = 0; //三张图时的X间距
    CGFloat spaceX2 = (size.width - width * 2) / 2; //两张图时的X边距
    CGFloat spaceX1 = (size.width - width) / 2; //一张图时的X边距
    
    CGFloat spaceY3 = 0; //三张图时的Y间距
    CGFloat spaceY2 = (size.height - height * 2) / 2; //两张图时的Y间距
    CGFloat spaceY1 = (size.height - height) / 2; //一张图时的Y间距
    
    y = faceCount > 6 ? spaceY3 : (faceCount >= 3 ? spaceY2 : spaceY1);
    x = faceCount % 3 == 0 && faceCount > 3 ? spaceX3 : (faceCount % 3 == 2 ? spaceX2 : spaceX1);
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    FaceConfigInfo *configInfo = [GetCore(FaceCore)findFaceInfoById:faceInfo.faceId];
    if (configInfo.displayType == XCFaceDisplayTypeOnlyOneLine)  {
        UIImage *singleImage = [GetCore(FaceCore)findFaceImageById:faceInfo.faceId index:configInfo.animStartPos];
        [singleImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    
    for (int i = 0; i < faceCount; i++) {
        NSInteger index = [faceInfo.resultIndexes[i] integerValue];
        //        FaceConfigInfo *configInfo = [GetCore(FaceCore)findFaceInfoById:faceInfo.faceId];
        UIImage *singleImage = [GetCore(FaceCore)findFaceImageById:faceInfo.faceId index:index];
        
        if (faceCount == 1) { //只有一张图片的时候直接返回不做处理
            return singleImage;
            break;
        }
        
        if (configInfo.displayType == XCFaceDisplayTypeFlow) {
            [singleImage drawInRect:CGRectMake(x, y, width, height)];
            
            if (i % 3 == 0) {   // 换行
                y += (height + spaceY3);
                x = spaceX3;
            }
            else if (i == 2 && faceCount == 3) {  // 换行，只有三个时
                y += (height + spaceY3);
                x = spaceX2;
            }
            else {
                x += (width + spaceX3);
            }
            
        }else if (configInfo.displayType == XCFaceDisplayTypeOverLay) {
            CGFloat whBit = singleImage.size.width / singleImage.size.height;
            width = size.width - (faceInfo.resultIndexes.count - 1) * SPACES;
            height = width / whBit;
            x = 0 + i * SPACES;
            y = size.height / 2 - height / 2;
            [singleImage drawInRect:CGRectMake(x, y, width, height)];
        }else if (configInfo.displayType == XCFaceDisplayTypeOnlyOneLine) {
            CGFloat whBit = singleImage.size.width / singleImage.size.height;
            width = (size.width-SPACES*2)/faceCount;
            height = width / whBit;
            x = width*i+SPACES;
            y = size.height / 2 - height / 2;
            [singleImage drawInRect:CGRectMake(x, y, width, height)];
        }
        
        
    }
    
    
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}



@end
