//
//  TTWKGameStartView.h
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGameInformationModel.h"

@protocol TTWKGameStartViewDelegate <NSObject>

- (void)switchChangeWatch;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTWKGameStartView : UIView

@property (nonatomic, strong) TTGameInformationModel *dataModel;

@property (nonatomic, assign) BOOL watching;

@property (nonatomic, weak) id<TTWKGameStartViewDelegate> delegate;

@property (nonatomic, assign) BOOL hiddenWatchBtnBool;

@end

NS_ASSUME_NONNULL_END
