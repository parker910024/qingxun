//
//  TTMessageView+NonsupportMessage.h
//  TTPlay
//
//  Created by Macx on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (NonsupportMessage)
- (void)handleNonsupportMessageCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
