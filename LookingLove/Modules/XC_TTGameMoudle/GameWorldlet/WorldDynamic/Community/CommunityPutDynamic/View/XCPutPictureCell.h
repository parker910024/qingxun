//
//  XCPutPictureCell.h
//  UKiss
//
//  Created by apple on 2018/12/9.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCPutPictureCell;

@protocol XCPutPictureCellDelegate <NSObject>

///添加图片回调
- (void)addPhotoCallBack;
///删除图片回调
- (void)deletePhotoCallBackWithCell:(XCPutPictureCell *)cell;

@end

static NSString *XCPutPictureCellIdentifier = @"XCPutPictureCell";

NS_ASSUME_NONNULL_BEGIN

@interface XCPutPictureCell : UICollectionViewCell

@property (nonatomic, weak) id<XCPutPictureCellDelegate> delegate;

@property (nonatomic, strong)  UIImage *__nullable image;

@property (nonatomic, assign) BOOL showPlay;

@end

NS_ASSUME_NONNULL_END
