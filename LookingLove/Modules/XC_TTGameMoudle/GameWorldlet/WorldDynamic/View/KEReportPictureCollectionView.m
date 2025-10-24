//
//  XCPutPictureCollectionView.m
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "KEReportPictureCollectionView.h"
#import "KEReportPictureCell.h"
#import "XCMediaFetcher.h"
#import "SDPhotoBrowser.h"
#import "UIView+NTES.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface KEReportPictureCollectionView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
KEReportPictureCellDelegate,
SDPhotoBrowserDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
//选择图片对象
@property (nonatomic, strong) XCMediaFetcher *mediaFetcher;
///记录已经选中的图片
@property (nonatomic, strong) NSMutableArray *selectedAssets;
///图片数组
@property (nonatomic, strong) NSMutableArray *imagesArr;
///浏览图片控件
@property (nonatomic, weak) SDPhotoBrowser *photoBrowser;

@end

@implementation KEReportPictureCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[KEReportPictureCell class] forCellWithReuseIdentifier:KEReportPictureCellIdentifier];
}

- (void)addPhotoActions {
    self.mediaFetcher.selectedAssets = self.selectedAssets;
    //发送图片
    __weak typeof(self) weakSelf = self;
    [self.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images,NSMutableArray *selectedAssets, NSString *path, PHAssetMediaType type) {
        weakSelf.selectedAssets = selectedAssets;
        self.imagesArr =  [NSMutableArray arrayWithArray:images];
        [self updateImageArr];
        [self.collectionView reloadData];
    }];
}

#pragma mark UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.imagesArr.count < 6 ? self.imagesArr.count + 1 : self.imagesArr.count;
    return count;
//    return self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KEReportPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KEReportPictureCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.imagesArr.count) {
        cell.image = self.imagesArr[indexPath.row];
    }
    else {
        cell.image = nil;
    }
    //给cell赋值
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(itemWH,itemWH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSInteger index= indexPath.row;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    self.photoBrowser = browser;
    browser.sourceImagesContainerView = self.collectionView;
    browser.delegate = self;
    browser.imageCount = self.imagesArr.count;
    browser.currentImageIndex = index;
    [browser show];
}


#pragma mark SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return self.imagesArr[index];
}

#pragma mark XCPutPictureCellDelegate

- (void)addPhotoCallBack {
    [self addPhotoActions];
}

- (void)deletePhotoCallBackWithCell:(KEReportPictureCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.imagesArr removeObjectAtIndex:indexPath.row];
    [self.selectedAssets removeObjectAtIndex:indexPath.row];
    if (self.imagesArr.count == 5) {
        [self.collectionView reloadData];
    }else {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    [self updateImageArr];
}

- (void)updateImageArr {
    NSInteger imgCount = self.imagesArr.count;
    if (self.imagesArr.count < 6) {
        imgCount += 1;
    }
    NSInteger row = ceil(imgCount / 3.f);
    self.collectionView.height = MAX(row * itemWH, itemWH);
    if (row == 2) self.collectionView.height += 23;
    self.pictureCollectionHeight = self.collectionView.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePhotoDataCallBaccWith:)]) {
        [self.delegate updatePhotoDataCallBaccWith:self.imagesArr];
    }
}

#pragma mark - getters and setters

- (CGFloat)pictureCollectionHeight {
    return self.collectionView.height;
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, itemWH) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =  UIColorFromRGB(0xFFFFFF);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    return _collectionView;
}

- (XCMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[XCMediaFetcher alloc] init];
//        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];
        _mediaFetcher.limit = 6;
        _mediaFetcher.notAllowPickingOriginalPhoto = YES;
    }
    return _mediaFetcher;
}

@end
