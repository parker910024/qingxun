//
//  TTMessageContentViewController.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageContentViewController.h"
//vc
#import "TTFansViewController.h"
#import "TTFocusViewController.h"
#import "TTFriendListViewController.h"
//view
#import "TTMessageTopView.h"

//tool
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "NSDictionary+Safe.h"


@interface TTMessageContentViewController ()<TTMessageTopViewDelegate, UIScrollViewDelegate>
//顶部切换的view
@property (nonatomic, strong) TTMessageTopView * topView;
//底部的view
@property (nonatomic, strong) NSArray * childControllers;
@property (nonatomic, strong) UIScrollView * mainscrollView;

@property (nonatomic, strong) TTFansViewController * fansViewController;
@property (nonatomic, strong) TTFocusViewController * focusViewController;
@property (nonatomic, strong) TTFriendListViewController * friendListViewController;

@end

@implementation TTMessageContentViewController

#pragma mark - life cycle
- (BOOL)isHiddenNavBar{
    return self.selectPresentBlock == nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initContrations];
    [self addChildViewController];
    [self showVc:0];
    [self presentHandleSettings];
}

#pragma  mark - private method
- (void)initView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainscrollView];
}

- (void)initContrations{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(23);
        make.right.mas_equalTo(self.view).offset(-23);
        make.height.mas_equalTo(37);
    }];

    [self.mainscrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(KScreenWidth);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}

- (void)addChildViewController{
    [self addChildViewController:self.friendListViewController];
    
     [self addChildViewController:self.focusViewController];
    
    [self addChildViewController:self.fansViewController];

    self.childControllers = @[self.friendListViewController, self.focusViewController, self.fansViewController];
}

- (void)showVc:(NSInteger)index{
    CGFloat offsetX = index * KScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    [vc setValue:@(YES) forKey:@"isReload"];
    //判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) {
        return;
    }
//    vc.view.frame = CGRectMake(offsetX, 0, KScreenWidth, self.view.frame.size.height);
    vc.view.frame = CGRectMake(offsetX, 0, KScreenWidth, CGRectGetHeight(self.mainscrollView.frame));

    
    [self.mainscrollView addSubview:vc.view];
}


/**
 如果是赠送模式，做赠送回调配置
 赠送模式的判断是：是否实现了 selectPresentBlock
 */
- (void)presentHandleSettings {
    
    if (self.selectPresentBlock == nil) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [self.fansViewController setSelectPresentBlock:^(TTSendPresentUserInfo * _Nonnull user) {
        NSDictionary * dic = [user model2dictionary];
        weakself.selectPresentBlock(dic);
    }];
    
    [self.focusViewController setSelectPresentBlock:^(TTSendPresentUserInfo * _Nonnull user) {
        NSDictionary * dic = [user model2dictionary];
        weakself.selectPresentBlock(dic);
    }];
    
    [self.friendListViewController setSelectPresentBlock:^(TTSendPresentUserInfo * _Nonnull user) {
        NSDictionary * dic = [user model2dictionary];
        weakself.selectPresentBlock(dic);
    }];
}

#pragma mark - setters and  getters
- (TTMessageTopView *)topView {
    if (!_topView) {
        _topView = [[TTMessageTopView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (UIScrollView *)mainscrollView{
    if (!_mainscrollView) {
        _mainscrollView = [[UIScrollView alloc] init];
        _mainscrollView.delegate = self;
        _mainscrollView.backgroundColor = [UIColor whiteColor];
        _mainscrollView.pagingEnabled = YES;
        _mainscrollView.showsVerticalScrollIndicator = NO;
        _mainscrollView.showsHorizontalScrollIndicator = NO;
        _mainscrollView.bounces = NO;
        _mainscrollView.scrollsToTop = NO;
        _mainscrollView.contentSize = CGSizeMake(3 * KScreenWidth, 0);
    }
    return _mainscrollView;
}

- (TTFansViewController *)fansViewController{
    if (!_fansViewController) {
        _fansViewController = [[TTFansViewController alloc] init];
        if (self.isContacts) {
            _fansViewController.type = MessageVCType_Contacts;
        } else {
            _fansViewController.type = MessageVCType_SendHeaderWear;
        }
    }
    return _fansViewController;
}

- (TTFocusViewController *)focusViewController{
    if (!_focusViewController) {
        _focusViewController = [[TTFocusViewController alloc] init];
        if (self.isContacts) {
            _focusViewController.type = MessageVCType_Contacts;
        } else {
            _focusViewController.type = MessageVCType_SendHeaderWear;
        }
    }
    return _focusViewController;
}

- (TTFriendListViewController *)friendListViewController{
    if (!_friendListViewController) {
        _friendListViewController = [[TTFriendListViewController alloc] init];
        if (self.isContacts) {
            _friendListViewController.type = MessageVCType_Contacts;
        } else {
            _friendListViewController.type = MessageVCType_SendHeaderWear;
        }
    }
    return _friendListViewController;
}

#pragma mark - TTMessageTopViewDelegate
- (void)didClickButtonToReloadData:(UIButton *)sender{
    int page = sender.tag - 1000;
    [self.mainscrollView setContentOffset:CGPointMake(KScreenWidth * page, 0) animated:NO];
    [self showVc:page];
}

#pragma mark - UIScollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 计算最后的索引
        NSInteger toIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.topView updateButtonWithIndex:toIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 计算最后的索引
    NSInteger toIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.topView updateButtonWithIndex:toIndex];
    [self showVc:toIndex];
}

@end
