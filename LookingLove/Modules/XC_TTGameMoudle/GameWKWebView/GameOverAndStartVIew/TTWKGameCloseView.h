//
//  TTWKGameCloseView.h
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTWKGameCloseViewDelegate <NSObject>

- (void)closeCurrentPage;

- (void)changeVoiceCurrentPage;

- (void)helpWithCurrentPage;

@end


NS_ASSUME_NONNULL_BEGIN

@interface TTWKGameCloseView : UIView

@property (nonatomic, assign) id<TTWKGameCloseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
