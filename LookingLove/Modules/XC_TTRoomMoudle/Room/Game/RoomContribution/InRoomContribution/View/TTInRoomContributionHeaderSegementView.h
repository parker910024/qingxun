//
//  XC_MSHeaderSegementView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  贡献榜、魅力榜

#import <UIKit/UIKit.h>
#import "RankCore.h"

@interface TTInRoomContributionHeaderSegementView : UIView

@property (nonatomic, copy) void(^segmentControlSelectedItem)(RankType rankType);

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end
