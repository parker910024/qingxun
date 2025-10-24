//
//  TTWithdrawViewCell.h
//  TuTu
//
//  Created by lee on 2018/11/6.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WithDrawalInfo, RedWithdrawalsListInfo;
@interface TTOutputViewCell : UICollectionViewCell

@property (nonatomic, strong) WithDrawalInfo *codeRedInfo;
@property (nonatomic, strong) RedWithdrawalsListInfo *redDrawInfo;
@end

NS_ASSUME_NONNULL_END
