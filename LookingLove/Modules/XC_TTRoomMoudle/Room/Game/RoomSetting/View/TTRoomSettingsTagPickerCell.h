//
//  TTRoomSettingsTagPickerCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeTag;

@interface TTRoomSettingsTagPickerCell : UICollectionViewCell
@property (nonatomic, strong) HomeTag *homeTag;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
