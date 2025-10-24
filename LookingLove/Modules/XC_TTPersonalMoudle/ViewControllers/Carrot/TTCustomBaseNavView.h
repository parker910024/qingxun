//
//  TTCustomBaseNavView.h
//  TTPlay
//
//  Created by lee on 2019/4/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTCustomBaseNavView;
@protocol TTCustomBaseNavViewDelegate <NSObject>

- (void)didClickBackButtonInMissionNavView:(TTCustomBaseNavView *)navView;
- (void)didClickRightBtn:(TTCustomBaseNavView *)nav;
@end
@interface TTCustomBaseNavView : UIView
@property (nonatomic, weak) id<TTCustomBaseNavViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
