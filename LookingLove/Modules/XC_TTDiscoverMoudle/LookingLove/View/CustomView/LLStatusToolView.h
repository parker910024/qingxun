//
//  LLStatusToolView.h
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLDynamicLayoutModel, LLStatusToolView;

NS_ASSUME_NONNULL_BEGIN

@protocol LLStatusToolViewDelegate <NSObject>

- (void)didSelectActionAtToolView:(LLStatusToolView *)toolView;

@end

@interface LLStatusToolView : UIView

@property (nonatomic, strong) LLDynamicLayoutModel *layout;
@property(nonatomic, weak) id<LLStatusToolViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
