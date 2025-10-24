//
//  TTGuildIncomeStatisticSegmentView.h
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTGuildIncomeStatisticSegmentViewDelegate <NSObject>
- (void)guildIncomeStatisticSegmentViewDidSelectIndex:(NSInteger)index;
@end

@interface TTGuildIncomeStatisticSegmentView : UIView
@property (nonatomic, weak) id<TTGuildIncomeStatisticSegmentViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
