//
//  TTCarDressUpViewController.m
//  TuTu
//
//  Created by lee on 2018/11/19.
//  Copyright © 2018 YiZhuan. All rights reserved.
//
// 我的座驾

#import "TTCarDressUpViewController.h"
#import "TTDressUpContainViewController.h"
#import "TTMineDressUpContainViewController.h"
// cell
#import "TTCarDressUpCell.h"
#import "TTCarDressUpEmptyCell.h"
#import "TTCarDressReusableViewFooter.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "XCCurrentVCStackManager.h"
#import "TTStatisticsService.h"

// core
#import "UserCore.h"
#import "UserCoreClient.h"
#import "VersionCore.h"
#import "VersionCoreClient.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "CarCore.h"
#import "CarCoreClient.h"
// model
#import "UserCar.h"


@interface TTCarDressUpViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UserCoreClient,
    TTCarDressUpEmptyCellDelegate,
    TTCarDressReusableViewFooterDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *gotoCarDressShopBtn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<UserCar *> *dataArray;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) UserCar  *currentSelectCar;//

@end

@implementation TTCarDressUpViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(UserCoreClient, self);
    
    // 获取个人座驾
    [GetCore(CarCore) requestUserCar:UserCarPlaceTypeUserInfo uid:[NSString stringWithFormat:@"%lld",self.userID]];
    [self initViews];
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *des = self.mineInfoStyle == TTMineInfoViewStyleDefault ? @"个人主页主态页" : @"个人主页客态页";
    [TTStatisticsService trackEvent:@"homepage_car" eventDescribe:des];
}

// 隐藏导航栏
- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self baseUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.titleLabel];
    [self.collectionView addSubview:self.countLabel];
}

- (void)initConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(0);
        }
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
}

- (void)baseUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(40, 15, 15, 15);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[TTCarDressUpCell class] forCellWithReuseIdentifier:NSStringFromClass([TTCarDressUpCell class])];
    [collectionView registerClass:[TTCarDressUpEmptyCell class] forCellWithReuseIdentifier:NSStringFromClass([TTCarDressUpEmptyCell class])];
    [collectionView registerClass:[TTCarDressReusableViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([TTCarDressReusableViewFooter class])];
    
    self.collectionView  = collectionView;
}

#pragma mark -
#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count) {
        TTCarDressUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTCarDressUpCell class]) forIndexPath:indexPath];
        cell.isPerson = YES;
        if (self.dataArray.count > indexPath.item) {
            [cell setCar:self.dataArray[indexPath.item]];
        }
        return cell;
    }
    
    TTCarDressUpEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTCarDressUpEmptyCell class]) forIndexPath:indexPath];
    cell.emptyStyle = self.mineInfoStyle;
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count) {
        return CGSizeMake((KScreenWidth - 45) * 0.5, 120);
    }
    return CGSizeMake(KScreenWidth, 250); // 占位图显示
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (!(self.dataArray.count > indexPath.item)) {
        return;
    }
    // do somethings
    if (self.userID == [GetCore(AuthCore).getUid longLongValue]) {
        // 去座驾商城
        TTDressUpContainViewController *vc = [[TTDressUpContainViewController alloc] init];
        vc.place = 1; // 0.头饰 1 座驾
        vc.userID = self.userID;
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (_mineInfoStyle == TTMineInfoViewStyleOhter) {
        if (self.dataArray.count) {
            return CGSizeMake(KScreenWidth, 50 + 84 + kSafeAreaBottomHeight);
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TTCarDressReusableViewFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TTCarDressReusableViewFooter class]) forIndexPath:indexPath];
        footer.delegate = self;
        reusableView = footer;
    }
    return reusableView;
}

#pragma mark -
#pragma mark TTCarDressUpEmptyCellDelegate
- (void)onCellBtnClickAction:(UIButton *)btn {
    
    // 去座驾商城
    TTDressUpContainViewController *vc = [[TTDressUpContainViewController alloc] init];
    vc.place = 1; // 0.头饰 1 座驾
    vc.userID = self.userID;
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
}

- (void)gotoCarDressShopClick:(UIButton *)btn {
    [self onCellBtnClickAction:btn];
}

#pragma mark -
#pragma mark clients
- (void)onGetOwnCarList:(UserCarPlaceType)placeType success:(NSArray *)list {
    if (placeType != UserCarPlaceTypeUserInfo)return;
    
    NSMutableArray *originArray = list.mutableCopy;
    
    self.dataArray = originArray.copy;
    self.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)self.dataArray.count];
    
    [self.collectionView reloadData];
}

- (void)onGetOwnCarList:(UserCarPlaceType)placeType failth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark -
#pragma mark private methods
#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"座驾";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _countLabel.font = [UIFont systemFontOfSize:13.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _countLabel;
}

@end
