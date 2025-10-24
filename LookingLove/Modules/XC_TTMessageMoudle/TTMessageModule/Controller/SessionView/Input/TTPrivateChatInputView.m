//
//  TTPrivateChatInputView.m
//  AFNetworking
//
//  Created by apple on 2019/5/28.
//

#import "TTPrivateChatInputView.h"
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

#import "TTFamilyBaseAlertController.h"

@interface TTPrivateChatInputView ()
<
TTPrivateInputToolBarDelegate,
NIMInputEmoticonProtocol,
PublicChatroomCoreClient,
UserCoreClient
>

@property (nonatomic, weak) id<TTPrivateChatInputViewDelegate> inputDelegate;
@property (nonatomic, weak) id<NIMInputActionDelegate> actionDelegate;
@property (strong, nonatomic) PublicChatAtMemberAttachment *atMembers;
@property (strong, nonatomic) NSMutableDictionary *atMembersDic;
@property (strong, nonatomic) UserInfo *myUserInfo;
@end

@implementation TTPrivateChatInputView

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
        _toolBar = [[TTPrivateInputToolBar alloc]initWithFrame:CGRectMake(0, 0, self.nim_width, 0)];
        [self addSubview:_toolBar];
        
        _toolBar.delegate = self;
        self.maxTextLength = 40;
        
        [_toolBar.emoticonBtn addTarget:self action:@selector(onTouchEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
        [self refreshStatus:TTPrivateInputStatusText];
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
        case TTPrivateInputStatusEmoticon:
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

- (void)refreshStatus:(TTPrivateInputStatus)status {
    self.status = status;
    [self.toolBar update:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emojiContainer.hidden = status != TTPrivateInputStatusEmoticon;
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
        if (self.status == TTPrivateInputStatusEmoticon)
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
    [self refreshStatus:TTPrivateInputStatusText];
    [self sizeToFit];
}

- (BOOL)endEditing:(BOOL)force {
    BOOL endEditing = [super endEditing:force];
    if (!self.toolBar.showsKeyboard) {
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        void(^animations)(void) = ^{
            [self refreshStatus:TTPrivateInputStatusText];
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
    [self refreshStatus:TTPrivateInputStatusText];
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
    
    //    NSString *str = [self.toolBar.contentText stringByAppendingString:text];
    //    if (str.length > self.maxTextLength)
    //    {
    //        return NO;
    //    }
    return YES;
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
    
//    UserInfo *info = [GetCore(UserCore)getUserInfoInDB:[GetCore(AuthCore)getUid].userIDValue];
    
        if ([self.actionDelegate respondsToSelector:@selector(onSendText:atAttachment:)] && [self.toolBar.contentText length] > 0) {
            NSString *sendText = self.toolBar.contentText;
            [self.actionDelegate onSendText:sendText atAttachment:self.atMembers];
            
            //            self.atMembers = nil;
            //            [self.atMembersDic removeAllObjects];
            //            [self.atCache clean];
            
            [self.toolBar layoutIfNeeded];
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

#pragma mark - TTPrivateChatInputViewDelegate
- (void)setInputDelegate:(id<TTPrivateChatInputViewDelegate>)delegate {
    _inputDelegate = delegate;
}


#pragma mark - User Respoen
- (void)onTouchEmojiButton:(id)sender {
    if (!GetCore(PublicChatroomCore).canSenMsg) {
        return;
    }
    if (self.status != TTPrivateInputStatusEmoticon) {
        [self checkEmojiContainer];
        [self bringSubviewToFront:self.emojiContainer];
        [self.emojiContainer setHidden:NO];
        [self refreshStatus:TTPrivateInputStatusEmoticon];
        [self sizeToFit];
        
        
        if (self.toolBar.showsKeyboard)
        {
            self.toolBar.showsKeyboard = NO;
        }
    }
    else
    {
        [self refreshStatus:TTPrivateInputStatusText];
        self.toolBar.showsKeyboard = YES;
    }
}

#pragma mark - setter & getter
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
