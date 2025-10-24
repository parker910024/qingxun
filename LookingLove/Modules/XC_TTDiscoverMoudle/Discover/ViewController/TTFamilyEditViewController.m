//
//  TTFamilyEditViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyEditViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "XCMacros.h"
#import "NSString+SpecialClean.h"

@interface TTFamilyEditViewController ()
@property (nonatomic, strong) UITextField * textFiled;
@property (nonatomic, strong) NSString * text;
@end

@implementation TTFamilyEditViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initContrations];
}
#pragma mark - resonse
- (void)rightNavButtonAction:(UIButton *)sender{
    if (self.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledChangeEngEdit:)]) {
            [self.delegate textFiledChangeEngEdit:self.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [XCHUDTool showErrorWithMessage:@"请输入正确的内容" inView:self.view];
    }
}

- (void)textFileDidChange:(UITextField *)textFiled{
    NSString *toBeString = textFiled.text;
    NSString *lang = [textFiled.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textFiled markedTextRange];
        UITextPosition *position = [textFiled positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            
            if (toBeString.length > 15){
                [XCHUDTool showErrorWithMessage:@"输入字数已达上限" inView:self.view];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
                if (rangeIndex.length == 1){
                    textFiled.text = [toBeString substringToIndex:15];
                }else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                    textFiled.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 15){
            [XCHUDTool showErrorWithMessage:@"输入字数已达上限" inView:self.view];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
            if (rangeIndex.length == 1){
                textFiled.text = [toBeString substringToIndex:15];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                textFiled.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    self.text = textFiled.text;
}

#pragma mark - private method
- (void)initView{
    [self.view addSubview:self.textFiled];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addNavigationItemWithTitles:@[@"完成"] titleColor:UIColorFromRGB(0x666666) isLeft:NO target:self action:@selector(rightNavButtonAction:) tags:nil];
}

- (void)initContrations{
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(statusbarHeight + 44);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - setters and getters

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    if (_placeHolder) {
        self.textFiled.placeholder = _placeHolder;
    }
}

- (void)setDefaultText:(NSString *)defaultText{
    _defaultText = defaultText;
    if (_defaultText) {
        self.text =_defaultText;
        self.textFiled.text = _defaultText;
    }
}

- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.backgroundColor = [UIColor whiteColor];
        _textFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
        [_textFiled addTarget:self action:@selector(textFileDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFiled;
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
