//
//  XCMyVestPictureView.h
//  UKiss
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLDynamicPictureCustomLayout : UICollectionViewFlowLayout

@end

typedef NS_ENUM(NSUInteger, LLDynamicPicViewStyle) {
    LLDynamicPicViewStyleLittleWorld = 0, // 小世界动态
    LLDynamicPicViewStyleSquare = 1, // 动态广场
};

@class LLDynamicImageModel;
@interface LTDynamicPictureView : UIView
///图片数组
@property (nonatomic, strong) NSArray<LLDynamicImageModel *> *imageUrls;

@property (nonatomic, copy) void (^oneImageSuccess)(CGFloat height);
@property (nonatomic, copy) void (^didTapEmptyAreaHandler)(void);//点击空白区域

//得到图片的高度
+ (CGFloat)getPictureViewHeightWithImageCount:(NSInteger)count;
+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<LLDynamicImageModel *> *)imageList;
+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<LLDynamicImageModel *> *)imageList realWidth:(CGFloat)width;
- (instancetype)initWithStyle:(LLDynamicPicViewStyle)style;

@end


