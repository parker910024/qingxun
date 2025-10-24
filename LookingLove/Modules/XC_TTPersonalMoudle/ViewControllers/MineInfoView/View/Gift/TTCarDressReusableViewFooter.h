//
//  TTCarDressReusableViewFooter.h
//  TuTu
//
//  Created by lee on 2018/11/23.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTCarDressReusableViewFooterDelegate <NSObject>

- (void)gotoCarDressShopClick:(UIButton *)btn;

@end

@interface TTCarDressReusableViewFooter : UICollectionReusableView

@property (nonatomic, weak) id<TTCarDressReusableViewFooterDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
