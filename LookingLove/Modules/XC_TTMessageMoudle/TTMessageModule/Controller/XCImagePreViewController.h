//
//  XCImagePreViewController.h
//  XChat
//
//  Created by 何卫明 on 2017/10/23.
//  Copyright © 2017年 XC. All rights reserved.
//
//  聊天浏览图片

#import "BaseUIViewController.h"

@interface XCImagePreViewController : BaseUIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSString *ImageUrl;
@end

