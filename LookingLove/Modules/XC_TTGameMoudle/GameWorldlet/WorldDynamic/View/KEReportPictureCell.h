//
//  XCPutPictureCell.h
//  UKiss
//
//  Created by apple on 2018/12/9.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KEReportPictureCell;

@protocol KEReportPictureCellDelegate <NSObject>

///添加图片回调
- (void)addPhotoCallBack;
///删除图片回调
- (void)deletePhotoCallBackWithCell:(KEReportPictureCell *)cell;

@end

static NSString *KEReportPictureCellIdentifier = @"KEReportPictureCell";

NS_ASSUME_NONNULL_BEGIN

@interface KEReportPictureCell : UICollectionViewCell

@property (nonatomic, weak) id<KEReportPictureCellDelegate> delegate;

@property (nonatomic, strong)  UIImage *__nullable image;

@end

NS_ASSUME_NONNULL_END
