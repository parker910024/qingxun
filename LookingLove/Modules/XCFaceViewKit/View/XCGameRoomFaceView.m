//
//  XCGameRoomFaceView.m
//  XChat
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCGameRoomFaceView.h"
#import "XCGameRoomFaceCell.h"
#import "XCGameRoomFaceContainerCell.h"
#import "XCGameRoomFaceTitleCell.h"

//core
#import "FaceCore.h"
#import "VersionCore.h"

//client
#import "FaceSourceClient.h"

//model
#import "FaceInfo.h"
#import "FaceConfigInfo.h"
#import "AuthCore.h"
#import "UserCore.h"
#import "UserInfo.h"

//tool
#import "UIView+XCToast.h"
#import "NSArray+Safe.h"

//3rd
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

//displayModel
#import "XCGameRoomFaceViewDisplayModel.h"
#import "XCMacros.h"

@interface XCGameRoomFaceView()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate,
    FaceSourceClient
>

/**
 显示用模型
 */
@property (strong, nonatomic) XCGameRoomFaceViewDisplayModel *displayModel;

/**
 翻页控件
 */
@property (strong, nonatomic) UIPageControl *pageControl;

/**
 标题collection
 */
@property (strong, nonatomic) UICollectionView *titlesCollectionView;

/**
 高斯模糊view
 */
@property (strong, nonatomic) UIVisualEffectView *effectView;

/**
 如果displayType为展示Noble 这个view就会显示出来
 */
@property (strong, nonatomic) UIView *tabBarView;

/**
 选中的表情类型
 */
@property (nonatomic,assign) RoomFaceType selectedFaceType;

/**
 选中的indexpath
 */
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

/**
 当前用户信息
 */
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation XCGameRoomFaceView

- (instancetype)initWithFrame:(CGRect)frame WithDisplayModel:(XCGameRoomFaceViewDisplayModel *)displayMode {
    if (self = [super initWithFrame:frame]) {
        NSAssert(displayMode, @"displayMode can not be nil");
        self.displayModel = displayMode;
        [self initView];
        [self addCore];
        [self initConstrations];
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.titlesCollectionView) {
        return 1;
    }else if (collectionView == self.faceCollectionView) {
        return self.faceInfos.count;
    }else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.titlesCollectionView) {
        return self.displayModel.titles.count;
    }else if (collectionView == self.faceCollectionView) {
        return 1;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if (collectionView == self.titlesCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCGameRoomFaceTitleCell" forIndexPath:indexPath];
    }else if (collectionView == self.faceCollectionView){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCGameRoomFaceContainerCell" forIndexPath:indexPath];
    }
    
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[XCGameRoomFaceTitleCell class]]) {
        XCGameRoomFaceTitleDisplayModel *displayModel = [self.displayModel.titles safeObjectAtIndex:indexPath.row];
        if (indexPath == self.selectedIndexPath) {
            displayModel.isSelected = YES;
        }else {
            displayModel.isSelected = NO;
        }
        ((XCGameRoomFaceTitleCell *)cell).displayModel = [self.displayModel.titles safeObjectAtIndex:indexPath.row];
    }else if ([cell isKindOfClass:[XCGameRoomFaceContainerCell class]]) {
        ((XCGameRoomFaceContainerCell *)cell).faceInfos = [self.faceInfos safeObjectAtIndex:indexPath.section];
        ((XCGameRoomFaceContainerCell *)cell).delegate = self.delegate;
    }
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.faceCollectionView) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 190);
    }else if (collectionView == self.titlesCollectionView) {
        if (projectType() == ProjectType_CeEr ||
            projectType() == ProjectType_LookingLove) {
            return CGSizeMake(70, 40);
        } else {
            return CGSizeMake(95, 40);
        }
    }else {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titlesCollectionView) {
        XCGameRoomFaceTitleDisplayModel *displayModel = [self.displayModel.titles safeObjectAtIndex:indexPath.row];
        if (self.selectedIndexPath != indexPath) {
            self.selectedIndexPath = indexPath;
            self.selectedFaceType = displayModel.type;
            [self.titlesCollectionView reloadData];
            
            [self loadFace];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    int intPage = (int)(doublePage + 0.5);
    self.pageControl.currentPage = intPage;
}

#pragma mark - FaceSourceClient

- (void)loadFaceSourceSuccess {
    [self loadFace];
}

#pragma mark - Event


#pragma mark - private method

- (void)initView {
    
    NSAssert(self.displayModel, @"displayMode can not be nil");
    
    [self addSubview:self.effectView];
    if (self.displayModel.displayType == XCGameRoomFaceViewDisplayType_Noble) {
        [self addSubview:self.tabBarView];
        [self.tabBarView addSubview:self.titlesCollectionView];
        self.selectedFaceType = RoomFaceTypeNormal;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self addSubview:self.faceCollectionView];
    [self addSubview:self.pageControl];
    
    [self.titlesCollectionView registerClass:[XCGameRoomFaceTitleCell class] forCellWithReuseIdentifier:@"XCGameRoomFaceTitleCell"];
    [self.faceCollectionView registerClass:[XCGameRoomFaceCell class] forCellWithReuseIdentifier:@"XCGameRoomFaceCell"];
    [self.faceCollectionView registerClass:[XCGameRoomFaceContainerCell class] forCellWithReuseIdentifier:@"XCGameRoomFaceContainerCell"];
    
    if (GetCore(FaceCore).isLoadFace) {
        [self loadFace];
    }else {
        [UIView showToastInKeyWindow:@"表情准备中" duration:3.0 position:(YYToastPosition)YYToastPositionBottomWithRecordButton];
    }
}

- (void)initConstrations {
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    if (self.displayModel.displayType == XCGameRoomFaceViewDisplayType_Noble) {
        [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.top.mas_equalTo(self.mas_top);
            make.height.mas_equalTo(40);
        }];
        [self.titlesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tabBarView.mas_leading);
            make.trailing.mas_equalTo(self.tabBarView.mas_trailing);
            make.top.mas_equalTo(self.tabBarView.mas_top);
            make.bottom.mas_equalTo(self.tabBarView.mas_bottom);
        }];
        [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.top.mas_equalTo(self.tabBarView.mas_bottom);
            make.bottom.mas_equalTo(self.pageControl.mas_top);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }else {
        [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.bottom.mas_equalTo(self.pageControl.mas_top);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
}

- (void)addCore{
    AddCoreClient(FaceSourceClient, self);
}

- (void)loadFace {
    
    if (self.selectedFaceType == RoomFaceTypeNoble) {
        
        //如果没有贵族，默认只显示男爵表情，因为没有枚举，这里 hard code =1
        __block NSUInteger nobleLevel = 1;
        
        if (self.userInfo == nil) {
            [[GetCore(UserCore) getUserInfoByUid:GetCore(AuthCore).getUid.userIDValue refresh:NO] subscribeNext:^(id x) {
                if ([x isKindOfClass:UserInfo.class]) {
                    self.userInfo = x;
                    
                    if (self.userInfo.nobleUsers) {
                        nobleLevel = self.userInfo.nobleUsers.level;
                    }
                }
                
                self.faceInfos = [[self nobleFaceFilterByNobleLevel:nobleLevel] mutableCopy];
                self.pageControl.hidden = NO;
                self.pageControl.numberOfPages = self.faceInfos.count;
                [self.faceCollectionView reloadData];
            }];
            
            return;
        }
        
        if (self.userInfo.nobleUsers) {
            nobleLevel = self.userInfo.nobleUsers.level;
        }
        
        self.faceInfos = [[self nobleFaceFilterByNobleLevel:nobleLevel] mutableCopy];
        
    }else{
        self.faceInfos = [GetCore(FaceCore) getFaceInfosType:RoomFaceTypeNormal];
    }
    
    self.pageControl.hidden = NO;
    self.pageControl.numberOfPages = self.faceInfos.count;
    [self.faceCollectionView reloadData];
}


/**
 根据贵族等级筛选贵族表情，只获取不大于当前等级的表情

 @param level 当前用户贵族等级
 @discussion 如果没有贵族等级，则默认获取最低贵族男爵的表情，这里 hard code =1
 @return 贵族表情列表
 */
- (NSArray<FaceConfigInfo *> *)nobleFaceFilterByNobleLevel:(NSUInteger)level {
    NSArray *faces = [[[GetCore(FaceCore) getFaceInfosType:RoomFaceTypeNoble] copy] firstObject];
    if (faces.count == 0) {
        return @[];
    }
    
    //默认获取最低贵族男爵
    if (level < 1) {
        level = 1;
    }
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (FaceConfigInfo *face in faces) {
        if (face.nobleId <= level) {
            [mArray addObject:face];
        }
    }
    
    NSArray *conbineArray = @[];
    if (mArray.count > 0) {
        conbineArray = @[[mArray copy]];
    }
    return conbineArray;
}

#pragma mark - Getter & Setter

- (UICollectionView *)titlesCollectionView {
    if (!_titlesCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if (projectType() == ProjectType_CeEr |
            projectType() == ProjectType_LookingLove) {
            flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        
        _titlesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _titlesCollectionView.delegate = self;
        _titlesCollectionView.dataSource = self;
        _titlesCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _titlesCollectionView;
}

- (UICollectionView *)faceCollectionView {
    if (!_faceCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _faceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _faceCollectionView.delegate = self;
        _faceCollectionView.dataSource = self;
        _faceCollectionView.pagingEnabled = YES;
        _faceCollectionView.backgroundColor = [UIColor clearColor];
        _faceCollectionView.showsVerticalScrollIndicator = NO;
        _faceCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _faceCollectionView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _effectView.alpha = 1;
    }
    return _effectView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[UIView alloc]init];
        _tabBarView.backgroundColor = UIColorRGBAlpha(0x000000, 0.2);
    }
    return _tabBarView;
}

- (void)setDisplayModel:(XCGameRoomFaceViewDisplayModel *)displayModel {
    _displayModel = displayModel;
    if (displayModel.displayType == XCGameRoomFaceViewDisplayType_Noble) {
   
        NSAssert(displayModel.titles.count > 0, @"if displayType is XCGameRoomFaceViewDisplayType_Noble,titles property can not be nil");
        self.titlesCollectionView.hidden = NO;
        self.frame = CGRectMake(0, 0, KScreenWidth, 274);
    }else if (displayModel.displayType == XCGameRoomFaceViewDisplayType_normal_corner) {
        self.titlesCollectionView.hidden = YES;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        self.frame = CGRectMake(0, 0, KScreenWidth, 234);
    }
}

@end
