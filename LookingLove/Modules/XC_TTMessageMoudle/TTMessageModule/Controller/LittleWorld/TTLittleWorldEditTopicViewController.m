//
//  TTEditTopicViewController.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldEditTopicViewController.h"
//view
#import "TTLittleWorldNavView.h"
//core
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
//第三方类
#import <Masonry/Masonry.h>
//XC类
#import "XCTheme.h"
#import "XCMacros.h"
#import "NSString+SpecialClean.h"
#import "XCHUDTool.h"
#import "NSArray+Safe.h"
//XC_tt
#import "TTPopup.h"

static int maxLength = 16;

@interface TTLittleWorldEditTopicViewController ()
<
  UITextFieldDelegate,
  TTLittleWorldNavViewDelegate,
  LittleWorldCoreClient
>

/** 随机*/
@property (nonatomic,strong) UIButton *randomButton;
/** 保存*/
@property (nonatomic,strong) UIButton *saveButton;
/** 容器*/
@property (nonatomic,strong) UIView *containerView;
/** 输入框*/
@property (nonatomic,strong) UITextField *textView;
/** 统计字数*/
@property (nonatomic,strong) UILabel *numberLablel;
/** 导航栏View*/
@property (nonatomic,strong) TTLittleWorldNavView *navView;
/** 话题内容*/
@property (nonatomic,strong) NSString *topicString;

/** 文案的数组*/
@property (nonatomic,strong) NSMutableArray<LittleWorldTeamModel *> *topicArray;


@end

@implementation TTLittleWorldEditTopicViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initConstrations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma mark - public methods
#pragma mark - delegate

#pragma mark - LittleWorldCoreClient
- (void)updateLittleWorldTeamNameOrTopicSuccess {
    [XCHUDTool hideHUDInView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateLittleWorldTeamNameOrTopicFail:(NSString *)message {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

- (void)requsetLittleWorldTeamRandomTopicSucess:(NSArray<LittleWorldTeamModel *> *)topics {
    [XCHUDTool hideHUDInView:self.view];
    [self.topicArray removeAllObjects];
    [self.topicArray addObjectsFromArray:topics];
    if (self.topicArray.count > 0) {
        NSString * topic = [self.topicArray firstObject].topic;
        if (!topic) {
            return;
        }
        if (topic.length > 16) {
            topic = [topic substringToIndex:16];
        }
        self.textView.text = topic;
        self.topicString = topic;
        self.numberLablel.text = [NSString stringWithFormat:@"%ld/16", (long)topic.length];
        [self.saveButton setBackgroundColor:[XCTheme getTTMainColor]];
        self.saveButton.userInteractionEnabled = YES;
    }
}

- (void)requestLittleWorldTeamPartyFail:(NSString *)message {
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - TTLittleWorldNavViewDelegate
- (void)goBackDidClick {
    if (!self.topicString && self.topicString.length <= 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [TTPopup alertWithMessage:@"聊天话题还未保存 \n 确定返回吗?" confirmHandler:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancelHandler:^{
            
        }];
    }
}

#pragma mark - event response
//输入框
- (void)textFileChange:(UITextField *)textFild {
    NSString *dateString = [textFild.text cleanSpecialText];
    if (dateString.length <= maxLength && dateString.length >0 ) {
        self.numberLablel.text = [NSString stringWithFormat:@"%ld/16", (long)( textFild.text.length)];
        self.topicString = textFild.text;
    }
    
    if (dateString.length > 0) {
        [self.saveButton setBackgroundColor:[XCTheme getTTMainColor]];
        self.saveButton.userInteractionEnabled = YES;
    }else {
        [self.saveButton setBackgroundColor:UIColorFromRGB(0xebebeb)];
        self.saveButton.userInteractionEnabled = NO;
    }
    
}


-(void)textFieldEditChanged:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]){// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position){
            
            if (toBeString.length > maxLength){
                [XCHUDTool showErrorWithMessage:@"字数太多啦~" inView:self.view];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
                if (rangeIndex.length == 1){
                    
                    textField.text = [toBeString substringToIndex:maxLength];
                }else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > maxLength){
            [XCHUDTool showErrorWithMessage:@"字数太多啦~" inView:self.view];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1){
                
                textField.text = [toBeString substringToIndex:maxLength];
            }else{
                
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}



//随机文案
- (void)randomButtonAction:(UIButton *)sender {
    [self getRandowTopic];
}

//保存
- (void)saveButtonAction:(UIButton *)sender {
    [XCHUDTool showLoadingInView:self.view enabled:NO];
    [GetCore(LittleWorldCore) updteLittleWorldTeamNameOrTopicWithTeamName:nil topic:self.topicString chatId:self.chatId];
}

- (void)tapContainerViewAction:(UITapGestureRecognizer *)tap {
    [self.textView becomeFirstResponder];
}

#pragma mark - private method

- (void)getRandowTopic {
    if (self.topicArray.count <= 0) {
        [XCHUDTool showLoadingInView:self.view];
        [GetCore(LittleWorldCore) requestLittleWorldTeamRandomTopic];
    }else {
        NSString * topic = [self.topicArray firstObject].topic;
        if (!topic) {
            return;
        }
        if (topic.length > 16) {
            topic = [topic substringToIndex:16];
        }
        self.topicString = topic;
        self.textView.text = topic;
        self.numberLablel.text = [NSString stringWithFormat:@"%ld/16", (long)topic.length];
        [self.topicArray removeObjectAtIndex:0];
    }
}

//初始化
- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}

- (void)initView {
    self.title = @"聊天话题";
    [self.view addSubview:self.navView];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:self.numberLablel];
    [self.view addSubview:self.randomButton];
    [self.view addSubview:self.saveButton];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerViewAction:)];
    [self.containerView addGestureRecognizer:tap];
    [self.textView addTarget:self action:@selector(textFileChange:) forControlEvents:UIControlEventEditingChanged];
    [self.randomButton addTarget:self action:@selector(randomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textView];
    
}
- (void)initConstrations {
    [self.navView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(statusbarHeight + 44);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.view).offset(kSafeAreaTopHeight + 64);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView).offset(12);
        make.top.mas_equalTo(self.containerView).offset(13);
        make.right.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.numberLablel.mas_top);
    }];
    
    [self.numberLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView).offset(-14);
        make.bottom.mas_equalTo(self.containerView).offset(-10);
    }];
    
    [self.randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 43));
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(46);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(43);
        make.right.mas_equalTo(self.view).offset(-20);
        make.left.mas_equalTo(self.randomButton.mas_right).offset(15);
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(46);
    }];
}
#pragma mark - getters and setters
- (void)setTeamTopicStr:(NSString *)teamTopicStr {
    _teamTopicStr = teamTopicStr;
    if (_teamTopicStr) {
        self.textView.placeholder = _teamTopicStr;
        [self.saveButton setBackgroundColor:[XCTheme getTTMainColor]];
        self.saveButton.userInteractionEnabled = YES;
    }
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存" forState:UIControlStateSelected];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
          [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.backgroundColor = UIColorFromRGB(0xebebeb);
        _saveButton.userInteractionEnabled = NO;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.layer.cornerRadius = 43/2;
    }
    return _saveButton;
}

- (UIButton *)randomButton {
    if (!_randomButton) {
        _randomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_randomButton setTitle:@"随机" forState:UIControlStateNormal];
        [_randomButton setTitle:@"随机" forState:UIControlStateSelected];
        _randomButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_randomButton setBackgroundColor:UIColorFromRGB(0xFEF5ED)];
        [_randomButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateSelected];
        [_randomButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _randomButton.layer.masksToBounds = YES;
        _randomButton.layer.cornerRadius = 43/2;
    }
    return _randomButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 12;
    }
    return _containerView;
}

- (UITextField *)textView {
    if (!_textView) {
        _textView = [[UITextField alloc] init];
        _textView.delegate = self;
        _textView.placeholder = @"请输入聊天话题";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [XCTheme getTTMainTextColor];
    }
    return _textView;
}
- (UILabel *)numberLablel {
    if (!_numberLablel) {
        _numberLablel = [[UILabel alloc] init];
        _numberLablel.textAlignment = NSTextAlignmentRight;
        _numberLablel.font = [UIFont systemFontOfSize:12];
        _numberLablel.textColor = UIColorFromRGB(0xb3b3b3);
        _numberLablel.text = @"0/0";
    }
    return _numberLablel;
}

- (TTLittleWorldNavView *)navView {
    if (!_navView) {
        _navView = [[TTLittleWorldNavView alloc] init];
        _navView.delegate = self;
        _navView.title = @"聊天话题";
        _navView.isShowLine = NO;
        _navView.isShowBack = YES;
    }
    return _navView;
}

- (NSMutableArray<LittleWorldTeamModel *> *)topicArray {
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}

@end
