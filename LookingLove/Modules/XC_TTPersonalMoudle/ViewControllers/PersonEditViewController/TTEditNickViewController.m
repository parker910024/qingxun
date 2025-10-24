//
//  TTEditNickViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTEditNickViewController.h"
//core
#import "UserCore.h"
//cate
#import "XCHUDTool.h"
#import "NSString+SpecialClean.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"



@interface TTEditNickViewController ()
@property (nonatomic, strong) UIView  *containView;//
@property (nonatomic, strong) UITextField  *nickTextField;//
@property (nonatomic, strong) UIButton  *completionBtn;//
@property (nonatomic, strong) UILabel  *limitLabel;//
@end

static NSInteger maxCount = 15;

@implementation TTEditNickViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithCustomView:self.completionBtn];
    self.navigationItem.rightBarButtonItem = completeItem;
    [self.view addSubview:self.containView];
    [self.containView addSubview:self.nickTextField];
    [self.view addSubview:self.limitLabel];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(20);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(35);
    }];
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containView);
        make.left.mas_equalTo(self.containView).offset(5);
        make.right.mas_equalTo(self.containView);
        make.height.mas_equalTo(35);
    }];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickTextField.mas_bottom).offset(8);
        make.right.mas_equalTo(self.nickTextField);
    }];
    self.nickTextField.text = self.info.nick;
    self.limitLabel.text = [NSString stringWithFormat:@"%ld", (long)(maxCount - self.info.nick.length)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nickTextField];
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
        [XCHUDTool showSuccessWithMessage:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        @strongify(self)
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
    }];
}

#pragma mark - Event


-(void)textFieldEditChanged:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    self.completionBtn.enabled = YES;

    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            
            if (toBeString.length > 15){
                [XCHUDTool showErrorWithMessage:@"输入字数已达上限" inView:self.view];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
                if (rangeIndex.length == 1){
                    
                    textField.text = [toBeString substringToIndex:15];
                }else{
                    
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 15){
            [XCHUDTool showErrorWithMessage:@"输入字数已达上限" inView:self.view];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
            if (rangeIndex.length == 1){
                
                textField.text = [toBeString substringToIndex:15];
            }else{
                
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


- (void)nickChange:(UITextField *)textField {

    NSString *dateString = [textField.text cleanSpecialText];
    if (dateString.length <=15 && dateString.length >0 ) {
        self.limitLabel.text = [NSString stringWithFormat:@"%ld", (long)(maxCount - textField.text.length)];
        self.completionBtn.enabled = YES;
    }else {
        self.completionBtn.enabled = NO;
        self.limitLabel.text = @"0";
    }
}

- (void)onClickCompleteBtn:(UIButton *)btn {

    NSString *text = [self.nickTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"昵称不能为空" inView:self.view];
        return;
    }
    
    [self updateUserInfo:@"nick" value:[text cleanSpecialText]];
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

- (UITextField *)nickTextField {
    if (!_nickTextField) {
        _nickTextField = [[UITextField alloc] init];
        _nickTextField.clearButtonMode = UITextFieldViewModeAlways;
        _nickTextField.font = [UIFont systemFontOfSize:14];
        _nickTextField.textColor = [XCTheme getTTMainTextColor];
        _nickTextField.layer.cornerRadius = 5;
        [_nickTextField addTarget:self action:@selector(nickChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nickTextField;
}

- (UIButton *)completionBtn {
    if (!_completionBtn) {
        _completionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completionBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [_completionBtn setTitle:@"完成" forState:UIControlStateNormal];
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
        _limitLabel.text = @"0/15";
    }
    return _limitLabel;
}

@end
