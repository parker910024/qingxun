//
//  TTEditDescibeViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEditDescibeViewController.h"
//view
#import <SZTextView/SZTextView.h>
//core
#import "UserCore.h"
//cate
#import "XCHUDTool.h"
#import "NSString+SpecialClean.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"


@interface TTEditDescibeViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView  *containView;//
@property (nonatomic, strong) SZTextView  *useDescTextView;//
@property (nonatomic, strong) UIButton  *clearBtn;//
@property (nonatomic, strong) UIButton  *completionBtn;//
@property (nonatomic, strong) UILabel  *limitLabel;//


@end

static NSInteger maxCount = 60;

@implementation TTEditDescibeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改个人介绍";
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithCustomView:self.completionBtn];
    self.navigationItem.rightBarButtonItem = completeItem;
    [self.view addSubview:self.containView];
    [self.containView addSubview:self.useDescTextView];
    [self.containView addSubview:self.clearBtn];
    [self.view addSubview:self.limitLabel];
    [self makeConstriants];
    self.useDescTextView.text = self.info.userDesc;
    self.limitLabel.text = [NSString stringWithFormat:@"%ld",(maxCount - self.info.userDesc.length)];
}

- (void)makeConstriants {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(20);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(137);
    }];
    [self.useDescTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containView).offset(10);
        make.bottom.mas_equalTo(self.containView).offset(-10);
        make.right.mas_equalTo(self.clearBtn.mas_left).offset(-5);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containView).offset(10);
        make.right.mas_equalTo(self.containView).offset(-10);
    }];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.containView);
    }];
}

#pragma mark - private

- (void)updateUserInfo:(NSString *)key value:(NSString *)value;
{
    [XCHUDTool showGIFLoadingInView:self.view];
    NSMutableDictionary *userinfos = [NSMutableDictionary dictionary];
    [userinfos setObject:value forKey:key];
    @weakify(self)
    [[GetCore(UserCore) saveUserInfoWithUserID:self.info.uid userInfos:userinfos] subscribeNext:^(id x) {
        @strongify(self)
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showSuccessWithMessage:@"修改成功" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTuTuRefreshUserInfoNoti" object:nil userInfo:@{@"userInfo" : x}];
        
    } error:^(NSError *error) {
        @strongify(self)
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
    }];
}


#pragma mark -UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > maxCount) {
        [XCHUDTool showErrorWithMessage:@"最多只能输入 60 个字符哦" inView:self.view];
        self.limitLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        textView.text = [textView.text substringToIndex:maxCount];
    }else {
        self.completionBtn.enabled = YES;
        self.limitLabel.textColor = [XCTheme getTTMainTextColor];
    }
    self.limitLabel.text = [NSString stringWithFormat:@"%ld",(maxCount - textView.text.length)];
}

#pragma mark - Event

- (void)onClickBtnAction:(UIButton *)btn {
    self.useDescTextView.text = @"";
}

- (void)onClickCompleteBtn:(UIButton *)btn {
    [self updateUserInfo:@"userDesc" value:[self.useDescTextView.text cleanSpecialText]];
}

#pragma mark - getter && setter

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.layer.cornerRadius = 5;
        _containView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _containView;
}

- (SZTextView *)useDescTextView {
    if (!_useDescTextView) {
        _useDescTextView = [[SZTextView alloc] init];
        _useDescTextView.delegate = self;
        _useDescTextView.placeholder = @"填写自我介绍，可以让别人更了解你哦～";
        _useDescTextView.font = [UIFont systemFontOfSize:14];
        _useDescTextView.textColor = [XCTheme getTTMainTextColor];
        _useDescTextView.backgroundColor = [XCTheme getTTSimpleGrayColor];

    }
    return _useDescTextView;
}

- (UIButton *)completionBtn {
    if (!_completionBtn) {
        _completionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completionBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [_completionBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_completionBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateDisabled];
        [_completionBtn addTarget:self action:@selector(onClickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completionBtn;
}

- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.font = [UIFont systemFontOfSize:14];
        _limitLabel.textColor = [XCTheme getTTMainTextColor];
        _limitLabel.text = @"60";
    }
    return _limitLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setImage:[UIImage imageNamed:@"person_edit_clear"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

@end
