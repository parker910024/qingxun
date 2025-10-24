//
//  TTMagicCell.h
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMineInfoMagicCell : UICollectionViewCell
@property (nonatomic, strong) NSArray  *userMagicList;//被施展魔法
@property (nonatomic, strong) NSArray *carrotGiftList; // 萝卜礼物
@property(nonatomic, assign) BOOL isCarrot; //
@end

NS_ASSUME_NONNULL_END
