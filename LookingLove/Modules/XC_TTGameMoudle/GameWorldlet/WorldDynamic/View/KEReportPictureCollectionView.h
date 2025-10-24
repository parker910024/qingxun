//
//  XCPutPictureCollectionView.h
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KEReportPictureCollectionViewDelegate <NSObject>

///图片数据更改
- (void)updatePhotoDataCallBaccWith:(NSArray *)imageArr;

@end

#define itemWH  (KScreenWidth - 15*2 - 23*2)/3      //item的大小
//#define putPictureCollectionHeight (itemWH * 2 + 10)        //collectionView的大小

NS_ASSUME_NONNULL_BEGIN

@interface KEReportPictureCollectionView : UIView

@property (nonatomic, weak) id<KEReportPictureCollectionViewDelegate> delegate;

///高度
@property (nonatomic, assign) CGFloat pictureCollectionHeight;

///添加图片
- (void)addPhotoActions;

@end

NS_ASSUME_NONNULL_END
