//
//  TTGuildGroupNoticeEditViewController.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/11.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupNoticeEditViewController.h"

#import "XCTheme.h"
#import "XCHUDTool.h"

#import "GuildCore.h"
#import "GuildCoreClient.h"

#import <Masonry/Masonry.h>

@interface TTGuildGroupNoticeEditViewController ()<UITextViewDelegate, GuildCoreClient>

@property (nonatomic, strong) UIView *bgView;//灰色背景
@property (nonatomic, strong) UITextView *textView;//文本输入
@property (nonatomic, strong) UIButton *clearButton;//清除按钮
@property (nonatomic, strong) UILabel *tipsLabel;//150字内
@property (nonatomic, strong) UILabel *placeholderLabel;//无公告时提示，请输入公告内容

@end

@implementation TTGuildGroupNoticeEditViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群公告";
    
    AddCoreClient(GuildCoreClient, self);

    self.textView.text = self.groupInfo.notice;
    self.placeholderLabel.hidden = self.groupInfo.notice.length > 0;
    
    [self initViews];
    [self initConstraints];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Public Methods
#pragma mark - System Protocols
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.placeholderLabel.hidden = string.length > 0;
    
    if (string.length<=150) {
        return YES;
    }
    
    NSString *clipString = [string substringToIndex:150];
    textView.text = clipString;
    
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
- (void)responseGuildGroupInfoUpdate:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    [XCHUDTool hideHUDInView:self.view];
    
    if (isSuccess) {
        if (self.editCompletion) {
            self.editCompletion(self.textView.text);
        }
        
        [XCHUDTool showSuccessWithMessage:@"设置成功" inView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    
    [XCHUDTool showErrorWithMessage:msg ?: @"设置失败" inView:self.view];
}

#pragma mark - Event Responses
- (void)sureButtonDidTapped {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    [XCHUDTool showGIFLoadingInView:self.view];
    [GetCore(GuildCore) requestGuildGroupInfoUpdateWithChatId:self.groupInfo.chatId icon:nil name:nil notice:self.textView.text];
}

- (void)clearButtonDidTapped {
    self.textView.text = @"";
    self.placeholderLabel.hidden = NO;
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
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.clearButton];
    [self.bgView addSubview:self.placeholderLabel];
    
    [self.view addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.left.right.mas_equalTo(self.view.mas_safeAreaLayoutGuide).inset(15);
        } else {
            make.top.left.right.mas_equalTo(self.view);
        }
        make.height.mas_equalTo(135);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
        make.left.mas_equalTo(self.textView.mas_right);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(4);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.bgView);
    }];
}

#pragma mark - Getters and Setters
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [XCTheme getTTMainTextColor];
        _textView.backgroundColor = UIColor.clearColor;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _placeholderLabel.text = @"请输入公告内容";
    }
    return _placeholderLabel;
}

- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        _tipsLabel.text = @"150字内";
    }
    return _tipsLabel;
}

- (UIButton *)clearButton {
    if (_clearButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"guild_settings_clear"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
        _clearButton = button;
    }
    return _clearButton;
}

@end
