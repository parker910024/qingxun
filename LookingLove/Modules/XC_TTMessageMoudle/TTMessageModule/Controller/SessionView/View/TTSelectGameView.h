//
//  TTSelectGameView.h
//  AFNetworking
//
//  Created by new on 2019/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CPGameListModel;

@protocol TTSelectGameViewDelegate <NSObject>

- (void)removeSelectGameView;

- (void)btnClickLaunchGameWithModel:(CPGameListModel *)model;

@end

@interface TTSelectGameView : UIView

@property (nonatomic, weak) id<TTSelectGameViewDelegate> delegate;

@property (nonatomic, strong) NSString *userUid;

@end

NS_ASSUME_NONNULL_END
