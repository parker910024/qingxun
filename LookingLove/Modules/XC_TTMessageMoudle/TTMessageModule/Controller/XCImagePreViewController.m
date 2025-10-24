//
//  XCImagePreViewController.m
//  XChat
//
//  Created by 何卫明 on 2017/10/23.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCImagePreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+QiNiu.h"
#import "XCMacros.h"

#import "XCTheme.h"

@interface XCImagePreViewController ()

@end

@implementation XCImagePreViewController

- (void)viewWillAppear:(BOOL)animated {
    self.hiddenNavBar = NO;
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hiddenNavBar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片预览";
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationHeight)];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView qn_setImageImageWithUrl:self.ImageUrl placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserLibaryDetail];
    
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.bounds.size;
    
    
    float xRate = self.scrollView.bounds.size.width / self.imageView.bounds.size.width;
    float yRate = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
    self.scrollView.minimumZoomScale = MIN(MIN(xRate, yRate), 1);
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.bouncesZoom = YES;
    
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.imageView.center = self.scrollView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //    NSLog(@"%d from ZoomingInScrollView()", ++cnt);
    return self.imageView;
}


/* scrollview将要开始Zooming */
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    //    NSLog(@"%d from BeginZooming()", ++cnt);
}

/* scrollview已经发生了Zoom事件 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //    NSLog(@"%d from DidZoom()", ++cnt);
    
    if(self.imageView.frame.size.width >= self.scrollView.frame.size.width && self.imageView.frame.size.height >= self.scrollView.frame.size.height){
        self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    if(self.imageView.frame.size.width < self.scrollView.frame.size.width){
        self.imageView.frame = CGRectMake((self.scrollView.frame.size.width-self.imageView.frame.size.width)/2, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    if(self.imageView.frame.size.height < self.scrollView.frame.size.height){
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, (self.scrollView.frame.size.height-self.imageView.frame.size.height)/2, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    
}

/* scrollview完成Zooming */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

@end
