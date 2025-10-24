//
//  TTSessionListHeaderCell.h
//  XC_TTMessageMoudle
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MentoringGrabModel;
typedef void(^GoButtonDidClickAction)(long long);
@interface TTSessionListHeaderCell : UICollectionViewCell
/** 抢徒弟按钮的被点击的回调 */
@property (nonatomic, strong) GoButtonDidClickAction goButtonDidClickAction;
/** model */
@property (nonatomic, strong) MentoringGrabModel *model;
@end

NS_ASSUME_NONNULL_END
