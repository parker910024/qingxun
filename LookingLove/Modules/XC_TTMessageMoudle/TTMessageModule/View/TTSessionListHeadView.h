//
//  TTSessionListHeadView.h
//  TuTu
//
//  Created by lee on 2018/12/28.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTSessionListHeadView;
@class MentoringGrabModel;

@protocol TTSessionListHeadViewDelegate <NSObject>
/**
 点击了抢徒弟按钮

 @param headerView 头部的view
 @param uid 被抢的徒弟的uid
 */
- (void)sessionListHeadView:(TTSessionListHeadView *)headerView didClickGoButtonWithUid:(long long)uid;
@end

@interface TTSessionListHeadView : UIView

@property (nonatomic, weak) id<TTSessionListHeadViewDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray<MentoringGrabModel *> *grabModels;
@end

NS_ASSUME_NONNULL_END
