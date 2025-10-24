//
//  WBGameView.h
//  WanBan
//
//  Created by ShenJun_Mac on 2020/10/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameListModel.h"


@protocol WBGameViewDelegate <NSObject>
- (void)onClickWBGameView:(CPGameListModel *)gameInfo;
- (void)onClickCloseGameBtn:(CPGameListModel *)gameInfo;
@end

@interface WBGameView : UIView
//游戏模型
@property (nonatomic, strong) CPGameListModel *gameInfo;
//展示关闭按钮
@property (nonatomic, assign) BOOL showDeleteBtn;

@property(nonatomic,weak)  id <WBGameViewDelegate> delegate;
@end

