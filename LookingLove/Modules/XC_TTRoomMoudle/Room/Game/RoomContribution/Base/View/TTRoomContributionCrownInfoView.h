//
//  XC_MSBaseContributionHeadCellView.h
//  AFNetworking
//
//  Created by zoey on 2019/2/12.
//  房间榜中的单个皇冠视图的信息显示

#import <UIKit/UIKit.h>

#import <YYLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomContributionCrownInfoView : UIView
@property (nonatomic, strong) UILabel *nameLabel;//房间名
@property (nonatomic, strong) UILabel *uidLabel;//uid
@property (nonatomic, strong) UILabel *accountLabel;//名次(NO.1, 距前一名 xxx）
@property (nonatomic, strong) UIImageView *genderImageView;//性别
@property (nonatomic, strong) UIStackView *nickStckView;
@end

NS_ASSUME_NONNULL_END
