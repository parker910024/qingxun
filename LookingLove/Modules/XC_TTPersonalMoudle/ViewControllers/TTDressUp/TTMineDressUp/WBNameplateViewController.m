//
//  WBNameplateViewController.m
//  WanBan
//
//  Created by ShenJun_Mac on 2020/9/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "WBNameplateViewController.h"
#import "WBNameplateCollectionViewCell.h"
#import "WBMakeNameplateAlertView.h"

#import "Masonry.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+XCToast.h"
#import "NSArray+Safe.h"
#import "XCHUDTool.h"

#import "CarCore.h"

@interface WBNameplateViewController () <UICollectionViewDelegate,UICollectionViewDataSource,WBNameplateCollectionViewCellDelegate>
@property (nonatomic, strong) NSMutableArray  *dataSource;// 数据
@end

@implementation WBNameplateViewController
- (void)dealloc {
   // RemoveCoreClient(UserCoreClient, self);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    AddCoreClient(UserCoreClient, self);
    [self initViews];
    [self initContrations];
    // Do any additional setup after loading the view.
}

- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



- (void)initViews {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewHeightOnScreen = 1;
    [self.collectionView registerClass:[WBNameplateCollectionViewCell class] forCellWithReuseIdentifier:@"WBNameplateCollectionViewCell"];
    
    [self setupRefreshTarget:self.collectionView];
    [self pullDownRefresh:1];
}

- (void)initContrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 30), 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0,15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WBNameplateCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBNameplateCollectionViewCell" forIndexPath:indexPath];
    cell.model = [self.dataSource safeObjectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
}

#pragma mark - WBNameplateCollectionViewCellDelegate
- (void)onMakeButtonClicked:(WBUserNameplate *)model {
    if (model.used == 0) {//0 -- 未使用,
        [GetCore(CarCore) requestUseNameplate:model.nameplateId used:1];
    } else if (model.used == 1) {//1 -- 使用中,
        [GetCore(CarCore) requestUseNameplate:model.nameplateId used:0];
    } else if (model.used == 2) { //2 --待制作,
        WBMakeNameplateAlertView *alert = [[WBMakeNameplateAlertView alloc] init];
        alert.title = @"制作名牌";
        //alert.placeholder = @"请输入铭牌字样，最多不超过4个字";
        alert.maxCount = 4;
        alert.url = model.iconPic;
        [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
           [GetCore(CarCore) requestMakeNameplate:model.nameplateId fixedWord:content];
        } dismiss:^{
        }];
    }
}

#pragma mark - Event
- (void)pullDownRefresh:(int)page {
    [super pullDownRefresh:page];
    [GetCore(CarCore) requestNameplateListByPage:[NSString stringWithFormat:@"%d",page] pageSize:@"20" state:0];
}
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    [super pullUpRefresh:page lastPage:isLastPage];
    [GetCore(CarCore) requestNameplateListByPage:[NSString stringWithFormat:@"%d",page] pageSize:@"20" state:1];
}

- (void)onUseNameplateSuccess:(BOOL)success used:(NSInteger)used {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedRefreshUserInfoNotification object:nil];
    if (used == 0) {
        [XCHUDTool showErrorWithMessage:@"取消佩戴！"];
    } else if (used == 1) {
        [XCHUDTool showErrorWithMessage:@"佩戴成功！"];
    }
    [self pullDownRefresh:1];
}

- (void)onUseNameplateFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

#pragma mark - UserCoreClient
- (void)onGetNameplateListSuccess:(NSArray *)list state:(int)state {
    if (list.count == 0) {
        if (state == 0) {
            [self.collectionView showEmptyContentToastWithTitle:@"不会吧不会吧？我还没有铭牌？？" andImage:[UIImage imageNamed:[XCTheme defaultTheme].default_empty]];
        }
        [self successEndRefreshStatus:state hasMoreData:NO];
    }else {
        [self.collectionView hideToastView];
        if (state == 0) {
            self.dataSource = [list mutableCopy];
         
        }else {
            [self.dataSource addObjectsFromArray:list];
        }
        [self successEndRefreshStatus:state hasMoreData:YES];
    }
    [self.collectionView reloadData];
}

- (void)onGetNameplateListFailth:(NSString *)message {
     [self.collectionView showEmptyContentToastWithTitle:@"不会吧不会吧？我还没有铭牌？？" andImage:[UIImage imageNamed:[XCTheme defaultTheme].default_empty]];
}

- (void)onMakeNameplateSuccess:(BOOL)success {
    
    [self pullDownRefresh:1];
}

- (void)onMakeNameplateFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

#pragma mark - Setter && Geter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
