//
//  XCGameRoomFaceContainerCell.m
//  XChat
//
//  Created by 卫明何 on 2017/12/12.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCGameRoomFaceContainerCell.h"
#import "XCGameRoomFaceCell.h"
#import "XCFaceViewKitProtocol.h"
#import "FaceConfigInfo.h"

//core
#import "FaceCore.h"
#import "AuthCore.h"
#import "UserCore.h"

//client
#import "RoomQueueCoreClient.h"

//m
#import "UserInfo.h"

//tool
#import "XCAlertControllerCenter.h"
#import "TTPopup.h"

//theme
#import "XCTheme.h"

//3rd part
#import <Masonry/Masonry.h>

//const
#import "XCMacros.h"


@interface XCGameRoomFaceContainerCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
RoomQueueCoreClient
>

@property (nonatomic, strong)  UserInfo *userInfo;
@property (nonatomic, strong)  NSIndexPath *currentIndexPath;
@end

@implementation XCGameRoomFaceContainerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self addCore];
    }
    return self;
}

- (void)initView {
    [[GetCore(UserCore) getUserInfoByUid:GetCore(AuthCore).getUid.userIDValue refresh:NO] subscribeNext:^(id x) {
        self.userInfo = (UserInfo *)x;
    }];
    [self.collectionView registerClass:[XCGameRoomFaceCell class] forCellWithReuseIdentifier:@"XCGameRoomFaceCell"];
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)addCore {
    AddCoreClient(RoomQueueCoreClient, self);
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    FaceConfigInfo *info = [self.faceInfos safeObjectAtIndex:indexPath.row];
    if (info.isNobleFace && (self.userInfo.nobleUsers.level < info.nobleId)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nobleFaceNoPermissionForLevel:needLevel:)]) {
            [self.delegate nobleFaceNoPermissionForLevel:self.userInfo.nobleUsers.level needLevel:info.nobleId];
        }
        return;
    }
    
    if (![GetCore(FaceCore) getShowingFace]) {
        [GetCore(FaceCore) sendFace:info];
        if (projectType() == ProjectType_Pudding ||
            projectType() == ProjectType_TuTu ||
            projectType() == ProjectType_Planet) {
            [TTPopup dismiss];
        } else {
            [[XCAlertControllerCenter defaultCenter]dismissAlertNeedBlock:NO];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.faceInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XCGameRoomFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCGameRoomFaceCell" forIndexPath:indexPath];
    [self configureCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(XCGameRoomFaceCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FaceConfigInfo *info = self.faceInfos[indexPath.row];
    //读取图片
    UIImage *face = [GetCore(FaceCore) findFaceIconImageById:info.id];
    [cell.faceImageView setImage:face];
    [cell.faceName setText:info.name];
 
    if (info.nobleId>0) {
        cell.nobleTagImageView.hidden = NO;
        cell.nobleTagImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"room_noble_gift_%d",info.nobleId]];
    }else{
        cell.nobleTagImageView.hidden = YES;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.frame.size.width - 20) / 5, self.frame.size.height / 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (void)setFaceInfos:(NSMutableArray<FaceConfigInfo *> *)faceInfos{
    _faceInfos = faceInfos;
    [self.collectionView reloadData];
}


#pragma mark - RoomQueueCoreClient
- (void)onMicroQueueUpdate:(NSMutableDictionary *)micQueue{
    [[GetCore(UserCore) getUserInfoByUid:GetCore(AuthCore).getUid.userIDValue refresh:NO] subscribeNext:^(id x) {
        self.userInfo = (UserInfo *)x;
    }];
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


@end
