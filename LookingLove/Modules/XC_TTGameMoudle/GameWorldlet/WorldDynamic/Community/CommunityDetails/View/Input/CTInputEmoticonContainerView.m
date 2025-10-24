//
//  CTInputEmoticonContainerView.m
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CTInputEmoticonContainerView.h"
#import "NIMPageView.h"
#import "UIView+NIM.h"
#import "CTInputEmoticonButton.h"
#import "CTInputEmoticonManager.h"
#import "CTInputEmoticonTabView.h"
#import "CTInputEmoticonDefine.h"
#import "UIImage+NIMKit.h"

NSInteger CTCustomPageControlHeight = 36;
NSInteger CTCustomPageViewHeight    = 159;

@interface CTInputEmoticonContainerView()<CTEmoticonButtonTouchDelegate,CTInputEmoticonTabDelegate>

@property (nonatomic,strong) NSMutableArray *pageData;

@end


@implementation CTInputEmoticonContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
    }
    return self;
}

- (void)loadConfig{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setConfig:(id<NIMSessionConfig>)config{
    _config = config;
    [self loadUIComponents];
    [self reloadData];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 216.f);
}




- (void)loadUIComponents
{
    _emoticonPageView                  = [[NIMPageView alloc] initWithFrame:self.bounds];
    _emoticonPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _emoticonPageView.nim_height       = CTCustomPageViewHeight;
    _emoticonPageView.backgroundColor  = [UIColor clearColor];
    _emoticonPageView.dataSource       = self;
    _emoticonPageView.pageViewDelegate = self;
    [self addSubview:_emoticonPageView];
    
    _emotPageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, CTCustomPageControlHeight)];
    _emotPageController.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _emotPageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    _emotPageController.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_emotPageController];
    [_emotPageController setUserInteractionEnabled:NO];
}

- (void)setFrame:(CGRect)frame{
    CGFloat originalWidth = self.frame.size.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        [self reloadData];
    }
}

- (void)reloadData{
    NSArray *data = [self loadCatalogAndChartlet];
    self.totalCatalogData   = data;
    self.currentCatalogData = data.firstObject;
}

- (NSArray *)loadCatalogAndChartlet
{
    CTInputEmoticonCatalog * defaultCatalog = [self loadDefaultCatalog];
    NSArray *charlets = [self loadChartlet];
    NSArray *catalogs = defaultCatalog? [@[defaultCatalog] arrayByAddingObjectsFromArray:charlets] : charlets;
    return catalogs;
}

#define EmotPageControllerMarginBottom 10
- (void)layoutSubviews{
    [super layoutSubviews];
    self.emotPageController.nim_top = self.emoticonPageView.nim_bottom - EmotPageControllerMarginBottom;
    self.tabView.nim_bottom = self.nim_height;
}



#pragma mark -  config data

- (NSInteger)sumPages
{
    __block NSInteger pagesCount = 0;
    [self.totalCatalogData enumerateObjectsUsingBlock:^(CTInputEmoticonCatalog* data, NSUInteger idx, BOOL *stop) {
        pagesCount += data.pagesCount;
    }];
    return pagesCount;
}


- (UIView*)emojPageView:(NIMPageView*)pageView inEmoticonCatalog:(CTInputEmoticonCatalog *)emoticon page:(NSInteger)page
{
    UIView *subView = [[UIView alloc] init];
    NSInteger iconHeight    = emoticon.layout.imageHeight;
    NSInteger iconWidth     = emoticon.layout.imageWidth;
    CGFloat startX          = (emoticon.layout.cellWidth - iconWidth) / 2  + CTKit_EmojiLeftMargin;
    CGFloat startY          = (emoticon.layout.cellHeight- iconHeight) / 2 + CTKit_EmojiTopMargin;
    int32_t coloumnIndex = 0;
    int32_t rowIndex = 0;
    int32_t indexInPage = 0;
    NSInteger begin = page * emoticon.layout.itemCountInPage;
    NSInteger end   = begin + emoticon.layout.itemCountInPage;
    end = end > emoticon.emoticons.count ? (emoticon.emoticons.count) : end;
    for (NSInteger index = begin; index < end; index ++)
    {
        CTInputEmoticon *data = [emoticon.emoticons objectAtIndex:index];
        
        CTInputEmoticonButton *button = [CTInputEmoticonButton iconButtonWithData:data catalogID:emoticon.catalogID delegate:self];
        //计算表情位置
        rowIndex    = indexInPage / emoticon.layout.columes;
        coloumnIndex= indexInPage % emoticon.layout.columes;
        CGFloat x = coloumnIndex * emoticon.layout.cellWidth + startX;
        CGFloat y = rowIndex * emoticon.layout.cellHeight + startY;
        CGRect iconRect = CGRectMake(x, y, iconWidth, iconHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
        indexInPage ++;
    }
    if (coloumnIndex == emoticon.layout.columes -1)
    {
        rowIndex = rowIndex +1;
        coloumnIndex = -1; //设置成-1是因为显示在第0位，有加1
    }
    if ([emoticon.catalogID isEqualToString:CTKit_EmojiCatalog]) {
        [self addDeleteEmotButtonToView:subView  ColumnIndex:coloumnIndex RowIndex:rowIndex StartX:startX StartY:startY IconWidth:iconWidth IconHeight:iconHeight inEmoticonCatalog:emoticon];
    }
    return subView;
}

- (void)addDeleteEmotButtonToView:(UIView *)view
                      ColumnIndex:(NSInteger)coloumnIndex
                         RowIndex:(NSInteger)rowIndex
                           StartX:(CGFloat)startX
                           StartY:(CGFloat)startY
                        IconWidth:(CGFloat)iconWidth
                       IconHeight:(CGFloat)iconHeight
                inEmoticonCatalog:(CTInputEmoticonCatalog *)emoticon
{
    CTInputEmoticonButton* deleteIcon = [[CTInputEmoticonButton alloc] init];
    deleteIcon.delegate = self;
    deleteIcon.userInteractionEnabled = YES;
    deleteIcon.exclusiveTouch = YES;
    deleteIcon.contentMode = UIViewContentModeCenter;
    NSString *prefix = CTKit_EmojiPath;
    NSString *imageNormalName = [prefix stringByAppendingPathComponent:@"emoji_del_normal"];
    NSString *imagePressName = [prefix stringByAppendingPathComponent:@"emoji_del_pressed"];
    UIImage *imageNormal  = [UIImage nim_emoticonInKit:imageNormalName];
    UIImage *imagePressed = [UIImage nim_emoticonInKit:imagePressName];
    
    [deleteIcon setImage:imageNormal forState:UIControlStateNormal];
    [deleteIcon setImage:imagePressed forState:UIControlStateHighlighted];
    [deleteIcon addTarget:deleteIcon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat newX = (coloumnIndex +1) * emoticon.layout.cellWidth + startX;
    CGFloat newY = rowIndex * emoticon.layout.cellHeight + startY;
    CGRect deleteIconRect = CGRectMake(newX, newY, CTKit_DeleteIconWidth, CTKit_DeleteIconHeight);
    
    [deleteIcon setFrame:deleteIconRect];
    [view addSubview:deleteIcon];
}


#pragma mark - pageviewDelegate
- (NSInteger)numberOfPages: (NIMPageView *)pageView
{
    return [self sumPages];
}

- (UIView *)pageView:(NIMPageView *)pageView viewInPage:(NSInteger)index
{
    NSInteger page  = 0;
    CTInputEmoticonCatalog *emoticon;
    for (emoticon in self.totalCatalogData) {
        NSInteger newPage = page + emoticon.pagesCount;
        if (newPage > index) {
            break;
        }
        page   = newPage;
    }
    return [self emojPageView:pageView inEmoticonCatalog:emoticon page:index - page];
}


- (CTInputEmoticonCatalog*)loadDefaultCatalog
{
    CTInputEmoticonCatalog *emoticonCatalog = [[CTInputEmoticonManager sharedManager] emoticonCatalog:CTKit_EmojiCatalog];
    if (emoticonCatalog) {
        CTInputEmoticonLayout *layout = [[CTInputEmoticonLayout alloc] initEmojiLayout:self.nim_width];
        emoticonCatalog.layout = layout;
        emoticonCatalog.pagesCount = [self numberOfPagesWithEmoticon:emoticonCatalog];
    }
    return emoticonCatalog;
}


- (NSArray *)loadChartlet{
    NSArray *chatlets = nil;
    if ([self.config respondsToSelector:@selector(charlets)])
    {
        chatlets = [self.config charlets];
        for (CTInputEmoticonCatalog *item in chatlets) {
            CTInputEmoticonLayout *layout = [[CTInputEmoticonLayout alloc] initCharletLayout:self.nim_width];
            item.layout = layout;
            item.pagesCount = [self numberOfPagesWithEmoticon:item];
        }
    }
    return chatlets;
}


//找到某组表情的起始位置
- (NSInteger)pageIndexWithEmoticon:(CTInputEmoticonCatalog *)emoticonCatalog{
    NSInteger pageIndex = 0;
    for (CTInputEmoticonCatalog *emoticon in self.totalCatalogData) {
        if (emoticon == emoticonCatalog) {
            break;
        }
        pageIndex += emoticon.pagesCount;
    }
    return pageIndex;
}

- (NSInteger)pageIndexWithTotalIndex:(NSInteger)index{
    CTInputEmoticonCatalog *catelog = [self emoticonWithIndex:index];
    NSInteger begin = [self pageIndexWithEmoticon:catelog];
    return index - begin;
}

- (CTInputEmoticonCatalog *)emoticonWithIndex:(NSInteger)index {
    NSInteger page  = 0;
    CTInputEmoticonCatalog *emoticon;
    for (emoticon in self.totalCatalogData) {
        NSInteger newPage = page + emoticon.pagesCount;
        if (newPage > index) {
            break;
        }
        page   = newPage;
    }
    return emoticon;
}

- (NSInteger)numberOfPagesWithEmoticon:(CTInputEmoticonCatalog *)emoticonCatalog
{
    if(emoticonCatalog.emoticons.count % emoticonCatalog.layout.itemCountInPage == 0)
    {
        return  emoticonCatalog.emoticons.count / emoticonCatalog.layout.itemCountInPage;
    }
    else
    {
        return  emoticonCatalog.emoticons.count / emoticonCatalog.layout.itemCountInPage + 1;
    }
}

- (void)pageViewScrollEnd: (NIMPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages{
    CTInputEmoticonCatalog *emticon = [self emoticonWithIndex:index];
    self.emotPageController.numberOfPages = [emticon pagesCount];
    self.emotPageController.currentPage = [self pageIndexWithTotalIndex:index];
    
    NSInteger selectTabIndex = [self.totalCatalogData indexOfObject:emticon];
    [self.tabView selectTabIndex:selectTabIndex];
}


#pragma mark - EmoticonButtonTouchDelegate
- (void)selectedEmoticon:(CTInputEmoticon*)emoticon catalogID:(NSString*)catalogID{
    if ([self.delegate respondsToSelector:@selector(selectedEmoticon:catalog:description:)]) {
        [self.delegate selectedEmoticon:emoticon.emoticonID catalog:catalogID description:emoticon.tag];
    }
}

- (void)didPressSend:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didPressSend:)]) {
        [self.delegate didPressSend:sender];
    }
}


#pragma mark - InputEmoticonTabDelegate
- (void)tabView:(CTInputEmoticonTabView *)tabView didSelectTabIndex:(NSInteger) index{
    self.currentCatalogData = self.totalCatalogData[index];
}

#pragma mark - Private

- (void)setCurrentCatalogData:(CTInputEmoticonCatalog *)currentCatalogData{
    _currentCatalogData = currentCatalogData;
    [self.emoticonPageView scrollToPage:[self pageIndexWithEmoticon:_currentCatalogData]];
}

- (void)setTotalCatalogData:(NSArray *)totalCatalogData
{
    _totalCatalogData = totalCatalogData;
    [self.tabView loadCatalogs:totalCatalogData];
}

- (NSArray *)allEmoticons{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CTInputEmoticonCatalog *catalog in self.totalCatalogData) {
        [array addObjectsFromArray:catalog.emoticons];
    }
    return array;
}


#pragma mark - Get
- (CTInputEmoticonTabView *)tabView
{
    if (!_tabView) {
        _tabView = [[CTInputEmoticonTabView alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, 0)];
        _tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabView.delegate = self;
        [_tabView.sendButton addTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tabView];
    
        if (_currentCatalogData.pagesCount > 0) {
            _emotPageController.numberOfPages = [_currentCatalogData pagesCount];
            _emotPageController.currentPage = 0;
        }
    }
    return _tabView;
}

@end

