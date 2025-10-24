//
//  TTFamilyEditViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TTFamilyEditViewControllerDelegate <NSObject>

- (void)textFiledChangeEngEdit:(NSString *)text;

@end

@interface TTFamilyEditViewController : BaseUIViewController
@property (nonatomic, copy) NSString * defaultText;
@property (nonatomic, copy) NSString * placeHolder;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) id<TTFamilyEditViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
