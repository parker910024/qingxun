//
//  YYEmptyContentToastView.h
//  YYMobile
//
//  Created by wuwei on 14/7/30.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYEmptyContentToastView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

+ (instancetype)instantiateEmptyContentToast;
+ (instancetype)instantiateNetworkErrorToast;
+ (instancetype)instantiateEmptyContentToastWithImage:(UIImage*)image;

+ (instancetype)instantiateEmptyContentToastWithImage:(UIImage*)image andTile:(NSString *)title;


@end
