//
//  TTMessageTopView.h
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTMessageTopViewDelegate <NSObject>

- (void)didClickButtonToReloadData:(UIButton *)sender;

@end

@interface TTMessageTopView : UIView
@property (nonatomic, assign) id<TTMessageTopViewDelegate> delegate;

- (void)updateButtonWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
