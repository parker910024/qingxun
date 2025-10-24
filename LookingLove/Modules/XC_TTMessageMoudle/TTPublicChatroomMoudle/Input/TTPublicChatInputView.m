//
//  TTPublicChatInputView.m
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicChatInputView.h"

//tool
#import "UIView+NIM.h"
#import "XCHUDTool.h"

#import "NIMInputEmoticonDefine.h"

#import "XCMacros.h"
#import "XCTheme.h"

//at
#import "TTPublicAtSearchContainerController.h"

//nim
#import "NIMSessionConfig.h"
#import "NIMKitKeyboardInfo.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKit.h"

#import "XCCurrentVCStackManager.h"


//core
#import "PublicChatroomCore.h"
#import "ImPublicChatroomCore.h"
#import "UserCore.h"
#import "AuthCore.h"

//client
#import "PublicChatroomCoreClient.h"
#import "UserCoreClient.h"

//keychain
#import "SSCustomKeychain.h"

//userinfo
#import "UserCore.h"

//bindingphone
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCCurrentVCStackManager.h"

#import "TTPopup.h"

// 公聊大厅 限制发言的等级  改为后台可配置
//static const int limitUserLevel = 4;

@interface TTPublicChatInputView ()
<
TTPublicInputToolBarDelegate,
NIMInputEmoticonProtocol,
TTPublicAtSearchContainerControllerDelegate,
PublicChatroomCoreClient,
UserCoreClient
>

@property (nonatomic, weak) id<TTPublicChatInputViewDelegate> inputDelegate;
@property (nonatomic, weak) id<NIMInputActionDelegate> actionDelegate;
@property (strong, nonatomic) PublicChatAtMemberAttachment *atMembers;
@property (strong, nonatomic) NSMutableDictionary *atMembersDic;
@property (strong, nonatomic) UserInfo *myUserInfo;
@end

@implementation TTPublicChatInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.myUserInfo = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(PublicChatroomCoreClient, self);
    self.backgroundColor = [UIColor whiteColor];
    if (!_toolBar) {
        _toolBar = [[TTPublicInputToolBar alloc]initWithFrame:CGRectMake(0, 0, self.nim_width, 0)];
        [self addSubview:_toolBar];
        
        if (!GetCore(PublicChatroomCore).canSenMsg || self.myUserInfo.userLevelVo.experLevelSeq.integerValue < GetCore(ImPublicChatroomCore).publicChatRoomLevelNo) {
            [_toolBar setEnable:NO];
        }else {
            [_toolBar setEnable:YES];
        }
        
        if (self.myUserInfo.userLevelVo.experLevelSeq.integerValue < GetCore(ImPublicChatroomCore).publicChatRoomLevelNo) {
            [_toolBar setText:[NSString stringWithFormat:@"用户等级不足%ld级，不可以发言哦~", GetCore(ImPublicChatroomCore).publicChatRoomLevelNo]];
        }
        
        _toolBar.delegate = self;
        self.maxTextLength = 40;
        //设置placeholder
        [_toolBar setPlaceHolder:[NSString stringWithFormat:@"%ld字以内 每次发言间隔5秒哦~",(long)self.maxTextLength]];
        
        [_toolBar.emoticonBtn addTarget:self action:@selector(onTouchEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar.atButton addTarget:self action:@selector(onTouchAtButton:) forControlEvents:UIControlEventTouchUpInside];
        [self refreshStatus:TTInputStatusText];
        [self sizeToFit];
    }
    
}

- (void)initConstrations {
    
}

- (void)didMoveToWindow {
    [self initView];
}

- (void)checkEmojiContainer {
    if (!_emojiContainer) {
        NIMInputEmoticonContainerView *emojiContainer = [[NIMInputEmoticonContainerView alloc]initWithFrame:CGRectZero];
        emojiContainer.nim_size = [emojiContainer sizeThatFits:CGSizeMake(self.nim_width,CGFLOAT_MAX)];
        emojiContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        emojiContainer.delegate = self;
        emojiContainer.hidden = YES;
        emojiContainer.config = nil;
        _emojiContainer = emojiContainer;
        _emojiContainer.backgroundColor = [UIColor whiteColor];
    }
    if (!_emojiContainer.superview) {
        [self addSubview:_emojiContainer];
    }
}

- (void)setEmojiContainer:(UIView *)emojiContainer {
    _emojiContainer = emojiContainer;
    [self sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _emojiContainer.nim_top = self.toolBar.nim_bottom;
}

#pragma mark - UserCoreClient

- (void)onCurrentUserInfoUpdate:(UserInfo *)userInfo {
    if (userInfo.uid == [GetCore(AuthCore)getUid].userIDValue) {
        self.myUserInfo = userInfo;
    }
    
}

#pragma mark - private method

- (CGSize)sizeThatFits:(CGSize)size
{
    //这里不做.语法 get 操作，会提前初始化组件导致卡顿
    CGFloat toolBarHeight = _toolBar.nim_height;
    CGFloat containerHeight = 0;
    switch (self.status)
    {
        case TTInputStatusEmoticon:
            containerHeight = _emojiContainer.nim_height;
            break;
        default:
        {
            UIEdgeInsets safeArea = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *))
            {
                safeArea = self.superview.safeAreaInsets;
            }
            //键盘是从最底下弹起的，需要减去安全区域底部的高度
            CGFloat keyboardDelta = [NIMKitKeyboardInfo instance].keyboardHeight - safeArea.bottom;
            
            //如果键盘还没有安全区域高，容器的初始值为0；否则则为键盘和安全区域的高度差值，这样可以保证 toolBar 始终在键盘上面
            containerHeight = keyboardDelta>0 ? keyboardDelta : 0;
        }
            break;
    }
    CGFloat height = toolBarHeight + containerHeight;
    CGFloat width = self.superview? self.superview.nim_width : self.nim_width;
    return CGSizeMake(width, height);
}

- (void)refreshStatus:(TTInputStatus)status {
    self.status = status;
    [self.toolBar update:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emojiContainer.hidden = status != TTInputStatusEmoticon;
    });
}

- (void)setFrame:(CGRect)frame {
    CGFloat h = self.frame.size.height;
    [super setFrame:frame];
    if (frame.size.height != h) {
        [self heightDidChange];
    }
}

- (void)heightDidChange {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(didChangeInputHeight:)]) {
        if (self.status == TTInputStatusEmoticon)
        {
            //这个时候需要一个动画来模拟键盘
            @KWeakify(self);
            [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
                @KStrongify(self);
                [self.inputDelegate didChangeInputHeight:self.nim_height];
            } completion:nil];
        }
        else
        {
            [_inputDelegate didChangeInputHeight:self.nim_height];
            if (self.nim_height > 300) {
                self.toolBar.showsKeyboard = YES;
            }
        }
    }
    
}

- (void)setInputTextPlaceHolder:(NSString*)placeHolder {
    [_toolBar setPlaceHolder:placeHolder];
}

- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate {
    _actionDelegate = actionDelegate;
}

- (void)reset {
    self.nim_width = self.superview.nim_width;
    [self refreshStatus:TTInputStatusText];
    [self sizeToFit];
}

- (BOOL)endEditing:(BOOL)force {
    BOOL endEditing = [super endEditing:force];
    if (!self.toolBar.showsKeyboard) {
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        void(^animations)(void) = ^{
            [self refreshStatus:TTInputStatusText];
            [self sizeToFit];
            if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(didChangeInputHeight:)]) {
                [self.inputDelegate didChangeInputHeight:self.nim_height];
            }
        };
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    }
    return endEditing;
}

#pragma mark - TTPublicInputToolBarDelegate

- (BOOL)textViewShouldBeginEditing {
    [self refreshStatus:TTInputStatusText];
    return YES;
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [self didPressSend:nil];
        return NO;
    }
    if ([text isEqualToString:@""] && range.length == 1 )
    {
        //非选择删除
        return [self onTextDelete];
    }
    
    // @ 功能
    [self checkAt:text];
    
    //    NSString *str = [self.toolBar.contentText stringByAppendingString:text];
    //    if (str.length > self.maxTextLength)
    //    {
    //        return NO;
    //    }
    return YES;
}


- (void)checkAt:(NSString *)text {
    if ([text isEqualToString:NIMInputAtStartChar]) {
        if (![self judgeAtCount]) {
            [XCHUDTool showErrorWithMessage:@"一天只能AT十次噢，请明天再试"];
            return;
        }
        switch (self.session.sessionType) {
                
            case NIMSessionTypeChatroom:{
                TTPublicAtSearchContainerController  *vc = [[TTPublicAtSearchContainerController alloc]init];
                vc.selectedUser = self.atMembersDic;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                vc.delegate = self;
                [[[XCCurrentVCStackManager shareManager]getCurrentVC]presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}


- (void)textViewDidChange
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTextChanged:)])
    {
        [self.actionDelegate onTextChanged:self];
    }
}

- (void)textViewTextDidChange:(NIMGrowingTextView *)textView {
    if (textView.textView.text.length >= self.maxTextLength) {
        textView.text = [textView.text substringToIndex:self.maxTextLength];
    }
}

- (void)toolBarDidChangeHeight:(CGFloat)height
{
    [self sizeToFit];
}

#pragma mark - TTPublicAtSearchContainerControllerDelegate

- (void)onAtUsersSelected:(PublicChatAtMemberAttachment *)members selectedDic:(NSMutableDictionary *)selectedDic {
    NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
    
    NSMutableArray *tempNames = [members.atNames mutableCopy];
    for (int i = 0; i < tempNames.count; i++) {
        NSString *name = [members.atNames objectAtIndex:i];
        if (![self.atMembers.atNames containsObject:name]) {
            if (self.toolBar.contentText.length + name.length + 1 > self.maxTextLength) {
                //已经超过40字了 所以需要去掉不能加进去的人
                [selectedDic removeObjectForKey:[members.atUids objectAtIndex:i]];
                
                NSMutableArray *atNames = [members.atNames mutableCopy];
                [atNames removeObjectAtIndex:i];
                members.atNames = atNames;
                
                NSMutableArray *atUids = [members.atUids mutableCopy];
                [atUids removeObjectAtIndex:i];
                members.atUids = atUids;
                
                NSMutableArray *orginNames = [members.originAtNames mutableCopy];
                [orginNames removeObjectAtIndex:i];
                members.originAtNames = orginNames;
                
                break;
            }
            [str appendString:name];
            [str appendString:NIMInputAtEndChar];
            
            if (i == members.atNames.count - 1) {
                [self.toolBar insertText:str];
            }
        }
    }
    
    
    for (NSString *uid in members.atUids) {
        if (![self.atMembers.atUids containsObject:uid]) {
            NSString *nick = [members.originAtNames objectAtIndex:[members.atUids indexOfObject:uid]];
            NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
            item.uid  = uid;
            item.name = nick;
            [self.atCache addAtItem:item];
        }
        
    }
    
    self.atMembers = members;
    self.atMembersDic = selectedDic;
    
    
}

#pragma mark - InputEmoticonProtocol
- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description{
    if (!emotCatalogID) { //删除键
        [self onTextDelete];
    }else{
        if ([emotCatalogID isEqualToString:NIMKit_EmojiCatalog]) {
            if (self.toolBar.contentText.length + description.length <= 40) {
                [self.toolBar insertText:description];
            }
        }else{
            //发送贴图消息
            if ([self.actionDelegate respondsToSelector:@selector(onSelectChartlet:catalog:)]) {
                [self.actionDelegate onSelectChartlet:emoticonID catalog:emotCatalogID];
            }
        }
        
        
    }
}

- (void)didPressSend:(id)sender{
    if (!GetCore(PublicChatroomCore).canSenMsg) {
        return;
    }
    
    UserInfo *info = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
    if (!info.isBindPhone) {
        
        self.toolBar.showsKeyboard = NO;
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = @"为了营造更安全的网络环境\n发言需先绑定手机号";
        config.confirmButtonConfig.title = @"前往";
        
        TTAlertMessageAttributedConfig *attConfig = [[TTAlertMessageAttributedConfig alloc] init];
        attConfig.text = @"绑定手机号";
        attConfig.color = [XCTheme getTTMainColor];

        config.messageAttributedConfig = @[attConfig];
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            UIViewController *vc = [[XCMediator  sharedInstance]ttPersonalModule_BindingPhoneController:0 userInfo:[info model2dictionary]];
            [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
            
        } cancelHandler:^{
        }];
        
    }else {
        if ([self.actionDelegate respondsToSelector:@selector(onSendText:atAttachment:)] && [self.toolBar.contentText length] > 0) {
            NSString *sendText = self.toolBar.contentText;
            [self.actionDelegate onSendText:sendText atAttachment:self.atMembers];
            
//            self.atMembers = nil;
//            [self.atMembersDic removeAllObjects];
//            [self.atCache clean];
            
            [self.toolBar layoutIfNeeded];
        }
    }
}

- (void)cleanMessage {
    if (GetCore(PublicChatroomCore).canSenMsg) {
        self.toolBar.contentText = @"";
    }
    self.atMembers = nil;
    [self.atMembersDic removeAllObjects];
    [self.atCache clean];
}

- (BOOL)onTextDelete {
    NSRange range = [self delRangeForEmoticon];
    if (range.length == 1)
    {
        //删的不是表情，可能是@
        NIMInputAtItem *item = [self delRangeForAt];
        if (item) {
            range = item.range;
        }
    }
    if (range.length == 1) {
        //自动删除
        return YES;
    }
    [self.toolBar deleteText:range];
    return NO;
}

- (NSRange)delRangeForEmoticon {
    NSString *text = self.toolBar.contentText;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self.toolBar selectedRange];
    if (range.length > 1)
    {
        NSString *name = [text substringWithRange:range];
        NIMInputEmoticon *icon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:name];
        range = icon? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    return range;
}


- (NIMInputAtItem *)delRangeForAt {
    NSString *text = self.toolBar.contentText;
    NSRange range = [self rangeForPrefix:NIMInputAtStartChar suffix:NIMInputAtEndChar];
    NSRange selectedRange = [self.toolBar selectedRange];
    NIMInputAtItem *item = nil;
    if (range.length > 1)
    {
        NSString *name = [text substringWithRange:range];
        [self configAtAttachment:name];
        NSString *set = [NIMInputAtStartChar stringByAppendingString:NIMInputAtEndChar];
        
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
        item = [self.atCache item:name];
        range = item? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    item.range = range;
    return item;
}

- (void)configAtAttachment:(NSString *)name {
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:NIMInputAtEndChar]];
    NSMutableArray *atNameItems = [self.atMembers.atNames mutableCopy];
    NSMutableArray *atUids = [self.atMembers.atUids mutableCopy];
    NSInteger nameIndex = 0;
    for (NSString *item in self.atMembers.atNames) {
        if ([item containsString:name]) {
            [atNameItems removeObject:item];            NSString *deleteUid = [atUids objectAtIndex:nameIndex];            [self.atMembersDic removeObjectForKey:deleteUid];
            [atUids removeObjectAtIndex:nameIndex];
        }
        nameIndex++;
    }
    self.atMembers.atNames = atNameItems;
    self.atMembers.atUids = atUids;
}

- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix {
    NSString *text = self.toolBar.contentText;
    NSRange range = [self.toolBar selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        //往前搜最多20个字符，一般来讲是够了...
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    return index == -1? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}

#pragma mark - PublicChatroomCoreClient

- (void)onPublicChatSenderCountDown:(NSInteger)countDownNumber {
    [self.toolBar setEnable:NO];
    NSString *tips = [NSString stringWithFormat:@"%ld秒后才可发言哦~",(long)countDownNumber];
    [self.toolBar setText:tips];
}

- (void)onPublicChatSenderCountDownFinish {
    [self.toolBar setEnable:YES];
    [self.toolBar setText:@""];
}

#pragma mark - TTPublicChatInputViewDelegate

- (void)setInputDelegate:(id<TTPublicChatInputViewDelegate>)delegate {
    _inputDelegate = delegate;
}

#pragma mark - private

- (void)addAtTimes {
    NSUserDefaults *atCount = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *atCountCache = [[atCount objectForKey:@"ATCount"] mutableCopy];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    NSMutableDictionary *uidCache = [[atCountCache objectForKey:[GetCore(AuthCore)getUid]] mutableCopy];
    NSInteger atTimes = [[uidCache objectForKey:strDate] integerValue];
    atTimes++;
    [uidCache setObject:@(atTimes) forKey:strDate];
    
    [atCountCache setObject:uidCache forKey:[GetCore(AuthCore)getUid]];
    
    [atCount setObject:atCountCache forKey:@"ATCount"];
    
    [atCount synchronize];
}

- (BOOL)judgeAtCount {
    NSUserDefaults *atCount = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *atCountCache = [[atCount objectForKey:@"ATCount"] mutableCopy];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    if (atCountCache) {
        NSMutableDictionary *uidCache = [[atCountCache objectForKey:[GetCore(AuthCore)getUid]] mutableCopy];
        if (uidCache) {
            
            NSInteger atTimes = [[uidCache objectForKey:strDate] integerValue];
            if (atTimes >=10) {
                return NO;
            }else {
                return YES;
            }
        }else {
            NSMutableDictionary *atTimes = [NSMutableDictionary dictionary];
            
            [atTimes setObject:@"0" forKey:strDate];
            
            [atCountCache setObject:atTimes forKey:[GetCore(AuthCore)getUid]];
            
            [atCount setObject:atCountCache forKey:@"ATCount"];
            [atCount synchronize];
            return YES;
        }
    } else {
        atCountCache = [NSMutableDictionary dictionary];
        NSMutableDictionary *atTimes = [NSMutableDictionary dictionary];
        
        [atTimes setObject:@"0" forKey:strDate];
        
        [atCountCache setObject:atTimes forKey:[GetCore(AuthCore)getUid]];
        
        [atCount setObject:atCountCache forKey:@"ATCount"];
        [atCount synchronize];
        return YES;
        
    }
    //    @{@"ATCount":@{
    //              @"uid":@{
    //                      @"2018-11-11":@"10"
    //                      }
    //              }};
    
    //    @{
    //              @"uid":@{
    //                      @"2018-11-11":@"10"
    //                      }
    //              }
    
    return NO;
}

#pragma mark - User Respoen

- (void)onTouchEmojiButton:(id)sender {
    if (!GetCore(PublicChatroomCore).canSenMsg) {
        return;
    }
    if (self.status != TTInputStatusEmoticon) {
        [self checkEmojiContainer];
        [self bringSubviewToFront:self.emojiContainer];
        [self.emojiContainer setHidden:NO];
        [self refreshStatus:TTInputStatusEmoticon];
        [self sizeToFit];
        
        
        if (self.toolBar.showsKeyboard)
        {
            self.toolBar.showsKeyboard = NO;
        }
    }
    else
    {
        [self refreshStatus:TTInputStatusText];
        self.toolBar.showsKeyboard = YES;
    }
}

- (void)onTouchAtButton:(id)sender {
    if (!GetCore(PublicChatroomCore).canSenMsg) {
        return;
    }
    if (![self judgeAtCount]) {
        [XCHUDTool showErrorWithMessage:@"一天只能AT十次噢，请明天再试"];
        return;
    }
    TTPublicAtSearchContainerController  *vc = [[TTPublicAtSearchContainerController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.delegate = self;
    vc.selectedUser = self.atMembersDic;
    [[[XCCurrentVCStackManager shareManager]getCurrentVC]presentViewController:nav animated:YES completion:nil];
}


#pragma mark - setter & getter

- (void)setMyUserInfo:(UserInfo *)myUserInfo {
    _myUserInfo = myUserInfo;
    if (myUserInfo.userLevelVo.experLevelSeq.integerValue < GetCore(ImPublicChatroomCore).publicChatRoomLevelNo) {
        [self.toolBar setEnable:NO];
        [self.toolBar setText:[NSString stringWithFormat:@"用户等级不足%ld级，不可以发言哦~", GetCore(ImPublicChatroomCore).publicChatRoomLevelNo]];
    }else {
        [self.toolBar setEnable:YES];
        [self.toolBar setText:@""];
    }
}

- (NIMInputAtCache *)atCache {
    if (!_atCache) {
        _atCache = [[NIMInputAtCache alloc]init];
    }
    return _atCache;
}

- (NSMutableDictionary *)atMembersDic {
    if (!_atMembersDic) {
        _atMembersDic = [NSMutableDictionary dictionary];
    }
    return _atMembersDic;
}

@end
