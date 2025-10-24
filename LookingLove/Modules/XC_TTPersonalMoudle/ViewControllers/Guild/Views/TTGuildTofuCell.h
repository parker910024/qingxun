//
//  TTGuildTofuCell.h
//  TuTu
//
//  Created by lee on 2019/1/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kGuildTofuConst = @"kGuildTofuConst";

@class GuildHallMenu;
@interface TTGuildTofuCell : UICollectionViewCell

/**
 是否显示三分图，默认:NO
 */
@property (nonatomic, assign) BOOL isShowThirdPic;

@property (nonatomic, strong) GuildHallMenu *hallMenu;

@end

NS_ASSUME_NONNULL_END
