
//
//  TTDressupPresentViewController.m
//  TuTu
//
//  Created by zoey on 2018/11/23.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//


#import "TTDressupPresentViewController.h"
//model
#import "UserInfo.h"
//
#import <Masonry/Masonry.h>
//bri
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTHomeMoudle.h"

@interface TTDressupPresentViewController ()
@property (strong , nonatomic) UIButton *rightBtn;
@end

@implementation TTDressupPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择好友";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self addChilVC];
}


- (void)addChilVC {
    @weakify(self)
    UIViewController *controller = [[XCMediator sharedInstance] TTMessageMoudle_TTMessageContentViewControllerWithSelectSendPresentHandle:^(NSDictionary * _Nonnull user) {
        @strongify(self)
        UserInfo *info = [[UserInfo alloc] init];
        info.nick = user[@"nickname"];
        info.uid = [user[@"uid"] longLongValue];
        !self.presentUserInfoBlock?:self.presentUserInfoBlock(info);
    }];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
}




- (void)onClickrightBtn {
    @weakify(self)
   UIViewController *searchVC = [[XCMediator sharedInstance] ttHomeMoudleBridge_searchRoomController:YES block:^(long long uid,NSString *name){
       @strongify(self)
       UserInfo *info = [[UserInfo alloc] init];
       info.nick = name;
       info.uid = uid;
       !self.presentUserInfoBlock?:self.presentUserInfoBlock(info);
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"person_dressup_search"] forState:UIControlStateNormal];
//        _rightBtn.frame =
        [_rightBtn addTarget:self action:@selector(onClickrightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
