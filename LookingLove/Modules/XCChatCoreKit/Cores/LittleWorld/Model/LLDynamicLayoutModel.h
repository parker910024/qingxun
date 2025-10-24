//
//  LLDynamicLayoutModel.h
//  XCChatCoreKit
//
//  Created by lee on 2020/1/8.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLDynamicModel.h"

static CGFloat const KCardContainerPadding = 10;
static CGFloat const KContentPadding = 25;
static CGFloat const KHeadNameFont = 15;
static CGFloat const KHeadDateFont = 12;
static CGFloat const KHeadIconSize = 45;
static CGFloat const KHeadImagePadding = 12;
static CGFloat const KIconNamePadding = 10;
static CGFloat const KNameDatePadding = 2;
static CGFloat const KConnectPadding = 10;
static CGFloat const KPicPadding = 6;

#define ALBUM_IMAGE_INTERVAL 8
#define KCellContentWidth ([UIScreen mainScreen].bounds.size.width - 20 * 2)
#define kCellSquareWidht (KCellContentWidth - 25 * 2)
#define KNameMaxWidth ([UIScreen mainScreen].bounds.size.width - 160)

// 默认宽度
static CGFloat kCellWidth = 0;

NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicLayoutModel : NSObject

@property (nonatomic, strong) LLDynamicModel *dynamicModel;
// cell row height
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat squareRowHeight;
// profile
@property (nonatomic, assign) CGRect profileF;
@property (nonatomic, assign) CGRect AvatarF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect dateSourceF;
@property (nonatomic, assign) CGRect anchorTagF;//主播标签
// text
@property (nonatomic, assign) CGRect textF;
@property (nonatomic, assign) CGRect openUpBtnF;
// toolbar
@property (nonatomic, assign) CGRect toolBarF;
// orderBar
@property (nonatomic, assign) CGRect orderBarF;
// pics
@property (nonatomic, assign) CGRect sudokuPicsF;
// worldTag
@property (nonatomic, assign) CGRect worldTagViewF;
// 文本行数
@property (nonatomic, assign) NSInteger numberOfText;
// time
@property (nonatomic, copy) NSString *timeStr;
/// 是否是推荐列表
@property (nonatomic, assign) BOOL isRecommendDynamic;
// 小世界动态初始化使用
+ (instancetype)layoutWithStatusModel:(LLDynamicModel *)dynamic;
// 刷新布局
- (void)reloadLayout;
@end

NS_ASSUME_NONNULL_END
