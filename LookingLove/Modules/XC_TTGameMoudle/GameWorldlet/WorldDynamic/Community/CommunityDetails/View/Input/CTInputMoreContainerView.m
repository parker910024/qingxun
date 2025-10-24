//
//  NTESInputMoreContainerView.m
//  CTDemo
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CTInputMoreContainerView.h"
#import "NIMPageView.h"
#import "NIMMediaItem.h"
#import "UIView+NIM.h"
#import "NIMKit.h"

NSInteger CTMaxItemCountInPage = 8;
NSInteger CTButtonItemWidth = 75;
NSInteger CTButtonItemHeight = 85;
NSInteger CTPageRowCount     = 2;
NSInteger CTPageColumnCount  = 4;
NSInteger CTButtonBegintLeftX = 11;




@interface CTInputMoreContainerView() <NIMPageViewDataSource,NIMPageViewDelegate>
{
    NSArray                 *_mediaButtons;
    NSArray                 *_mediaItems;
}

@property (nonatomic, strong) NIMPageView *pageView;

@end

@implementation CTInputMoreContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageView = [[NIMPageView alloc] initWithFrame:CGRectZero];
        _pageView.dataSource = self;
        [self addSubview:_pageView];
    }
    return self;
}

- (void)setConfig:(id<NIMSessionConfig>)config
{
    _config = config;
    [self genMediaButtons];
    [self.pageView reloadData];
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 216.f);
}


- (void)genMediaButtons
{
    NSMutableArray *mediaButtons = [NSMutableArray array];
    NSMutableArray *mediaItems = [NSMutableArray array];
    NSArray *items;
    if (!self.config)
    {
        items = [NIMKit sharedKit].config.defaultMediaItems;
    }
    else if([self.config respondsToSelector:@selector(mediaItems)])
    {
        items = [self.config mediaItems];
    }
    [items enumerateObjectsUsingBlock:^(NIMMediaItem *item, NSUInteger idx, BOOL *stop) {
        [mediaItems addObject:item];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = idx;
        [btn setImage:item.normalImage forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateHighlighted];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 23, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(76, -23, 0, 0)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [mediaButtons addObject:btn];

    }];
    _mediaButtons = mediaButtons;
    _mediaItems = mediaItems;
}

- (void)setFrame:(CGRect)frame{
    CGFloat originalWidth = self.frame.size.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width)
    {
        self.pageView.frame = self.bounds;
        [self.pageView reloadData];
    }
}

- (void)dealloc
{
    _pageView.dataSource = nil;
}


#pragma mark PageViewDataSource
- (NSInteger)numberOfPages: (NIMPageView *)pageView
{
    NSInteger count = [_mediaButtons count] / CTMaxItemCountInPage;
    count = ([_mediaButtons count] % CTMaxItemCountInPage == 0) ? count: count + 1;
    return MAX(count, 1);
}

- (UIView*)mediaPageView:(NIMPageView*)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (self.nim_width - CTPageColumnCount * CTButtonItemWidth) / (CTPageColumnCount +1);
    CGFloat startY          = CTButtonBegintLeftX;
    NSInteger coloumnIndex = 0;
    NSInteger rowIndex = 0;
    NSInteger indexInPage = 0;
    for (NSInteger index = begin; index < end; index ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:index];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        //计算位置
        rowIndex    = indexInPage / CTPageColumnCount;
        coloumnIndex= indexInPage % CTPageColumnCount;
        CGFloat x = span + (CTButtonItemWidth + span) * coloumnIndex;
        CGFloat y = 0.0;
        if (rowIndex > 0)
        {
            y = rowIndex * CTButtonItemHeight + startY + 15;
        }
        else
        {
            y = rowIndex * CTButtonItemHeight + startY;
        }
        [button setFrame:CGRectMake(x, y, CTButtonItemWidth, CTButtonItemHeight)];
        [subView addSubview:button];
        indexInPage ++;
    }
    return subView;
}

- (UIView*)oneLineMediaInPageView:(NIMPageView *)pageView
                       viewInPage: (NSInteger)index
                            count:(NSInteger)count
{
    UIView *subView = [[UIView alloc] init];
    NSInteger span = (self.nim_width - count * CTButtonItemWidth) / (count +1);
    
    for (NSInteger btnIndex = 0; btnIndex < count; btnIndex ++)
    {
        UIButton *button = [_mediaButtons objectAtIndex:btnIndex];
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect iconRect = CGRectMake(span + (CTButtonItemWidth + span) * btnIndex, 58, CTButtonItemWidth, CTButtonItemHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
    }
    return subView;
}

- (UIView *)pageView: (NIMPageView *)pageView viewInPage: (NSInteger)index
{
    if ([_mediaButtons count] == 2 || [_mediaButtons count] == 3) //一行显示2个或者3个
    {
        return [self oneLineMediaInPageView:pageView viewInPage:index count:[_mediaButtons count]];
    }
    
    if (index < 0)
    {
        assert(0);
        index = 0;
    }
    NSInteger begin = index * CTMaxItemCountInPage;
    NSInteger end = (index + 1) * CTMaxItemCountInPage;
    if (end > [_mediaButtons count])
    {
        end = [_mediaButtons count];
    }
    return [self mediaPageView:pageView beginItem:begin endItem:end];
}

#pragma mark - button actions
- (void)onTouchButton:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];
    NIMMediaItem *item = _mediaItems[index];
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onTapMediaItem:)]) {
        BOOL handled = [_actionDelegate onTapMediaItem:item];
        if (!handled) {
            NSAssert(0, @"invalid item selector!");
        }
    }
    
}

@end
