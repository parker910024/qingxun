//
//  TTHeadLineContainerController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTHeadLineContainerController.h"

//view
#import "ZJSegmentStyle.h"
#import "ZJScrollPageView.h"
//vc
#import "TTHeadLineController.h"
#import "TTPublicChatAboutMeContainerController.h"
#import "TTPublicNIMChatroomController.h"
//theme
#import "XCTheme.h"

//const
#import "XCMacros.h"
#import "XCHtmlUrl.h"

//menu
#import "TTItemMenuView.h"

//core
#import "ImPublicChatroomCore.h"

@interface TTHeadLineContainerController ()
<
    ZJScrollPageViewDelegate,
    UIGestureRecognizerDelegate,
    TTItemMenuViewDelegate
>

/**
 标题
 */
@property(strong, nonatomic)NSArray<NSString *> *titles;

/**
 子控制器
 */
@property(strong, nonatomic)NSArray<UIViewController *> *vcs;

/**
 滑动view
 */
@property (nonatomic, strong) ZJScrollPageView *scrollPage;

/**
 滑块
 */
@property (strong, nonatomic) ZJScrollSegmentView *segementView;

@property (strong, nonatomic) ZJContentView *contentView;

/**
 是否能返回
 */
@property (nonatomic, assign) BOOL isCanBack;

@property (strong, nonatomic) TTItemMenuView *menuView;
@end

@implementation TTHeadLineContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}

- (void)initView {

    [self addNavigationItemWithImageNames:@[@"message_public_more_icon"] isLeft:NO target:self action:@selector(rightBarbuttonItemClick:) tags:nil];
//    self.navigationItem.titleView = self.scrollPage;
    self.navigationItem.titleView = self.segementView;
    
    [self.view addSubview:self.contentView];

}

- (void)initConstrations {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetSideBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}

#pragma mark - TTItemMenuViewDelegate

- (void)menuView:(TTItemMenuView *)addMenuView didSelectedItem:(TTItemMenuItem *)item {
    if (item.indexPath.row == 0) {
        TTPublicChatAboutMeContainerController *vc = [[TTPublicChatAboutMeContainerController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.indexPath.row == 1){
        TTHeadLineController *vc = [[TTHeadLineController alloc]init];
        vc.urlString = HtmlUrlKey(kFaceWallURL);
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.indexPath.row == 2) {
        TTHeadLineController *vc = [[TTHeadLineController alloc]init];
        vc.urlString = HtmlUrlKey(kPublicChatHelpURL);
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    
    if (!childVc) {
        if (index == 0) {
            NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",(long)GetCore(ImPublicChatroomCore).publicChatroomId] type:NIMSessionTypeChatroom];
//            NIMSession *session = [NIMSession session:@"57147316" type:NIMSessionTypeChatroom];
            
            TTPublicNIMChatroomController *chatroom = [[TTPublicNIMChatroomController alloc]initWithSession:session isPublicChat:YES];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)chatroom;
        }else if (index == 1) {
            TTHeadLineController *headline = [[TTHeadLineController alloc]init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)headline;
            headline.urlString = HtmlUrlKey(kHeadLineURL);
            
        }
    }
    return childVc;
}

- (void)forbiddenSideBack {
    self.isCanBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
}

- (void)resetSideBack {
    self.isCanBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - private method

- (void)rightBarbuttonItemClick:(UIBarButtonItem *)item {
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView showInView:self.navigationController.view];
    }
}


#pragma mark - setter & getter

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollPage setSelectedIndex:self.currentPage - 1 animated:NO];
    [self.segementView setSelectedIndex:self.currentPage - 1 animated:YES];
    [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * (currentPage - 1), 0.0) animated:YES];

}

- (NSArray<NSString *> *)titles {
    return @[@"公聊大厅",@"头条"];
}

- (ZJScrollPageView *)scrollPage {
    if (!_scrollPage) {
        ZJSegmentStyle *segStyle = [[ZJSegmentStyle alloc]init];
        segStyle.showLine = YES;
        segStyle.titleFont = [UIFont systemFontOfSize:16];
        // 缩放标题
        segStyle.scaleTitle = YES;
        segStyle.titleBigScale = 1.1;
        segStyle.autoAdjustTitlesWidth = YES;
        segStyle.selectedTitleColor = UIColorFromRGB(0x333333);
        segStyle.normalTitleColor = UIColorFromRGB(0x999999);
        segStyle.scrollLineColor = [XCTheme getTTMainColor];
        segStyle.scrollContentView = NO;
        _scrollPage = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, kSafeAreaTopHeight + statusbarHeight + 44, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - statusbarHeight) segmentStyle:segStyle titles:self.titles parentViewController:self.navigationController delegate:self];
    }
    return _scrollPage;
}

- (TTItemMenuView *)menuView {
    if (!_menuView) {
        TTItemsMenuConfig *config = [TTItemsMenuConfig creatMenuConfigWithItemHeight:50 menuWidth:140 separatorInset:UIEdgeInsetsMake(0, 50, 0, 0) separatorColor:UIColorFromRGB(0xebebeb) backgroudColor:UIColorFromRGB(0xffffff)];
        
        
        TTItemMenuItem *item1 = [TTItemMenuItem creatWithTitle:@"与我相关" iconName:@"item_aboutme_icon" titleFont:[UIFont systemFontOfSize:15.f] titleColor:UIColorFromRGB(0x1a1a1a)];
        TTItemMenuItem *item2 = [TTItemMenuItem creatWithTitle:@"面壁墙" iconName:@"item_facewall_icon" titleFont:[UIFont systemFontOfSize:15.f] titleColor:UIColorFromRGB(0x1a1a1a)];
        TTItemMenuItem *item3 = [TTItemMenuItem creatWithTitle:@"帮助" iconName:@"item_help_icon" titleFont:[UIFont systemFontOfSize:15.f] titleColor:UIColorFromRGB(0x1a1a1a)];
        
        NSArray *items = @[item1,item2,item3];
        
        _menuView = [[TTItemMenuView alloc]initWithFrame:CGRectZero withConfig:config items:items];
        _menuView.delegate = self;
    }
    return _menuView;
}

- (ZJScrollSegmentView *)segementView {
    if (!_segementView) {
        ZJSegmentStyle *segStyle = [[ZJSegmentStyle alloc]init];
        segStyle.showLine = YES;
        segStyle.titleFont = [UIFont systemFontOfSize:16];
        segStyle.scrollTitle = NO;

        segStyle.autoAdjustTitlesWidth = YES;
        segStyle.selectedTitleColor = UIColorFromRGB(0x333333);
        segStyle.normalTitleColor = UIColorFromRGB(0x999999);
        segStyle.scrollLineColor = [XCTheme getTTMainColor];
        segStyle.scrollContentView = YES;
        @weakify(self);
        _segementView = [[ZJScrollSegmentView alloc]initWithFrame:CGRectMake(0, 0, 170, 30) segmentStyle:segStyle delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            @strongify(self);
            [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * index, 0.0) animated:YES];
        }];
        
    }
    return _segementView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        _contentView = [[ZJContentView alloc]initWithFrame:CGRectMake(0, statusbarHeight + 44, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - statusbarHeight - 44) segmentView:self.segementView parentViewController:self delegate:self];
    }
    return _contentView;
}


@end
