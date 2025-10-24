//
//  TTWorldletBottomView.h
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleWorldListModel.h"
@class TTWorldletBottomView;

@protocol TTWorldletBottomViewDelegate <NSObject>

// 进入小世界群聊
- (void)enterChatBtnClick:(TTWorldletBottomView *_Nonnull)view;
// 小世界成员列表
- (void)worldletMemberBtnClick:(TTWorldletBottomView *_Nonnull)view;
// 加入小世界
- (void)joinWorldletBtnClick:(TTWorldletBottomView *_Nonnull)view;
// 发布小世界动态
- (void)postLittleWorldDynamicBtnClick:(TTWorldletBottomView *_Nonnull)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletBottomView : UIView

@property (nonatomic, strong) LittleWorldListItem *model;

@property (nonatomic, weak) id<TTWorldletBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
