//
//  XCPutPictureCollectionView.h
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMacros.h"

@protocol XCPutPictureCollectionViewDelegate <NSObject>

///图片数据更改
- (void)updatePhotoDataCallBaccWith:(NSArray *_Nullable)imageArr video:(NSString *_Nullable)videoPath cover:(UIImage *_Nonnull)cover;

@end

#define itemWH  (KScreenWidth - 15*2 - 10*2)/3      //item的大小
//#define putPictureCollectionHeight (itemWH * 2 + 10)        //collectionView的大小

NS_ASSUME_NONNULL_BEGIN

@interface XCPutPictureCollectionView : UIView

@property (nonatomic, weak) id<XCPutPictureCollectionViewDelegate> delegate;

///高度
@property (nonatomic, assign) CGFloat pictureCollectionHeight;

@property (nonatomic, assign) int haveCount;

///添加图片
- (void)addPhotoActions:(int)haveCount;


@end

NS_ASSUME_NONNULL_END
