//
//  TTGuildIncomeDetailsCell.h
//  TuTu
//
//  Created by lee on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kGuildIncomeDetailsConst = @"kGuildIncomeDetailsConst";
@class GuildIncomeDetail;
@interface TTGuildIncomeDetailsCell : UICollectionViewCell
@property (nonatomic, strong) GuildIncomeDetail *detailModel;
@end

NS_ASSUME_NONNULL_END
