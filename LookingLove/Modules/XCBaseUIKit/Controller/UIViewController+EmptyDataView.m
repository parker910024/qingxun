//
//  UIViewController+EmptyDataView.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "UIViewController+EmptyDataView.h"
#import "XCEmptyDataView.h"
#import <objc/runtime.h>
#import "XCMacros.h"
#import "XCTheme.h"

@implementation UIViewController (EmptyDataView)


- (void)showEmptyDataViewWithTitle:(NSString *)title{
    
    [self showEmptyDataViewWithTitle:title complete:nil];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title complete:(void (^)(void))complete{
    
    [self showEmptyDataViewWithTitle:title view:self.view complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title view:(UIView *)view complete:(void (^)(void))complete{
    
    if (!view) {
        return;
    }
    //remove
    if ([self.emptyDataView superview]) {
        [self.emptyDataView removeFromSuperview];
    }
    //add
    self.emptyDataView.frame = view.bounds;
    self.emptyDataView.title = title;
    [view addSubview:self.emptyDataView];
    if (complete) {
        complete();
    }
}



- (void)removeEmptyDataView{
    
    [self removeEmptyDataViewComplete:nil];
}

- (void)removeEmptyDataViewComplete:(void(^)(void))complete{
    
    if ([self.emptyDataView superview]) {
        [self.emptyDataView removeFromSuperview];
    }
    if (complete) {
        complete();
    }
}

// ==================new=======================
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image {
    [self showEmptyDataViewWithTitle:title image:image needInteractionEnabled:YES];
}
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image needInteractionEnabled:(BOOL)enable{
    [self showEmptyDataViewWithTitle:title image:image view:self.view offsetY:0 needInteractionEnabled:enable complete:nil];
}


- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(void))complete {
    [self showEmptyDataViewWithTitle:title image:image needInteractionEnabled:YES complete:complete];
}
- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image needInteractionEnabled:(BOOL)enable complete:(void (^)(void))complete{
    [self showEmptyDataViewWithTitle:title image:image view:self.view offsetY:0 needInteractionEnabled:enable complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view needInteractionEnabled:(BOOL)enable complete:(void (^)(void))complete {
    [self showEmptyDataViewWithTitle:title image:image offsetY:0 view:view complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view complete:(void(^)(void))complete {
    [self showEmptyDataViewWithTitle:title image:image view:view offsetY:0 needInteractionEnabled:YES complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image offsetY:(CGFloat)offsetY view:(UIView *)view complete:(void(^)(void))complete {
    [self showEmptyDataViewWithTitle:title image:image view:view offsetY:offsetY needInteractionEnabled:YES complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image offsetY:(CGFloat)offsetY view:(UIView *)view complete:(void(^)(void))complete {
    [self showEmptyDataViewWithTitle:title color:color image:image view:view offsetY:offsetY needInteractionEnabled:YES complete:complete];
}

- (void)showEmptyDataViewWithTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image view:(UIView *)view offsetY:(CGFloat)offsetY needInteractionEnabled:(BOOL)enable complete:(void (^)(void))complete{
    
    if (!view) {
        return;
    }
    
    //remove
    if ([self.emptyDataView superview]) {
        [self.emptyDataView removeFromSuperview];
    }
    
    //add
    self.emptyDataView.frame = view.bounds;
    self.emptyDataView.title = title;
    self.emptyDataView.image = image;
    self.emptyDataView.userInteractionEnabled = enable;
    
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // 萌声
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 128)*0.5, 150+offsetY, 128, 100);
        self.emptyDataView.messageLabel.textColor = UIColorFromRGB(0x999999);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:15];
    } else if (projectType() == ProjectType_Haha) { // 哈哈
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 175)*0.5, 150+offsetY, 175, 175);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
    } else if (projectType() == ProjectType_TuTu ||
               projectType() == ProjectType_Pudding ||
               projectType() == ProjectType_LookingLove) { // tutu
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, (KScreenHeight - 145) / 2 - 60+offsetY, 185, 145);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        if (color) {
            self.emptyDataView.messageLabel.textColor = color;
        }
        self.emptyDataView.margin = -45;
    } else {
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 175)*0.5, 150+offsetY, 175, 175);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
    }
    
    [view addSubview:self.emptyDataView];
    
    if (complete) {
        complete();
    }
}


- (void)showEmptyDataViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view offsetY:(CGFloat)offsetY needInteractionEnabled:(BOOL)enable complete:(void (^)(void))complete{
    
    [self showEmptyDataViewWithTitle:title color:nil image:image view:view offsetY:offsetY needInteractionEnabled:enable complete:complete];
}

- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image {
    [self showLoadFailViewWithTitle:title image:image view:self.view complete:nil];
}

- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(void))complete {
    [self showLoadFailViewWithTitle:title image:image view:self.view complete:complete];
}

- (void)showLoadFailViewWithTitle:(NSString *)title image:(UIImage *)image view:(UIView *)view complete:(void(^)(void))complete {
    
    if (!view) {
        return;
    }
    
    //remove
    if ([self.emptyDataView superview]) {
        [self.emptyDataView removeFromSuperview];
    }
    
    //add
    self.emptyDataView.frame = view.bounds;
    self.emptyDataView.title = title;
    self.emptyDataView.image = image;
    
    if (projectType() == ProjectType_MengSheng || projectType() == ProjectType_BB) { // mengsheng
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 128)*0.5, 150, 128, 100);
        self.emptyDataView.messageLabel.textColor = UIColorFromRGB(0x999999);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:15];
    } else if (projectType() == ProjectType_Haha) { // 哈哈
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 175)*0.5, 150, 175, 175);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
    } else if (projectType() == ProjectType_TuTu ||
               projectType() == ProjectType_Pudding ||
               projectType() == ProjectType_LookingLove) { // tutu
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, (KScreenHeight - 145) / 2 - 60, 185, 145);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        self.emptyDataView.margin = -45;
    } else {
        self.emptyDataView.imageFrame = CGRectMake((KScreenWidth - 175)*0.5, 150, 175, 175);
        self.emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        self.emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
    }
    
    //event
    [self.emptyDataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadDataWhenLoadFail)]];
    
    [view addSubview:self.emptyDataView];
    
    if (complete) {
        complete();
    }
}

/**
 提示加载失败, 点击重试时会调用此方法, 控制器中请重写此方法, 重新请求数据
 */
- (void)reloadDataWhenLoadFail {}

#pragma mark - Getters
- (XCEmptyDataView *)emptyDataView
{
    XCEmptyDataView *emptyDataView = objc_getAssociatedObject(self, _cmd);
    
    if (!emptyDataView) {
        emptyDataView = [[XCEmptyDataView alloc] initWithFrame:CGRectZero];
        objc_setAssociatedObject(self, _cmd, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emptyDataView;
}



@end
