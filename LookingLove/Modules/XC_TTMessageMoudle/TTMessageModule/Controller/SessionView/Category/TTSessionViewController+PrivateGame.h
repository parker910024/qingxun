//
//  TTSessionViewController+PrivateGame.h
//  TTPlay
//
//  Created by new on 2019/3/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSessionViewController.h"
#import "CPGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTSessionViewController (PrivateGame)<TTSelectGameViewDelegate>


- (void)requestGameListData;

- (void)selectGameWithGameListDelegate:(CPGameListModel *)model;


@end

NS_ASSUME_NONNULL_END
