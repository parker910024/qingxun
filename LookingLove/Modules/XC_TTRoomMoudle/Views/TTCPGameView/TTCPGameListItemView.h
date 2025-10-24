//
//  TTCPGameListItemView.h
//  TuTu
//
//  Created by new on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTCPGameListItemView : UIView

@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, assign) NSInteger index;

- (void)resetFrame:(CGFloat)scale;

-(void)CPGameModel:(CPGameListModel *)model;

@end

NS_ASSUME_NONNULL_END
