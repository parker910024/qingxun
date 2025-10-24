//
//  TTActionSheetView.h
//  XC_TTChatViewKit
//
//  Created by lee on 2019/5/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPopupConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class TTActionSheetConfig;

@interface TTActionSheetView : UIView

@property (nonatomic, copy) TTPopupCompletionHandler cancelAction;
@property (nonatomic, copy) TTPopupCompletionHandler dismissAction;

- (instancetype)initWithFrame:(CGRect)frame
                   needCancel:(BOOL)needCancel
                        items:(NSArray<TTActionSheetConfig *> *)items;
@end

NS_ASSUME_NONNULL_END
