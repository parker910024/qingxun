//
//  NIMSessionLayout.m
//  NIMKit
//
//  Created by chris on 2016/11/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMSessionLayoutImpl.h"
#import "UITableView+NIMScrollToBottom.h"
#import "NIMMessageCell.h"
#import "NIMGlobalMacro.h"
#import "NIMSessionTableAdapter.h"
#import "UIView+NIM.h"
#import "NIMKitKeyboardInfo.h"

//inputview
#import "TTPublicChatInputView.h"
#import "TTLittleWorldInputView.h"

//custom
#import "ImPublicChatroomCore.h"

@interface NIMSessionLayoutImpl(){
    NSMutableArray *_inserts;
    CGFloat _inputViewHeight;
}

@property (nonatomic,strong)  UIRefreshControl *refreshControl;

@property (nonatomic,strong)  NIMSession  *session;

@property (nonatomic,strong)  id<NIMSessionConfig> sessionConfig;

@property (nonatomic,weak)    id<NIMSessionLayoutDelegate> delegate;

@end

@implementation NIMSessionLayoutImpl

- (instancetype)initWithSession:(NIMSession *)session
                         config:(id<NIMSessionConfig>)sessionConfig
{
    self = [super init];
    if (self) {
        _sessionConfig = sessionConfig;
        _session       = session;
        _inserts       = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:NIMKitKeyboardWillChangeFrameNotification object:nil];
    
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTable
{
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView
{
    BOOL change = _tableView != tableView;
    if (change)
    {
        _tableView = tableView;
        [self setupRefreshControl];
    }
}

- (void)resetLayout
{
    [self adjustInputView];
    [self adjustTableView];
}

- (void)layoutAfterRefresh
{
    [self.refreshControl endRefreshing];
    
    CGFloat offset  = self.tableView.contentSize.height - self.tableView.contentOffset.y;
    [self.tableView reloadData];
    CGFloat offsetYAfterLoad = self.tableView.contentSize.height - offset;
    CGPoint point  = self.tableView.contentOffset;
    point.y = offsetYAfterLoad;
    [self.tableView setContentOffset:point animated:NO];
}


- (void)changeLayout:(CGFloat)inputViewHeight
{
    BOOL change = _inputViewHeight != inputViewHeight;
    if (change)
    {
        _inputViewHeight = inputViewHeight;
        [self adjustInputView];
        [self adjustTableView];
    }
}

- (void)tableViewCurrentIsInBottom:(BOOL)isInBottom {
    self.tableViewIsInBottom = isInBottom;
    if (isInBottom) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MESSAGETABLEVIEW_HAD_INBOTTOM" object:nil];
    }
}


- (void)adjustInputView
{
    if ([self.inputView isKindOfClass:NSClassFromString(@"TTPublicChatInputView")]) {
        TTPublicChatInputView *view = (TTPublicChatInputView *)self.inputView;
        UIView *superView = view.superview;
        UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            safeAreaInsets = superView.safeAreaInsets;
        }
        self.inputView.nim_bottom = superView.nim_height - safeAreaInsets.bottom;
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"NIMInputView")]) {
        NIMInputView *view = (NIMInputView *)self.inputView;
        UIView *superView = view.superview;
        UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            safeAreaInsets = superView.safeAreaInsets;
        }
        self.inputView.nim_bottom = superView.nim_height - safeAreaInsets.bottom;
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"TTLittleWorldInputView")]){
        TTLittleWorldInputView *view = (TTLittleWorldInputView *)self.inputView;
        UIView *superView = view.superview;
        UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            safeAreaInsets = superView.safeAreaInsets;
        }
        self.inputView.nim_bottom = superView.nim_height - safeAreaInsets.bottom;
    }
}

- (void)adjustTableView
{
    //输入框是否弹起
    BOOL inputViewUp = NO;
    if ([self.inputView isKindOfClass:NSClassFromString(@"TTPublicChatInputView")]) {
        TTPublicChatInputView *view = (TTPublicChatInputView *)self.inputView;
        switch (view.status)
        {
            case TTInputStatusText:
                inputViewUp = [NIMKitKeyboardInfo instance].isVisiable;
                break;
//            case NIMInputStatusAudio:
//                inputViewUp = NO;
//                break;
//            case NIMInputStatusMore:
            case TTInputStatusEmoticon:
                inputViewUp = YES;
            default:
                break;
        }
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"NIMInputView")]) {
        NIMInputView *view = (NIMInputView *)self.inputView;
        switch (view.status)
        {
            case NIMInputStatusText:
                inputViewUp = [NIMKitKeyboardInfo instance].isVisiable;
                break;
            case NIMInputStatusAudio:
                inputViewUp = NO;
                break;
            case NIMInputStatusMore:
            case NIMInputStatusEmoticon:
                inputViewUp = YES;
            default:
                break;
        }
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"TTLittleWorldInputView")]){
        TTLittleWorldInputView *view = (TTLittleWorldInputView *)self.inputView;
        switch (view.status)
        {
            case TTInputStatusText:
                inputViewUp = [NIMKitKeyboardInfo instance].isVisiable;
                break;
            case TTInputStatusEmoticon:
                inputViewUp = YES;
            default:
                break;
        }
    }
    
    self.tableView.userInteractionEnabled = !inputViewUp;
    CGRect rect = self.tableView.frame;
    
    //tableview 的位置
    UIView *superView = self.tableView.superview;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = superView.safeAreaInsets;
    }
    
    CGFloat containerSafeHeight;
    
    if ([self.inputView isKindOfClass:NSClassFromString(@"TTPublicChatInputView")]) {
        TTPublicChatInputView *view = (TTPublicChatInputView *)self.inputView;
        containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
        rect.size.height = containerSafeHeight - view.toolBar.nim_height;
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"NIMInputView")]) {
        NIMInputView *view = (NIMInputView *)self.inputView;
        containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
        rect.size.height = containerSafeHeight - view.toolBar.nim_height;
    }else if ([self.inputView isKindOfClass:NSClassFromString(@"TTLittleWorldInputView")]){
        TTLittleWorldInputView *view = (TTLittleWorldInputView *)self.inputView;
        containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
        rect.size.height = containerSafeHeight - view.toolBar.nim_height;
    }else {
        NIMInputView *view = (NIMInputView *)self.inputView;
        containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
        rect.size.height = containerSafeHeight - view.toolBar.nim_height;
    }
    
    //tableview 的内容 inset
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    CGFloat visiableHeight = 0;
    if (@available(iOS 11.0, *))
    {
        contentInsets = self.tableView.adjustedContentInset;
    }
    else
    {
        contentInsets = self.tableView.contentInset;
        visiableHeight = [self fixVisiableHeightBelowIOS11:visiableHeight];
    }
    
    //如果气泡过少，少于总高度，输入框视图需要顶到最后一个气泡的下面。
    visiableHeight = visiableHeight + self.tableView.contentSize.height + contentInsets.top + contentInsets.bottom;
    visiableHeight = MIN(visiableHeight, rect.size.height);
    
    
    
    rect.origin.y    = containerSafeHeight - visiableHeight - self.inputView.nim_height;
    rect.origin.y    = rect.origin.y > 0? 0 : rect.origin.y;
    
    
    BOOL tableChanged = !CGRectEqualToRect(self.tableView.frame, rect);
    if (tableChanged)
    {
        [self.tableView setFrame:rect];
        [self.tableView nim_scrollToBottom:YES];
    }
}


- (CGFloat)fixVisiableHeightBelowIOS11:(CGFloat)visiableHeight
{
    //iOS11 以下，当插入数据后不会立即改变 contentSize 的大小，所以需要手动添加最后一个数据的高度
    NSInteger section = self.tableView.numberOfSections - 1;
    NSInteger row     = [self.tableView numberOfRowsInSection:section] - 1;
    if (section >=0 && row >=0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        CGFloat height = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
        return visiableHeight + height;
    }
    else
    {
        return visiableHeight;
    }
}


#pragma mark - Notification
- (void)menuDidHide:(NSNotification *)notification
{
    [UIMenuController sharedMenuController].menuItems = nil;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.tableView.window)
    {
        //如果当前视图不是顶部视图，则不需要监听
        return;
    }
    [self.inputView sizeToFit];
}

#pragma mark - Private

- (void)calculateContent:(NIMMessageModel *)model{
    NIMKit_Dispatch_Sync_Main(^{
        [model contentSize:self.tableView.nim_width];
    })
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];

    
    if (@available(iOS 10.0, *))
    {
        self.tableView.refreshControl = self.refreshControl;
    }
    else
    {
        [self.tableView addSubview: self.refreshControl];
    }
    
    [self.refreshControl addTarget:self action:@selector(headerRereshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)headerRereshing:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onRefresh)])
    {
        [self.delegate onRefresh];
    }
}



- (void)insert:(NSArray<NSIndexPath *> *)indexPaths animated:(BOOL)animated
{
    if (!indexPaths.count)
    {
        return;
    }

    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [addIndexPathes addObject:indexPath];
    }];
    
    if ([self shouldReloadWhenInsert:addIndexPathes])
    {
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:addIndexPathes
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:addIndexPathes.lastObject
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }

    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
        [self resetLayout];
    } completion:nil];
    if (self.session.sessionType == NIMSessionTypeChatroom && [self.session.sessionId integerValue] == GetCore(ImPublicChatroomCore).publicChatroomId) {
        if (self.tableViewIsInBottom) {
            [self.tableView nim_scrollToBottom:YES];
        }else {
            if ([self.tableView numberOfRowsInSection:0] > 10) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"NIM_HAS_NEW_MESAAGE" object:nil];
            }else {
                [self.tableView nim_scrollToBottom:YES];
            }
            
        }
    }else {
        [self.tableView nim_scrollToBottom:YES];
    }
}

- (void)remove:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([self shouldReloadWhenRemoveOrUpdate:indexPaths])
    {
        [self.tableView reloadData];
        return;
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    NSInteger row = [self.tableView numberOfRowsInSection:0] - 1;
    if (row > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}



- (void)update:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        CGFloat scrollOffsetY = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, scrollOffsetY) animated:NO];
    }
}

- (BOOL)canInsertChatroomMessages
{
    return !self.tableView.isDecelerating && !self.tableView.isDragging;
}

#pragma mark -

- (BOOL)shouldReloadWhenInsert:(NSArray<NSIndexPath *> *)indexPaths
{
    // 如果插入数据后，中间有空档，则不能直接插入，需要全量重新加载
    NSMutableDictionary * sectionCurrentCount = [NSMutableDictionary dictionary];
    NSMutableDictionary * sectionMaxCount = [NSMutableDictionary dictionary];
    NSMutableDictionary * sectionInsertingCount = [NSMutableDictionary dictionary];
    
    for(NSIndexPath * indexPath in indexPaths)
    {
        NSInteger section = indexPath.section;
        NSInteger count = [self.tableView numberOfRowsInSection:section];
        sectionCurrentCount[@(section)] = @(count);
    }
    
    for(NSIndexPath * indexPath in indexPaths)
    {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSInteger count = [sectionCurrentCount[@(section)] integerValue];
        NSInteger sectionMaxNum = [sectionMaxCount[@(section)] integerValue];
        NSInteger max = 0;
        if (row <= count)
        {
            sectionCurrentCount[@(section)] = @(count+1);
            max = count + 1;
        }
        else
        {
            max = row + 1;
        }
        max = MAX(max, sectionMaxNum);
        sectionMaxCount[@(section)] = @(max);
        
        NSInteger sectionCurrentCount = [sectionInsertingCount[@(section)] integerValue];
        sectionInsertingCount[@(section)] = @(++ sectionCurrentCount);
    }
    
    for(NSNumber * sectionKey in sectionMaxCount.allKeys)
    {
        NSInteger maxCount = [sectionMaxCount[sectionKey] integerValue];
        NSInteger currentCount = [sectionInsertingCount[sectionKey] integerValue];
        NSInteger section = [sectionKey integerValue];
        NSInteger count = [self.tableView numberOfRowsInSection:section];
        if (maxCount > count + currentCount)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)shouldReloadWhenRemoveOrUpdate:(NSArray<NSIndexPath *> *)indexPaths
{
    for(NSIndexPath * indexPath in indexPaths)
    {
        NSInteger section = indexPath.section;
        NSInteger number = [self.tableView numberOfRowsInSection:section];
        if (number <= indexPath.row)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
