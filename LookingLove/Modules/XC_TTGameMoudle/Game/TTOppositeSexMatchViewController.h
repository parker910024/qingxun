//
//  TTOppositeSexMatchViewController.h
//  AFNetworking
//
//  Created by new on 2019/4/18.
//

#import "BaseUIViewController.h"

@class TTOppositeSexMatchViewController;

@protocol TTOppositeSexMatchViewControllerDelegate <NSObject>

- (void)oppositeSexMatchTimeoutWith:(TTOppositeSexMatchViewController *)object;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTOppositeSexMatchViewController : BaseUIViewController

@property (nonatomic, weak) id<TTOppositeSexMatchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
