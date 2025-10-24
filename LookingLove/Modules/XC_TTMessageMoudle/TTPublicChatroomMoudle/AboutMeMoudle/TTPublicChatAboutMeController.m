//
//  TTPublicChatAboutMeController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatAboutMeController.h"

//tool
#import <Masonry/Masonry.h>
#import "UIViewController+EmptyDataView.h"

//view
#import "TTAboutMeSegementView.h"
#import "UIView+NIM.h"

//core
#import "PublicChatroomMessageCore.h"
#import "PublicChatroomCore.h"
#import "ImPublicChatroomCore.h"

//client
#import "PublicChatroomMessageClient.h"

//refresh
#import "UITableView+Refresh.h"

//const
#import "XCMacros.h"

//theme
#import "XCTheme.h"

//config
#import "TTPublicHistorySessionConfig.h"

@interface TTPublicChatAboutMeController ()
<
    TTAboutMeSegementViewDelegate,
    TTPublicHistorySessionConfigDelegate
>


@property (strong, nonatomic) TTAboutMeSegementView *segementView;

@property (strong, nonatomic) UIView *segementViewContainer;

@property (nonatomic,assign) NSInteger atMePage;

@property (nonatomic,assign) NSInteger meSendPage;

@property (strong, nonatomic) TTPublicHistorySessionConfig *config;

@end

@implementation TTPublicChatAboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    self.tableView.frame = CGRectMake(0, 35, KScreenWidth, KScreenHeight - statusbarHeight - 44 - kSafeAreaBottomHeight - 35);
}

- (void)initView {
    
    self.segementView.currentType = TTAboutMeSegementViewClickType_AtMe;
    self.atMePage = 1;
    self.meSendPage = 1;
    [self.segementViewContainer addSubview:self.segementView];
    [self.view addSubview:self.segementViewContainer];
//    [self.view addSubview:self.messageView];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
}

- (void)initConstrations {
    [self.segementViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(41);
        make.top.mas_equalTo(self.mas_topLayoutGuideTop);
    }];
    [self.segementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.segementViewContainer);
        make.width.mas_equalTo(184);
        make.height.mas_equalTo(29);
    }];

}

#pragma mark - private mathod

//- (void)setupTableView {
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segementView.nim_bottom + 50, KScreenWidth, KScreenHeight - statusbarHeight - 44 - kSafeAreaBottomHeight) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = UIColorFromRGB(0xe4e7ec);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    if ([self.sessionConfig respondsToSelector:@selector(sessionBackgroundImage)] && [self.sessionConfig sessionBackgroundImage]) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        imgView.image = [self.sessionConfig sessionBackgroundImage];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        self.tableView.backgroundView = imgView;
//    }
//    [self.view addSubview:self.tableView];
//}

#pragma mark - nim
- (id<NIMSessionConfig>)sessionConfig {
    return self.config;
}

#pragma mark - TTAboutMeSegementViewDelegate

- (void)onTTAboutMeSegementView:(TTAboutMeSegementView *)segement childSegementWasClick:(TTAboutMeSegementViewClickType)segementType {
    if (segementType == TTAboutMeSegementViewClickType_AtMe) {
        segement.currentType = TTAboutMeSegementViewClickType_AtMe;
        self.config.provider.type = TTPublicHistoryMessageDataProviderType_AtMe;
        self.config.provider.currentPage = 1;
        [self.interactor resetMessages];
    }else if (segementType == TTAboutMeSegementViewClickType_SendFromMe) {
        segement.currentType = TTAboutMeSegementViewClickType_SendFromMe;
        self.config.provider.type = TTPublicHistoryMessageDataProviderType_FromMe;
        self.config.provider.currentPage = 1;
        [self.interactor resetMessages];
    }
}

#pragma mark - TTPublicChatMessageViewDelegate

#pragma mark - TTPublicHistorySessionConfigDelegate

- (void)thereIsNoData {
    [self showEmptyDataViewWithTitle:@"你还没聊天记录哦！\n快去和好友聊天吧！" image:[UIImage imageNamed:@"common_noData_empty"] needInteractionEnabled:NO];
}

- (void)thereIsData {
    [self removeEmptyDataView];
}

#pragma mark - setter && getter

- (TTPublicHistorySessionConfig *)config {
    if (!_config) {
        _config = [[TTPublicHistorySessionConfig alloc]initWithSession:self.session];
        _config.provider.type = TTPublicHistoryMessageDataProviderType_AtMe;
        _config.provider.currentPage = 1;
        _config.delegate = self;
    }
    return _config;
}

- (TTAboutMeSegementView *)segementView {
    if (!_segementView) {
        _segementView = [[TTAboutMeSegementView alloc]init];
        _segementView.delegate = self;
    }
    return _segementView;
}

- (UIView *)segementViewContainer {
    if (!_segementViewContainer) {
        _segementViewContainer = [[UIView alloc]init];
        _segementViewContainer.backgroundColor = [UIColor whiteColor];
    }
    return _segementViewContainer;
}

@end
