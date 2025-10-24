//
//  TTGuildIncomeDetailsViewController.m
//  TuTu
//
//  Created by lee on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeDetailsViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
// view
#import "TTGuildUserInfoView.h"
#import "TTGuildIncomeDetailsCell.h"
// core
#import "GuildCore.h"
#import "GuildCoreClient.h"
// model
#import "GuildIncomeTotal.h"
// tool
@interface TTGuildIncomeDetailsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GuildCoreClient>
@property (nonatomic, strong) TTGuildUserInfoView *infoView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<GuildIncomeDetail *> *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation TTGuildIncomeDetailsViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initViews];
    [self initConstraints];
    
    self.page = 1;
    self.navigationItem.title = @"收入明细";
    
    AddCoreClient(GuildCoreClient, self);
    [GetCore(GuildCore) requestGuildIncomeDetailWithHallId:GetCore(GuildCore).hallInfo.hallId memberId:@(self.totalInfo.reciveUid).stringValue startTimeStr:self.startTime endTimeStr:self.endTime];
   
    UserInfo *info = [UserInfo new];
    info.nick = self.totalInfo.nick;
    info.avatar = self.totalInfo.avatar;
    self.infoView.info = info;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.collectionView];
}

- (void)initConstraints {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.infoView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark collectionView delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGuildIncomeDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuildIncomeDetailsConst forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.item) {
        cell.detailModel = self.dataArray[indexPath.item];
    }
    return cell;
}

#pragma mark -
#pragma mark clients
- (void)responseGuildIncomeDetailList:(NSArray<GuildIncomeDetail *> *)list errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (_page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:list];
        if (self.dataArray.count == 0) {
            self.collectionView.emptyViewInteractionEnabled = YES;
            [self.collectionView showEmptyContentToastWithTitle:@"暂时没有数据哦" andImage:[UIImage imageNamed:@"common_noData_empty"]];
        } else {
            [self.collectionView hideToastView];
        }
    } else {
        [self.dataArray addObjectsFromArray:list];
    }
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 15;
        CGFloat itemSpeace = 10;
        CGFloat itemWidth = (KScreenWidth - margin * 2 - itemSpeace * 2) / 3;
        CGFloat itemHeight = itemWidth + 58;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        flowLayout.minimumInteritemSpacing = itemSpeace;
        flowLayout.minimumLineSpacing = itemSpeace;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TTGuildIncomeDetailsCell class] forCellWithReuseIdentifier:kGuildIncomeDetailsConst];
    }
    return _collectionView;
}

- (TTGuildUserInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[TTGuildUserInfoView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, KScreenWidth, 70)];
    }
    return _infoView;
}

- (NSMutableArray<GuildIncomeDetail *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
