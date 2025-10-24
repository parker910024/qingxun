//
//  TTMessageSegmentView.h
//  XC_TTMessageMoudle
//
//  Created by Macx on 2019/4/12.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTMessageSegmentView;

@protocol TTMessageSegmentViewDelegate <NSObject>

/** 点击了index标题 */
- (void)messageSegmentView:(TTMessageSegmentView *)navView didSelectWithIndex:(NSInteger)index;

@end

@interface TTMessageSegmentView : UIView
/** 代理 */
@property (nonatomic, weak) id<TTMessageSegmentViewDelegate> delegate;

- (void)updateButtonWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
