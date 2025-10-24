//
//  TTParentModelViewController.m
//  XC_TTPersonalMoudle
//
//  Created by User on 2019/5/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTParentModelViewController.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import <YYLabel.h>
#import <YYText/YYText.h>
#import "TTParentSetPawViewController.h"
#import "UserInfo.h"
#import "XCHtmlUrl.h"
#import "AuthCore.h"
#import "UserCore.h"

#import "TTWKWebViewViewController.h"
@interface TTParentModelViewController ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *thirdLeftView;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UIView *fourthLeftView;
@property (nonatomic, strong) UILabel *fourthLabel;

@property (nonatomic, strong) YYLabel *watchButton;
@property (nonatomic, strong) UIButton *openParentBtn;

@property (nonatomic, strong) NSString *passwordString;
@property (nonatomic, strong) UserInfo *userInfo;
@end

@implementation TTParentModelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[GetCore(UserCore) getUserInfoByRac:GetCore(AuthCore).getUid.userIDValue refresh:YES] subscribeNext:^(id x) {
        self.userInfo = (UserInfo *)x;
        
        [self initView];
        
        [self initConstraint];
        
    } error:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"青少年模式";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
}

- (void)initView {
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.topLeftView];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.bottomLeftView];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.thirdLabel];
    [self.view addSubview:self.thirdLeftView];
    [self.view addSubview:self.fourthLeftView];
    [self.view addSubview:self.fourthLabel];
    [self.view addSubview:self.watchButton];
    [self.view addSubview:self.openParentBtn];
}

- (void)initConstraint {
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 54);
        make.left.mas_equalTo(60);
        make.size.mas_equalTo(CGSizeMake(57, 52));
    }];
    
//    if (self.userInfo.parentMode) {
//        self.topImageView.image = [UIImage imageNamed:@"meInfo_parents_mode_On"];
//    } else {
//        self.topImageView.image = [UIImage imageNamed:@"meInfo_parents_mode_Off"];
//    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView.mas_right).offset(25);
        make.centerY.mas_equalTo(self.topImageView);
    }];
    
    [self.topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView);
        make.top.mas_equalTo(self.topImageView.mas_bottom).mas_equalTo(52);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topLeftView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.topLeftView);
    }];
    
    [self.bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView);
        make.top.mas_equalTo(self.topLeftView.mas_bottom).offset(27);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLeftView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.bottomLeftView);
    }];
    
    [self.thirdLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView);
        make.top.mas_equalTo(self.bottomLeftView.mas_bottom).offset(27);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thirdLeftView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.thirdLeftView);
    }];
    
    [self.fourthLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView);
        make.top.mas_equalTo(self.thirdLeftView.mas_bottom).offset(27);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fourthLeftView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.fourthLeftView);
    }];
    
    [self.watchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60 - kSafeAreaBottomHeight);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 12));
    }];
    
    [self.openParentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.watchButton.mas_top).offset(-22);
        make.left.right.mas_equalTo(self.view).inset(38);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(self.view);
    }];
    
    if (self.userInfo.parentMode) {
        [self.openParentBtn setTitle:@"关闭青少年模式" forState:UIControlStateNormal];
        self.openParentBtn.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;

    } else {
        [self.openParentBtn setTitle:@"开启青少年模式" forState:UIControlStateNormal];
    }
    
    
}

- (void)openParentAction:(UIButton *)sender {
    if (self.userInfo.parentMode) {
        TTParentSetPawViewController *setpawVC = [[TTParentSetPawViewController alloc] init];
        setpawVC.openOrClose = YES;
        [self.navigationController pushViewController:setpawVC animated:YES];
    } else {
        TTParentSetPawViewController *setpawVC = [[TTParentSetPawViewController alloc] init];
        setpawVC.openOrClose = NO;
        [self.navigationController pushViewController:setpawVC animated:YES];
    }
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"meInfo_parents_mode_icon"];
        if (projectType() == ProjectType_TuTu ||
            projectType() == ProjectType_Pudding) {
            _topImageView.image = [UIImage imageNamed:@"meInfo_parents_mode_On"];
        }
    }
    return _topImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"开启青少年模式\n将会获得以下服务";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
    }
    return _titleLabel;
}

- (UIView *)topLeftView {
    if (!_topLeftView) {
        _topLeftView = [[UIView alloc] init];
        
        _topLeftView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"meInfo_parents_mode_tipsIcon"].CGImage);
        
    }
    return _topLeftView;
}

- (UIView *)thirdLeftView {
    if (!_thirdLeftView) {
        _thirdLeftView = [[UIView alloc] init];
        
        _thirdLeftView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"meInfo_parents_mode_tipsIcon"].CGImage);
        
    }
    return _thirdLeftView;
}

- (UIView *)fourthLeftView {
    if (!_fourthLeftView) {
        _fourthLeftView = [[UIView alloc] init];
        
        _fourthLeftView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"meInfo_parents_mode_tipsIcon"].CGImage);
        
    }
    return _fourthLeftView;
}

- (UILabel *)thirdLabel {
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.font = [UIFont systemFontOfSize:14];
        _thirdLabel.textColor = XCTheme.getTTSubTextColor;
        _thirdLabel.text = @"限制使用金币充值功能";
    }
    return _thirdLabel;
}

- (UILabel *)fourthLabel {
    if (!_fourthLabel) {
        _fourthLabel = [[UILabel alloc] init];
        _fourthLabel.font = [UIFont systemFontOfSize:14];
        _fourthLabel.textColor = XCTheme.getTTSubTextColor;
        _fourthLabel.text = @"每天限玩保护";
    }
    return _fourthLabel;
}


- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:14];
        _topLabel.textColor = XCTheme.getTTSubTextColor;
        _topLabel.text = @"针对青少年推送精选优化的内容";
    }
    return _topLabel;
}

- (UIView *)bottomLeftView {
    if (!_bottomLeftView) {
        _bottomLeftView = [[UIView alloc] init];

        _bottomLeftView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"meInfo_parents_mode_tipsIcon"].CGImage);
    }
    return _bottomLeftView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.textColor = XCTheme.getTTSubTextColor;
        _bottomLabel.text = @"其它用户将无法通过搜索找到该账号";
    }
    return _bottomLabel;
}


- (UIButton *)openParentBtn {
    if (!_openParentBtn) {
        _openParentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openParentBtn setTitle:@"开启青少年模式" forState:UIControlStateNormal];
        [_openParentBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _openParentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _openParentBtn.layer.cornerRadius = 23;
        _openParentBtn.backgroundColor = UIColorFromRGB(0xFFB606);
        
        [_openParentBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _openParentBtn.backgroundColor = UIColor.whiteColor;
        _openParentBtn.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        _openParentBtn.layer.borderWidth = 2;
        
        [_openParentBtn addTarget:self action:@selector(openParentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openParentBtn;
}

- (YYLabel *)watchButton {
    if (!_watchButton) {
        _watchButton = [[YYLabel alloc] init];
        _watchButton.font = [UIFont systemFontOfSize:12];
        NSString * name = [NSString stringWithFormat:@"《%@护苗计划》",MyAppName];
        NSString *str = [NSString stringWithFormat:@"%@%@", @"查看", name];
        NSRange range1 = [str rangeOfString:@"查看"];
        NSRange range = [str rangeOfString:name];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFE4C62) range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:XCTheme.getTTDeepGrayTextColor range:range1];
        _watchButton.attributedText = attStr;
        _watchButton.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_watchButton addGestureRecognizer:tap];
    }
    return _watchButton;
}

- (void)tapAction {
    [self goToWebview:HtmlUrlKey(kNurseryURL)];
}

- (void)goToWebview:(NSString *)url {
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    webView.urlString = url;
    webView.uid = GetCore(AuthCore).getUid.longLongValue;
    [self.navigationController pushViewController:webView animated:YES];
}

@end
