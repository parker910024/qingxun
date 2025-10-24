//
//  TTRoomIntroduceViewController.m
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomIntroduceViewController.h"

#import "TTRoomThemeEditView.h"
#import "TTRoomIntroduceEditView.h"

//core
#import "RoomInfo.h"
#import "RoomCoreV2.h"
#import "ImRoomCoreV2.h"
#import "AuthCore.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "UIImage+_1x1Color.h"

@interface TTRoomIntroduceViewController ()
/** 主题 */
@property (nonatomic, strong) TTRoomThemeEditView *ttThemeEditView;
/** 介绍 */
@property (nonatomic, strong) TTRoomIntroduceEditView *ttIntroduceEditView;
/** 保存 */
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation TTRoomIntroduceViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - RoomCoreClient
- (void)onGameRoomInfoUpdateSuccess:(RoomInfo *)info eventType:(RoomUpdateEventType)eventType {
    if (eventType != RoomUpdateEventTypeOther) {
        return;
    }
    [XCHUDTool showSuccessWithMessage:@"修改成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onGameRoomInfoUpdateFailth:(NSString *)message {
    NSString *tipString = @"修改信息失败，请重试";
    [XCHUDTool showErrorWithMessage:tipString];
}

#pragma mark - event response
- (void)ttDidClickComButton:(UIButton *)btn {
    
    NSString *theme = [self.ttThemeEditView.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *introduction = [self.ttIntroduceEditView.textView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (theme.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请设置公告标题"];
        return;
    }
    
    if (theme.length > 15) {
        [XCHUDTool showErrorWithMessage:@"公告标题不能超过15个字"];
        return;
    }
    
    if (introduction.length > 300) {
        [XCHUDTool showErrorWithMessage:@"公告内容不能超过300个字"];
        return;
    }
    
    if (theme == nil || theme.length == 0) {
        theme = @"";
    }
    
    if (introduction == nil || introduction.length == 0) {
        introduction = @"";
    }
    
    UpdateRoomInfoType type;
    if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator) {
        type = UpdateRoomInfoTypeUser;
    } else if (GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeManager ) {
        type = UpdateRoomInfoTypeManager;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"introduction"] = introduction;
    dict[@"roomDesc"] = theme;
    [XCHUDTool showGIFLoading];
    [GetCore(RoomCoreV2) updateGameRoomInfo:dict type:type];
}

- (void)textViewTextDidChange {
    NSString *theme = [self.ttThemeEditView.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (theme.length > 0) {
        self.sureButton.enabled = YES;
    } else {
        self.sureButton.enabled = NO;
    }
}

- (void)didClickViewAction {
    [self.view endEditing:YES];
}
#pragma mark - private method

- (void)initView {
    self.title = @"房间公告";
    
    [self.sureButton addTarget:self action:@selector(ttDidClickComButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.ttThemeEditView];
    [self.view addSubview:self.ttIntroduceEditView];
    
    AddCoreClient(RoomCoreClient, self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextFieldTextDidChangeNotification object:self.ttThemeEditView.textField];
    [self textViewTextDidChange];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickViewAction)]];
}

- (void)initConstrations {
    [self.ttThemeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(44 + statusbarHeight);
        make.height.mas_equalTo(82);
    }];
    
    [self.ttIntroduceEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.ttThemeEditView.mas_bottom);
        make.height.mas_equalTo(230);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 - kSafeAreaBottomHeight);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - getters and setters
- (void)setTtRoomInfo:(RoomInfo *)ttRoomInfo {
    _ttRoomInfo = ttRoomInfo;
    
    self.ttThemeEditView.textField.text = ttRoomInfo.roomDesc;
    self.ttIntroduceEditView.textView.text = ttRoomInfo.introduction;
    [self.ttThemeEditView textFieldTextDidChange];
    [self.ttIntroduceEditView textViewTextDidChange];
    
    [self textViewTextDidChange];
}

- (TTRoomThemeEditView *)ttThemeEditView {
    if (!_ttThemeEditView) {
        _ttThemeEditView = [[TTRoomThemeEditView alloc] init];
    }
    return _ttThemeEditView;
}

- (TTRoomIntroduceEditView *)ttIntroduceEditView {
    if (!_ttIntroduceEditView) {
        _ttIntroduceEditView = [[TTRoomIntroduceEditView alloc] init];
    }
    return _ttIntroduceEditView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.layer.cornerRadius = 19;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xdbdbdb)] forState:UIControlStateDisabled];
        [_sureButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTMainColor]] forState:UIControlStateNormal];
    }
    return _sureButton;
}

@end
