//
//  TTGameMenuView.h
//  XC_TTGameMoudle
//
//  Created by lee on 2019/6/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGameMenuModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TTGameMenuViewDismissBlock)(void);
typedef void(^TTGameMenuViewSelectBlock)(NSInteger index);

@interface TTGameMenuView : UIView

@property (nonatomic, copy) TTGameMenuViewDismissBlock dismissBlock;
@property (nonatomic, copy) TTGameMenuViewSelectBlock selectBlock;

- (instancetype)initMenuViewWithItems:(NSArray<TTGameMenuModel *> *)items
                             menuRect:(CGRect)menuRect;


@end


NS_ASSUME_NONNULL_END
