//
//  TTWorldletNavView.h
//  XC_TTGameMoudle
//
//  Created by apple on 2019/6/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTWorldletNavView;

@protocol TTWorldletNavViewDelegate <NSObject>

- (void)didClickBackBtnAction:(TTWorldletNavView *_Nonnull)view;

- (void)didClickMenuBtnAction:(TTWorldletNavView *_Nonnull)view;

- (void)didClickHelpBtnAction:(TTWorldletNavView *_Nonnull)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletNavView : UIView

@property (nonatomic, weak) id<TTWorldletNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
