//
//  TTRoomMusicContainerViewController.m
//  TTPlay
//
//  Created by Macx on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomMusicContainerViewController.h"

#import "TTRoomShareMusicViewController.h"
#import "TTWebTransportViewController.h"

//view
#import "ZJTitleView.h"
#import "ZJSegmentStyle.h"
#import "ZJScrollSegmentView.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import <BaiduMobStatCodeless/BaiduMobStat.h>

@interface TTRoomMusicContainerViewController ()<ZJScrollPageViewDelegate>
@property (strong, nonatomic) TTMusicListController *musicListVC;
@property (strong, nonatomic) TTRoomShareMusicViewController *shareMusicListVC;
/* 标题数组 */
@property(strong, nonatomic) NSArray<NSString *> *titles;
/* 子控制器数组 */
@property(strong, nonatomic) NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) ZJContentView *contentView;
/**
 滑块样式
 */
@property (nonatomic, strong) ZJSegmentStyle *style;

/**
 返回按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/** add */
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation TTRoomMusicContainerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> * vc = reuseViewController;
    if (!vc) {
        switch (index) {
                case 0:
                vc = self.musicListVC;
                break;
                case 1:
                [[BaiduMobStat defaultStat] logEvent:@"sharing_music" eventLabel:@"共享音乐"];
                vc = self.shareMusicListVC;
                break;
        }
    }
    CGRect frame = vc.view.frame;
    frame.size.height = KScreenHeight - 44 - statusbarHeight;
    vc.view.frame = frame;
    vc.view.backgroundColor = [UIColor clearColor];
    return vc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addButtonClick:(UIButton *)sender {
    TTWebTransportViewController *vc = [[TTWebTransportViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method

- (void)initView {
    self.childVcs = @[self.musicListVC, self.shareMusicListVC];
    self.titles = @[@"我的曲库", @"共享音乐"];
    [self setupSegmentView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.addButton];
}

- (void)initConstrations {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.top.mas_equalTo(statusbarHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(statusbarHeight);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
}

- (void)setupSegmentView {
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = NO;
    style.scrollTitle = NO;
    style.titleFont = [UIFont boldSystemFontOfSize:16];
    style.scaleTitle = YES;
    style.titleBigScale = 1.1;
    style.coverBackgroundColor = [UIColor clearColor];
    style.normalTitleColor = [XCTheme getTTDeepGrayTextColor];
    style.selectedTitleColor = [XCTheme getTTMainTextColor];
    
    __weak typeof(self) weakSelf = self;
    ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, statusbarHeight, 200.0, 44.0) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        [[BaiduMobStat defaultStat] logEvent:@"sharing_music" eventLabel:@"共享音乐"];
        [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
    }];
    
    self.segmentView = segment;
    self.segmentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.segmentView];
}

#pragma mark - getters and setters
- (ZJContentView *)contentView {
    if (!_contentView) {
        _contentView = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, 44.0 + statusbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - 44.0 - statusbarHeight) segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.collectionView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setImage:[UIImage imageNamed:@"room_music_list_add"] forState:UIControlStateNormal];
    }
    return _addButton;
}

- (TTMusicListController *)musicListVC {
    if (!_musicListVC) {
        _musicListVC = [[TTMusicListController alloc] init];
        @weakify(self);
        _musicListVC.didClickAddShareMusicAction = ^{
            @strongify(self);
            [self.segmentView setSelectedIndex:1 animated:YES];
        };
    }
    return _musicListVC;
}

- (TTRoomShareMusicViewController *)shareMusicListVC {
    if (!_shareMusicListVC) {
        _shareMusicListVC = [[TTRoomShareMusicViewController alloc] init];
    }
    return _shareMusicListVC;
}

@end
