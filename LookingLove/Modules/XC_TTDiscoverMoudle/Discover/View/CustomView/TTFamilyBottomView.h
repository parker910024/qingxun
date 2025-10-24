//
//  TTFamilyBottomView.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TTFamilyBottomViewDelegate <NSObject>

- (void)sureButtonActionWith:(UIButton *)sender;

@end
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyBottomView : UIView

@property (nonatomic, assign) id<TTFamilyBottomViewDelegate>delegate;
@property (nonatomic, strong) UIButton * sureButton;
@end

NS_ASSUME_NONNULL_END
