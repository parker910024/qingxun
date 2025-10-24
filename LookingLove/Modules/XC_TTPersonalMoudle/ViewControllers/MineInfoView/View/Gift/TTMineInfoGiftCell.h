//
//  TTGiftCell.h
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseObject;
@interface TTMineInfoGiftCell : UICollectionViewCell

@property (strong, nonatomic)  UIImageView *giftImage;
@property (strong, nonatomic)  UILabel *giftName;
@property (strong, nonatomic)  UILabel *giftNumber;
@property (nonatomic, assign) BOOL isCarrot; // 是否是萝卜

- (void)configCellModel:(__kindof BaseObject *)baseObject;

@end

NS_ASSUME_NONNULL_END
