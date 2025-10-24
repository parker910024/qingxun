//
//  TTParentAgainPawViewController.m
//  AFNetworking
//
//  Created by User on 2019/5/5.
//

#import "TTParentAgainPawViewController.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "XCHUDTool.h"

#import "TTParentPasswordInputView.h"
#import "CPGameCore.h"
#import "AuthCore.h"

@interface TTParentAgainPawViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSString *passwordString;

@end

@implementation TTParentAgainPawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"家长模式";
    
    [self initView];
    
    [self initConstraint];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initView {
    [self.view addSubview:self.titleLabel];
    
    TTParentPasswordInputView *codeView = [[TTParentPasswordInputView alloc]initWithFrame:CGRectMake((KScreenWidth - 196) / 2, kNavigationHeight + 157 - 34, 196, 34) withNum:4];
    
    codeView.returnBlock = ^(NSString *pwStr) {
        if (pwStr.length == 4) {
            self.passwordString = pwStr;
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = UIColorFromRGB(0xFFB606);
        } else {
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
        }
    };
    
    [self.view addSubview:codeView];
    
    [self.view addSubview:self.subTitleLabel];
    
    [self.view addSubview:self.nextButton];
}

- (void)nextButtonAction:(UIButton *)sender {
    
    if (![self.passwordStr isEqualToString:self.passwordString]) {
        [XCHUDTool showErrorWithMessage:@"两次输入密码不一致" inView:self.view];
    } else {
        [GetCore(CPGameCore) requestOpenOrCloseParentModelWithUid:GetCore(AuthCore).getUid.userIDValue password:self.passwordString status:1];
    }
}

- (void)initConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight + 57);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(102);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(65);
        make.size.mas_equalTo(CGSizeMake(230, 44));
        make.centerX.mas_equalTo(self.view);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请再次输入密码";
        _titleLabel.font = [UIFont systemFontOfSize:23];
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"我们将不提供找回密码服务\n请您牢记已设置的密码";
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = XCTheme.getTTSubTextColor;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = UIColorFromRGB(0xD0D0D0);
        [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
        [_nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _nextButton.layer.cornerRadius = 22;
        _nextButton.userInteractionEnabled = NO;
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
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
