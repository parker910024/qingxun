//
//  BaseNavigationController.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseUIViewController.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+(void)initialize{
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];//获取当前的
//    [UINavigationBar appearance];//获取所有的
    
    //设置title
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}] ;
    bar.backgroundColor = [UIColor clearColor];
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    UIColor * buttonitemColor = [UIColor whiteColor];
    if(projectType() == ProjectType_TuTu){
        buttonitemColor = UIColorFromRGB(0x666666);
    } else if(projectType() == ProjectType_Pudding){
        buttonitemColor = UIColorFromRGB(0x666666);
    }
    itemAttrs[NSForegroundColorAttributeName] = buttonitemColor;
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
    bar.barTintColor = [UIColor whiteColor];
    if(projectType() == ProjectType_VKiss){
        [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:UIColorFromRGB(0xA49EFE)}];
        [bar setTranslucent:NO];
        bar.barTintColor = UIColorRGBAlpha(0x322B50, 1);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (void)initNavWithVC:(UIViewController *)viewController {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    leftBarButtonItem.tintColor = UIColorFromRGB(0x1a1a1a);
    
    if(projectType() == ProjectType_VKiss){
        leftBarButtonItem.tintColor =  UIColorFromRGB(0xA49EFE);
    }else if(projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB){
        leftBarButtonItem.tintColor =  UIColorFromRGB(0xc6c6c6);
    }
    
    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - 可在此方法中拦截所有push 进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.topViewController == viewController) return;
    
    if (self.childViewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self initNavWithVC:viewController];
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}

- (void)backClick{
    [self popViewControllerAnimated:YES];
}

//支持旋转
-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}



@end
