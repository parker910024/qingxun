//
//  TTExperimentViewController.m
//  TuTu
//
//  Created by zoey on 2018/11/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTExperimentViewController.h"

#import "HttpRequestHelper.h"
#import "ImLoginCore.h"

#import "HostUrlManager.h"
#import "XCHUDTool.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTExperimentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong , nonatomic) UILabel *currentLabel;
@property (strong , nonatomic) UIButton *testBtn;
@property (strong , nonatomic) UIButton *realesBtn;
@property (strong , nonatomic) UIButton *pre_realesBtn;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TTExperimentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"环境切换";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.testBtn];
    [self.view addSubview:self.realesBtn];
    [self.view addSubview:self.pre_realesBtn];
    [self.view addSubview:self.currentLabel];
    [self.view addSubview:self.tableView];
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(60);
    }];
    [self.pre_realesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.testBtn.mas_bottom).offset(20);
    }];
    [self.realesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pre_realesBtn.mas_bottom).offset(20);
    }];
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(kSafeAreaBottomHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(176);
    }];
    
    [self initAppInfo];
}

- (EnvironmentType)judgeTheEnv {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:kAppNetWorkEnv] == ReleaseType) {
        return ReleaseType;
    } else if ([userDefault integerForKey:kAppNetWorkEnv] == Pre_ReleaseType) {
        return Pre_ReleaseType;
    } else {
        return TestType;
    }
}

- (void)initAppInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *plistPath = [[NSBundle bundleWithPath:path] pathForResource:@"Root" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [dict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *valuesArr = (NSArray *)obj;
            self.dataArray = obj;
            [self.tableView reloadData];
            * stop = YES;
        }
    }];
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"Title"];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    }
    if (dict[@"DefaultValue"]) {
        cell.detailTextLabel.text = dict[@"DefaultValue"];
    }
    
    return cell;
}


- (void)showChangeEnvAlert:(EnvironmentType)environmentType {
    
    if ([self judgeTheEnv] == ReleaseType) {
        if (environmentType == ReleaseType){
            [XCHUDTool showErrorWithMessage:@"你已经在正式环境" inView:self.view];
            return;
        }
    } else if ([self judgeTheEnv] == Pre_ReleaseType) {
        if (environmentType == Pre_ReleaseType){
            [XCHUDTool showErrorWithMessage:@"你已经在预发布环境" inView:self.view];
            return;
        }
    } else {
        if (environmentType == TestType){
            [XCHUDTool showErrorWithMessage:@"你已经在测试环境" inView:self.view];
            return;
        }
    }
    
    NSString *message = @"";
    if (environmentType == ReleaseType) {
        message = @"你将切换到正式环境";
    } else if (environmentType == Pre_ReleaseType) {
        message = @"你将切换到预发布环境";
    } else {
        message = @"你将切换到测试环境";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"是否继续，继续将会重新拉起登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (environmentType == ReleaseType) {
            [HostUrlManager shareInstance].Env = ReleaseType;
        } else if (environmentType == Pre_ReleaseType) {
            [HostUrlManager shareInstance].Env = Pre_ReleaseType;
        } else {
            [HostUrlManager shareInstance].Env = TestType;
        }
        [self.navigationController popViewControllerAnimated:NO];
        [HttpRequestHelper resetClient];
        RemoveCore(ImLoginCore);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:enter];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onClickRealseBtn {
    [self showChangeEnvAlert:ReleaseType];
}

- (void)onClickTestBtn {
    [self showChangeEnvAlert:TestType];
}

- (void)onClickPreRealseBtn {
    [self showChangeEnvAlert:Pre_ReleaseType];
}


- (UIButton *)testBtn {
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_testBtn setTitle:@"切换到 - 测试环境" forState:UIControlStateNormal];
        [_testBtn addTarget:self action:@selector(onClickTestBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBtn;
}

- (UIButton *)realesBtn {
    if (!_realesBtn) {
        _realesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_realesBtn setTitle:@"切换到 - 正式环境" forState:UIControlStateNormal];
        [_realesBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_realesBtn addTarget:self action:@selector(onClickRealseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _realesBtn;
}

- (UIButton *)pre_realesBtn {
    if (!_pre_realesBtn) {
        _pre_realesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pre_realesBtn setTitle:@"切换到 - 预发布环境" forState:UIControlStateNormal];
        [_pre_realesBtn setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_pre_realesBtn addTarget:self action:@selector(onClickPreRealseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pre_realesBtn;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.textColor = [XCTheme getTTMainColor];
        if ([self judgeTheEnv] == ReleaseType) {
            _currentLabel.text = @"现在环境：正式环境";
        } else if ([self judgeTheEnv] == Pre_ReleaseType) {
            _currentLabel.text = @"现在环境：预发布环境";
        } else {
            _currentLabel.text = @"现在环境：测试环境";
        }
    }
    return _currentLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

@end
