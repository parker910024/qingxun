//
//  TTParentSetPawViewController.m
//  AFNetworking
//
//  Created by User on 2019/5/5.
//

#import "TTParentSetPawViewController.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "UIView+NTES.h"

#import "TTParentPasswordInputView.h"
#import "TTParentAgainPawViewController.h"
#import "CPGameCore.h"
#import "AuthCore.h"
#import "XCHUDTool.h"

#import "CPGameCoreClient.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

@interface TTParentSetPawViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *subTextLabel;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSString *passwordString;

@property (nonatomic, strong) NSString *passAgainString;

@property (nonatomic, strong) UIButton *completeButton;

@property (nonatomic, strong) TTParentPasswordInputView *codeView;

@property (nonatomic, strong) TTParentPasswordInputView *againCodeView;
@end

@implementation TTParentSetPawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    [self initConstraint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initView {
    if (self.openOrClose) {
        [self.view addSubview:self.titleLabel];
        
        self.codeView = [[TTParentPasswordInputView alloc]initWithFrame:CGRectMake(25, kNavigationHeight + 176, 269, 50) withNum:4];
        
        @weakify(self);
        self.codeView.returnBlock = ^(NSString *pwStr) {
            @strongify(self);
            if (pwStr.length == 4) {
                [[GetCore(CPGameCore) requestOpenOrCloseParentModelWithUid:GetCore(AuthCore).getUid.userIDValue password:pwStr status:0] subscribeError:^(NSError *error) {
                    
                    [self.codeView clearPassword];
                    
                } completed:^{
                    NotifyCoreClient(CPGameCoreClient, @selector(closeParentModelSuccess), closeParentModelSuccess);
                    [XCHUDTool showSuccessWithMessage:@"关闭青少年模式成功" inView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                
            }
        };
        [self.view addSubview:self.codeView];
    } else {
        
        [self.view addSubview:self.titleLabel];
    
        self.codeView = [[TTParentPasswordInputView alloc]initWithFrame:CGRectMake(25, kNavigationHeight + 176, 269, 50) withNum:4];

        @weakify(self);
        self.codeView.returnBlock = ^(NSString *pwStr) {
            @strongify(self);
            if (pwStr.length == 4) {
                self.passwordString = pwStr;
                self.nextButton.userInteractionEnabled = YES;
                self.nextButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
                [self.nextButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
            } else {
                self.nextButton.userInteractionEnabled = NO;
                self.nextButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
                [self.nextButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
            }
        };
        
        [self.view addSubview:self.codeView];
        
        [self.view addSubview:self.subTitleLabel];
        
        [self.view addSubview:self.subTextLabel];
        
        [self.view addSubview:self.nextButton];
        
        [self.view addSubview:self.completeButton];
    }
}

- (void)initConstraint {
    if (self.openOrClose) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavigationHeight + 20);
            make.centerX.mas_equalTo(self.view);
        }];
        
        // 单独显示需要居中
        self.codeView.centerX = self.view.centerX + 10;
        
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavigationHeight + 57);
            make.left.mas_equalTo(25);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(self.titleLabel);
        }];
        
        [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(self.titleLabel);
            make.right.mas_lessThanOrEqualTo(self.view).inset(25);
        }];
        
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(102);
            make.left.right.mas_equalTo(self.view).inset(25);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(46);
        }];
        
        [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(102);
            make.left.right.mas_equalTo(self.view).inset(25);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(46);
        }];
    }
}

- (void)nextButtonAction:(UIButton *)sender {
    _titleLabel.text = @"请再次输入密码";
    _subTitleLabel.hidden = YES;
    self.codeView.hidden = YES;
    _nextButton.hidden = YES;
    
    _completeButton.hidden = NO;
    _subTextLabel.hidden = NO;
  
    self.againCodeView = [[TTParentPasswordInputView alloc]initWithFrame:CGRectMake(25, kNavigationHeight + 176, 269, 50) withNum:4];

    @weakify(self);
    self.againCodeView.returnBlock = ^(NSString *pwStr) {
        @strongify(self);
        self.passAgainString = pwStr;
        if (pwStr.length == 4) {
            self.completeButton.userInteractionEnabled = YES;
            self.completeButton.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
            [self.completeButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        } else {
            self.completeButton.userInteractionEnabled = NO;
            self.completeButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
            [self.completeButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        }
    };
    [self.view addSubview:self.againCodeView];
}

- (void)completeButtonAction:(UIButton *)sender {
    if (![self.passwordString isEqualToString:self.passAgainString]) {
        [XCHUDTool showErrorWithMessage:@"两次输入密码不一致" inView:self.view];
    } else {
        
        [[GetCore(CPGameCore)  requestOpenOrCloseParentModelWithUid:GetCore(AuthCore).getUid.userIDValue password:self.passwordString status:1] subscribeError:^(NSError *error) {
            
        } completed:^{
            NotifyCoreClient(CPGameCoreClient, @selector(openParentModelSuccess), openParentModelSuccess);
            [XCHUDTool showSuccessWithMessage:@"开启青少年模式成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        if (self.openOrClose) {
            _titleLabel.text = @"关闭青少年模式的密码";
        } else {
            _titleLabel.text = @"设置密码";
        }
        _titleLabel.font = [UIFont boldSystemFontOfSize:23];
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"设置青少年模式的开启和关闭的数字密码";
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = XCTheme.getTTSubTextColor;
    }
    return _subTitleLabel;
}

- (UILabel *)subTextLabel {
    if (!_subTextLabel) {
        _subTextLabel = [[UILabel alloc] init];
        _subTextLabel.text = @"我们将不提供找回密码服务请您牢记已设置的密码";
        _subTextLabel.font = [UIFont systemFontOfSize:13];
        _subTextLabel.textColor = XCTheme.getTTSubTextColor;
        _subTextLabel.textAlignment = NSTextAlignmentCenter;
        _subTextLabel.numberOfLines = 0;
        _subTextLabel.hidden = YES;
    }
    return _subTextLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextButton.layer.cornerRadius = 23;
        _nextButton.layer.borderWidth = 2;
        _nextButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _nextButton.userInteractionEnabled = NO;
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _completeButton.layer.cornerRadius = 23;
        _completeButton.userInteractionEnabled = NO;
        _completeButton.layer.borderColor = UIColorFromRGB(0xB3B3B3).CGColor;
        _completeButton.layer.borderWidth = 2.f;
        [_completeButton addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.hidden = YES;
    }
    return _completeButton;
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
