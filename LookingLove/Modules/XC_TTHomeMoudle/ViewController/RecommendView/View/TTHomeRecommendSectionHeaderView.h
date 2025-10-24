//
//  TTHomeRecommendTableHeaderView.h
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  首页推荐 section 头部

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTHomeRecommendSectionHeaderViewConfig;

typedef void(^ClickActionHandle)(void);

@interface TTHomeRecommendSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) ClickActionHandle clickHandle;
@property (nonatomic, strong) TTHomeRecommendSectionHeaderViewConfig *config;
@end

@interface TTHomeRecommendSectionHeaderViewConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;///如果子标题为空，则不显示分隔线

@property (nonatomic, copy) NSString *actionTitle;///如果操作按钮标题为空，则不显示
@property (nonatomic, copy) NSString *actionImage;
@end
NS_ASSUME_NONNULL_END
