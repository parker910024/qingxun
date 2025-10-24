//
//  LLPickPicCollectionViewCell.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DeleteCellImageBlock)(UIImage *currentImage);

@interface LLPickPicCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) YYAnimatedImageView *imageView; // 图片view
@property (nonatomic, copy) DeleteCellImageBlock deleteImageBlock;
@property (nonatomic, strong) UIButton *deleteBtn; // 删除按钮
@end

NS_ASSUME_NONNULL_END
