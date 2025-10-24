//
//  TTUserCardContainerView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/15.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardContainerView.h"

#import "UserCore.h"

//content
#import "TTUserCardUserInfoContainerView.h"
#import "TTUserCardInfoFunctionContentView.h"
#import "TTUserCardBottomFunctionContentView.h"

//mas
//#import <Masonry/Masonry.h>

//tool
#import "UIView+NTES.h"
#import "XCCurrentVCStackManager.h"

//const
#import "XCMacros.h"
#import "TTPopup.h"

//config
//#import "TTPublicChatUserCardFunctionItemConfig.h"

#define FunctionItemHeight 80.f

@interface TTUserCardContainerView ()
<
TTUserCardUserInfoContainerViewDelegate,
TTUserCardInfoFunctionContentViewDelegate
>

@property (nonatomic,assign) UserID uid;
//view
@property (strong, nonatomic) TTUserCardUserInfoContainerView *userInfoView;
@property (strong, nonatomic) TTUserCardInfoFunctionContentView *functionContentView;
@property (strong, nonatomic) TTUserCardBottomFunctionContentView *bottomOpeContentView;

@property (nonatomic,assign) CGFloat oldHeight;

//datasource

@end

@implementation TTUserCardContainerView

- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid {
//    frame = CGRectMake(0, 0, 314, 112);
    if (self = [super initWithFrame:frame]) {
        self.uid = uid;
        self.autoresizingMask = YES;
        [self initView];
        [self initConstrations];
        
    }
    return self;
}


/**
 初始化方法
 点击榜单 点击在线列表
 @param frame 大小
 @param uid uid
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame uid:(UserID)uid type:(ShowUserCardType)type{
    if (self = [super initWithFrame:frame]) {
        self.uid = uid;
        self.autoresizingMask = YES;
        [self initView];
        [self initConstrations];
        self.userInfoView.type = type;
        
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    [self addSubview:self.userInfoView];
    [self addSubview:self.functionContentView];
    [self addSubview:self.bottomOpeContentView];
}

- (void)dealloc {
    
}

- (void)initConstrations {
    
    self.userInfoView.frame = CGRectMake(0, 0, self.width, 114);
    self.functionContentView.frame = CGRectMake(0, self.userInfoView.bottom, self.width, 0);
    self.bottomOpeContentView.frame = CGRectMake(0, self.functionContentView.bottom, self.width, 0);
}

#pragma mark - public method

- (void)setFunctionArray:(NSMutableArray *)functionArray {
    _functionArray = functionArray;
    [self.functionContentView setFunctionItem:functionArray];
}

- (void)setBottomOpeArray:(NSMutableArray *)bottomOpeArray {
    _bottomOpeArray = bottomOpeArray;
    [self.bottomOpeContentView setOpeButtonArray:bottomOpeArray];
}

/** 得到这个View的高度*/
+(CGFloat)getTTUserCardContainerViewHeightWithFunctionArray:(NSMutableArray *)functionArray bottomOpeArray:(NSMutableArray *)bottomOpeArray{
    
    //计算高度
    NSInteger functionCount  = functionArray.count;
     NSInteger line = functionCount > 4 ? (functionCount % 4 == 0 ? functionCount / 4: functionCount / 4 + 1) : (functionCount > 0 ? 1 : 0);
      CGFloat functionHeight = line * FunctionItemHeight;
    
    CGFloat userHeight = 114;
    
    CGFloat bottomHeight = bottomOpeArray.count > 0 ? 44 : 0;
    return functionHeight + userHeight + bottomHeight;
}

#pragma mark - private method

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    NSLog(@"%@",self);
}


- (void)setTTUserCardContainerViewHeightWithFunctionArray:(NSMutableArray *__nullable)functionArray bottomOpeArray:(NSMutableArray * __nullable)bottomOpeArray{
    self.bottomOpeArray = bottomOpeArray;
    self.functionArray = functionArray;
    [self calContentViewHeight:functionArray.count opeCount:bottomOpeArray.count];
}

- (void)calContentViewHeight:(NSInteger)functionCount opeCount:(NSInteger)opeCount {
   
     NSInteger line = functionCount > 4 ? (functionCount % 4 == 0 ? functionCount / 4: functionCount / 4 + 1) : (functionCount > 0 ? 1 : 0);
    self.functionContentView.top = self.userInfoView.bottom;
    CGFloat height = line * FunctionItemHeight;
    self.functionContentView.height = height;
    
    self.bottomOpeContentView.top = self.functionContentView.bottom;
    self.bottomOpeContentView.height = opeCount > 0 ? 44: 0;


}

#pragma mark - TTUserCardUserInfoContainerViewDelegate

- (void)onUserContentView:(TTUserCardUserInfoContainerView *)view updateWithUserInfo:(UserInfo *)userInfo {
    
    //动态增加主播标签的高度，卡片信息高度：114->130
    if (userInfo.tagList.count > 0) {
        
        CGFloat tagListExtension = 130 - 114;
        CGFloat userInfoViewHeight = 114 + tagListExtension;
        CGFloat viewHeight = [self.class getTTUserCardContainerViewHeightWithFunctionArray:self.functionArray bottomOpeArray:self.bottomOpeArray] + tagListExtension;
        
        self.userInfoView.frame = CGRectMake(0, 0, self.width, userInfoViewHeight);
        self.frame = CGRectMake(0, 0, self.width, viewHeight);
        
        self.functionContentView.top = self.userInfoView.bottom;
        self.bottomOpeContentView.top = self.functionContentView.bottom;
    }
    
    self.functionContentView.currentUserInfo = userInfo;
    self.bottomOpeContentView.currentInfor = userInfo;
}

#pragma mark - TTUserCardInfoFunctionContentViewDelegate
- (void)onUserFunctionCard:(TTUserCardInfoFunctionContentView *)card didselected:(NSIndexPath *)indexPath function:(TTUserCardFunctionItem *)function{
    if (function.type == TTUserCardFunctionItemType_RoomChat && self.itemBlock) {
        
        [[BaiduMobStat defaultStat]logEvent:@"data_card_chat" eventLabel:@"资料卡片-私聊"];
        
        [TTPopup dismiss];
        
        self.itemBlock(card.currentUserInfo.uid);
    }
}

#pragma mark - setter & getter

- (TTUserCardUserInfoContainerView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[TTUserCardUserInfoContainerView alloc]initWithFrame:CGRectZero uid:self.uid];
        _userInfoView.delegate = self;
    }
    return _userInfoView;
}

- (TTUserCardInfoFunctionContentView *)functionContentView {
    if (!_functionContentView) {
        _functionContentView = [[TTUserCardInfoFunctionContentView alloc]initWithFrame:CGRectZero actionUid:self.uid];
        _functionContentView.delegate = self;
    }
    return _functionContentView;
}

- (TTUserCardBottomFunctionContentView *)bottomOpeContentView {
    if (!_bottomOpeContentView) {
        _bottomOpeContentView = [[TTUserCardBottomFunctionContentView alloc]initWithFrame:CGRectZero actionUid:self.uid];
    }
    return _bottomOpeContentView;
}

@end
