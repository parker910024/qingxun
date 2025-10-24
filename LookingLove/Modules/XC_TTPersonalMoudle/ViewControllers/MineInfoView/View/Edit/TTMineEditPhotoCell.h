//
//  TTMineEditPhotoCell.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTMineEditPhotoCellDelegate <NSObject>

- (void)deletePhoto:(NSIndexPath *)indexPath;

@end

@interface TTMineEditPhotoCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *personalPhotoImagwView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<TTMineEditPhotoCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
