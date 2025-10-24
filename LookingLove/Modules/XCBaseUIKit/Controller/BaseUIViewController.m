//
//  BaseUIViewController.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCMacros.h"
#import "XCTheme.h"
@interface BaseUIViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isCanBack;
@end

@implementation BaseUIViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 根据子类属性重写判断是否隐藏导航栏
    [self.navigationController setNavigationBarHidden:self.isHiddenNavBar animated:animated];
    
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            //iOS10,改变了导航栏的私有接口为_UIBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                
                if ([[UIDevice currentDevice].systemVersion doubleValue] >= 14.0) {
                    [view.subviews firstObject].hidden = NO;
                } else {
                    [view.subviews firstObject].hidden = YES;
                }
            }
            
        }else{
            //iOS10之前使用的是_UINavigationBarBackground
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                
                [view.subviews firstObject].hidden = YES;
            }
        }
    }];
}


#pragma mark  --------给导航栏上添加内容-----------
- (void)addNavigationItemWithTitles:(NSArray *)titles titleColor:(UIColor *)color isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -10;
    [items addObject:spaceItem];
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0, 30, 20);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        if(isLeft){
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            
        }
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (projectType() == ProjectType_VKiss) {
        self.view.backgroundColor = UIColorFromRGB(0x2B2541);
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNavRootViewController) {
        [self forbiddenSideBack];
    }
    //判断如果是页面是navigationController中的第一个页面就禁止左划手势，不然在第一个页面执行左划手势后在push不到第二个页面
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isNavRootViewController) {
        [self resetSideBack];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if (self.isNavRootViewController) {
        return self.isCanBack;
    } else {
        return YES;
    }
}

#pragma mark - 卡死情况
- (void)forbiddenSideBack {
    self.isCanBack = NO;
    //关闭ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)resetSideBack {
    self.isCanBack = YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


@end

