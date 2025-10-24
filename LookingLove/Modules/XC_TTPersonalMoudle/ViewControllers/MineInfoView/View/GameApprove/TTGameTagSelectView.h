//
//  TTGameTagSelectView.h
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificationModel.h"

@protocol TTGameTagSelectViewDelegate <NSObject>

- (void)deleteGameTagAndUpdateUserInfo;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameTagSelectView : UIView

@property (nonatomic, strong) CertificationModel *model;

@property (nonatomic, weak) id<TTGameTagSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
