//
//  TTPublicChatAboutMeContainerController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatAboutMeContainerController.h"
//view
#import "ZJSegmentStyle.h"
#import "ZJScrollPageView.h"
//theme
#import "XCTheme.h"
//const
#import "XCMacros.h"
#import "XCHtmlUrl.h"
//vc
#import "TTPublicChatAboutMeController.h"
#import "TTHeadLineController.h"
//3rd
#import <Masonry/Masonry.h>

@interface TTPublicChatAboutMeContainerController ()
<
    ZJScrollPageViewDelegate,
    UIGestureRecognizerDelegate
>

/**
 标题
 */
@property(strong, nonatomic)NSArray<NSString *> *aboutMeTitles;

/**
 滑动view
 */
@property (nonatomic, strong) ZJContentView *scrollPageContentView;

/**
 滑块
 */
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;


/**
 是否能返回
 */
@property (nonatomic, assign) BOOL isCanBack;

@end

@implementation TTPublicChatAboutMeContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}


- (void)initView {
    self.navigationItem.titleView = self.segmentView;
    [self.view addSubview:self.scrollPageContentView];
}

- (void)initConstrations {
    [self.scrollPageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideBottom);
    }];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanBack;
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.aboutMeTitles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    
    if (!childVc) {
        if (index == 0) {
            NIMSession *session = [NIMSession session:@"57147316" type:NIMSessionTypeChatroom];
            TTPublicChatAboutMeController *aboutMeVc = [[TTPublicChatAboutMeController alloc]initWithSession:session];
            childVc = (UIViewController <ZJScrollPageViewChildVcDelegate>*)aboutMeVc;
        }else if (index == 1) {
            TTHeadLineController *headLineVc = [[TTHeadLineController alloc]init];
            NSString *urlStr = [NSString stringWithFormat:@"%@?%@",HtmlUrlKey(kHeadLineURL),@"atMe=1"];
            headLineVc.urlString = urlStr;
            childVc = (UIViewController <ZJScrollPageViewChildVcDelegate>*)headLineVc;
            
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

#pragma mark - setter & getter

- (NSArray<NSString *> *)aboutMeTitles {
    return @[@"我的消息",@"我的头条"];
}

- (ZJContentView *)scrollPageContentView {
    if (!_scrollPageContentView) {
        _scrollPageContentView = [[ZJContentView alloc]initWithFrame:CGRectMake(0, 44 + statusbarHeight + kSafeAreaTopHeight, KScreenWidth, self.view.bounds.size.height - statusbarHeight - 44) segmentView:self.segmentView parentViewController:self delegate:self];
        
    }
    return _scrollPageContentView;
}

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        ZJSegmentStyle *segStyle = [[ZJSegmentStyle alloc]init];
        segStyle.showLine = YES;
        segStyle.titleFont = [UIFont systemFontOfSize:16];
        segStyle.scrollTitle = NO;
        segStyle.autoAdjustTitlesWidth = YES;
        segStyle.selectedTitleColor = UIColorFromRGB(0x333333);
        segStyle.normalTitleColor = UIColorFromRGB(0x999999);
        segStyle.scrollLineColor = [XCTheme getTTMainColor];
        segStyle.scrollContentView = YES;
        segStyle.contentViewBounces = NO;
        _segmentView = [[ZJScrollSegmentView alloc]initWithFrame:CGRectMake(0, 0, 170, 30) segmentStyle:segStyle delegate:self titles:self.aboutMeTitles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [self.scrollPageContentView setContentOffSet:CGPointMake(self.scrollPageContentView.bounds.size.width * index, 0.0) animated:YES];
        }];
    }
    return _segmentView;
}

@end
