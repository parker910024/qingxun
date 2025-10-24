//
//  LLGoddessUserCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTGoddessViewDelegate;
@class HomeV5Data;

@interface LLGoddessUserCell : UITableViewCell

@property (nonatomic, assign) id<TTGoddessViewDelegate> delegate;
@property (nonatomic, strong) HomeV5Data *model;

@end

NS_ASSUME_NONNULL_END
