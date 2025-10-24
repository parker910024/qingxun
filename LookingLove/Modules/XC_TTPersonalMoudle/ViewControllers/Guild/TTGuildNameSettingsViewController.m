//
//  TTGuildNameSettingsViewController.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/7.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildNameSettingsViewController.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "NSString+SpecialClean.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

static NSUInteger const kHallNameLengthLimit = 15;//厅名长度限制

@interface TTGuildNameSettingsViewController ()<UITextFieldDelegate, GuildCoreClient>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *descButton;
@end

@implementation TTGuildNameSettingsViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置厅名";

    AddCoreClient(GuildCoreClient, self);

    self.nameTextField.text = self.hallName;
    
    [self initViews];
    [self initConstraints];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text && text.length<=kHallNameLengthLimit) {
        return YES;
    }
    
    text = [text substringToIndex:kHallNameLengthLimit];
    self.nameTextField.text = text;
    
    return NO;
}

#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark GuildCoreClient
/**
 更新群聊资料
 
 @param isSuccess 是否成功，出现错误时通过 code 和 msg 返回
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildHallNameUpdate:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [UIView hideToastView];
    
    if (isSuccess) {
        [UIView showToastInKeyWindow:@"设置成功" duration:1.6 position:YYToastPositionCenter];
        if (self.editCompletion) {
            self.editCompletion(self.nameTextField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    [UIView showToastInKeyWindow:msg ?: @"设置失败" duration:1.6 position:YYToastPositionCenter];
}

#pragma mark - Event Responses
- (void)sureButtonDidTapped {
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }

    NSString *text = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length == 0) {
        self.nameTextField.text = nil;
        [UIView showToastInKeyWindow:@"输入不能为空" duration:2 position:YYToastPositionCenter];
        return;
    }
    
    [UIView showLoadingToastDuration:10];
    [GetCore(GuildCore) requestGuildUpdateHallName:text];
}

#pragma mark - Private Methods
- (void)initViews {
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.frame = CGRectMake(0, 0, 40, 44);
    [sureButton addTarget:self action:@selector(sureButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:sureButton];
    
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.descButton];
}

- (void)initConstraints {
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.mas_equalTo(self.view.mas_top).offset(kNavigationHeight + 10);
        }
        
        make.left.right.mas_equalTo(self.view).inset(15);
        make.height.mas_equalTo(35);
    }];
    
    [self.descButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTextField);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(10);
    }];
}

#pragma mark - Getters and Setters
- (UITextField *)nameTextField {
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.delegate = self;
        _nameTextField.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _nameTextField.layer.cornerRadius = 5;
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.placeholder = @"设置厅名";
        _nameTextField.textColor = [XCTheme getTTMainTextColor];
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameTextField;
}

- (UIButton *)descButton {
    if (_descButton == nil) {
        _descButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"请输入%ld个字内中文/字母", kHallNameLengthLimit];
        [_descButton setTitle:title forState:UIControlStateNormal];
        [_descButton setImage:[UIImage imageNamed:@"guild_settings_warning"] forState:UIControlStateNormal];
        [_descButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        _descButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _descButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        _descButton.userInteractionEnabled = NO;
    }
    return _descButton;
}

@end
