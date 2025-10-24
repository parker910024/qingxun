//
//  TTWorldletTypeListView.h
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleWorldCategory.h"

@class TTWorldletTypeListView;

@protocol TTWorldletTypeListViewDelegate <NSObject>

- (void)worldletTypeClickWithName:(LittleWorldCategory *)model;
- (void)worldletTypeViewDismiss:(TTWorldletTypeListView *_Nonnull)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletTypeListView : UIView

@property (nonatomic, strong) NSMutableArray<LittleWorldCategory *> *dataArray;

@property (nonatomic, weak) id<TTWorldletTypeListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
