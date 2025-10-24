//
//  LLGameHomeEntranceView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/27.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLGameHomeEntranceView.h"

#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "UIImageView+QiNiu.h"

#import "BannerInfo.h"

static NSString *const kCellId = @"kCellId";

@interface LLGameHomeEntranceView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) CGFloat LLGameHomeEntranceViewHeight; ///卡片入口高度
@property (nonatomic, assign) CGFloat kCellWidth; ///cell宽度
// scale 值(默认是1);
@property (nonatomic, assign) CGFloat minScale;
@end

@implementation LLGameHomeEntranceView
#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark -
#pragma mark CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLGameHomeEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    if (self.bannerArray.count > indexPath.item) {
        cell.bannerInfo = self.bannerArray[indexPath.item];
    }
    
    @weakify(self)
    cell.effectAreaActionBlock = ^(BannerInfo * _Nonnull bannerInfo) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(entranceView:didSelectItemWithInfo:)]) {
            [self.delegate entranceView:self didSelectItemWithInfo:bannerInfo];
        }
    };
    return cell;
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods
- (void)scaleViewTransformValue:(CGFloat)minValue {
    
    // scale 值最大为 1， 不能超出它本身的最大值。
    if (minValue >= 1) {
        minValue = 1;
    }
    
    // 遍历所有 cell ，然后进行 scale
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LLGameHomeEntranceCell class]]) {
            LLGameHomeEntranceCell * cell = (LLGameHomeEntranceCell *)obj;
            [cell scaleCellMin:minValue];
        }
    }];
}
#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters
- (void)setBannerArray:(NSArray<BannerInfo *> *)bannerArray {
    _bannerArray = bannerArray;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        if (projectType() == ProjectType_LookingLove) {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.minimumLineSpacing = -28;
            self.kCellWidth = 130.0f;
            self.LLGameHomeEntranceViewHeight = 110.f;
            flowLayout.itemSize = CGSizeMake(self.kCellWidth, self.LLGameHomeEntranceViewHeight);
        } else if (projectType() == ProjectType_Planet) {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 9, 0, 9);
            flowLayout.minimumLineSpacing = 8;
            self.kCellWidth = 75.0f;
            self.LLGameHomeEntranceViewHeight = 87.f;
            flowLayout.itemSize = CGSizeMake(self.kCellWidth, self.LLGameHomeEntranceViewHeight);
        }
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[LLGameHomeEntranceCell class] forCellWithReuseIdentifier:kCellId];
    }
    return _collectionView;
}

@end



@interface LLGameHomeEntranceCell ()
/** 卡片图片 */
@property (nonatomic, strong) UIImageView *cardImageView;

/**
 有效点击区域，白色底色区域，90*70
 
 因为 cell 有重叠部分，不能直接使用 didSelectItemAtIndexPath 方法处理点击
 使用 hitTest:withEvent: 获取响应映射在此控件内的事件
 */
@property (nonatomic, strong) UIControl *effectAreaControl;

@end

@implementation LLGameHomeEntranceCell

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *receiverView = [super hitTest:point withEvent:event];
    
    //不在容器内，不处理
    if (![self pointInside:point withEvent:event]) {
        return receiverView;
    }
    
    for (UIView *view in self.subviews) {//view is self.contentView
        
        for (UIView *subView in view.subviews) {
            
            //忽略隐藏视图，和关闭交互视图
            if (subView.isHidden || subView.userInteractionEnabled) {
                continue;
            }
            
            //将触控点投射到当前筛选的视图控件
            CGPoint pointInSubview = [self convertPoint:point toView:subView];
            
            //触控点投射下寻找子视图控件
            if (CGRectContainsPoint(subView.frame, pointInSubview)) {
                if ([subView isKindOfClass:[UIControl class]]) {
                    return subView;
                }
            }
        }
    }
    
    return receiverView;
}

- (void)initViews {
    [self.contentView addSubview:self.cardImageView];
    [self.contentView addSubview:self.effectAreaControl];
}

- (void)initConstraints {
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.effectAreaControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(70);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods
- (void)scaleCellMin:(CGFloat)minValue {
    
    if (minValue > 1) {
        return;
    }
    [UIView animateWithDuration:0.1 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cardImageView.transform = CGAffineTransformMakeScale(minValue, minValue);
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -
#pragma mark Private Methods
- (void)effectAreaControlHandle {
    
    !self.effectAreaActionBlock ?: self.effectAreaActionBlock(self.bannerInfo);
}

#pragma mark -
#pragma mark Getters and Setters
- (void)setBannerInfo:(BannerInfo *)bannerInfo {
    if (![bannerInfo isKindOfClass:[BannerInfo class]]) {
        return;
    }
    _bannerInfo = bannerInfo;
    
    [self.cardImageView qn_setImageImageWithUrl:bannerInfo.bannerPic placeholderImage:nil type:ImageTypeBottomBanners];
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_home_test_card"]];
    }
    return _cardImageView;
}

- (UIControl *)effectAreaControl {
    if (!_effectAreaControl) {
        _effectAreaControl = [[UIControl alloc] init];
        [_effectAreaControl addTarget:self action:@selector(effectAreaControlHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effectAreaControl;
}

@end
