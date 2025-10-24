//
//  TTAboutTuTuViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTAboutTuTuViewController.h"

//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "YYUtility.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
#import "XCKeyWordTool.h"
#import "HostUrlManager.h"

@interface TTAboutTuTuViewController ()
@property (nonatomic, strong) UIImageView  *iconImageView;//图标
@property (strong, nonatomic) UILabel *versionLabel;//版本
@property (nonatomic, strong) UILabel  *tipLabel;//
@property (strong , nonatomic) UILabel *nameLabel;
@property (strong , nonatomic) UILabel *companyLabel;
@end

@implementation TTAboutTuTuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"关于%@",[XCKeyWordTool sharedInstance].myAppName];
    [self initSubViews];
}

- (void)initSubViews {
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.companyLabel];
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottomHeight-20);
    }];
}


#pragma mark - Getter && Setter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"puding_logo"];
    }
    return _iconImageView;
}


- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = [UIFont systemFontOfSize:12];
        _versionLabel.textColor = UIColorFromRGB(0x999999);
        _versionLabel.text = [NSString stringWithFormat:@"V%@",[YYUtility appVersion]];
        
        if ([HostUrlManager shareInstance].currentEnvironment == TestType) {
            _versionLabel.text = [NSString stringWithFormat:@"V%@ b%@", [YYUtility appVersion], [YYUtility appBuild]];
        }
    }
    return _versionLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [XCKeyWordTool sharedInstance].myAppName;
        _nameLabel.textColor = [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nameLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"与喜欢的声音不期而遇";
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _tipLabel;
}


- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
//        _companyLabel.text = @"©️广州来汇科技有限公司";
        _companyLabel.font = [UIFont systemFontOfSize:12];
        _companyLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _companyLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
