//
//  TTFeedbackAlbumView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2020/5/8.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTFeedbackAlbumView.h"

#import "LLPickPicCollectionViewCell.h"

#import "XCMediaFetcher.h"

#import "XCMacros.h"
#import "SDPhotoBrowser.h"
#import "TTPopup.h"

#import <Masonry/Masonry.h>

static NSString *const kCellId = @"cellId";

static NSInteger const kPicMaxCount = 4; // 照片最多选择4张
static NSInteger const kColumn = 4;//列数
static CGFloat const kMargin = 20.f; // 间距
static CGFloat const kPadding = 8.f; // 间距

#define itemWidth (KScreenWidth - kMargin * 2 - kPadding * (kPicMaxCount-1)) / kPicMaxCount // item 宽度

@interface TTFeedbackAlbumView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
SDPhotoBrowserDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XCMediaFetcher *mediaFetcher;

@end

@implementation TTFeedbackAlbumView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

#pragma mark - Public
/// 获取高度
- (CGFloat)height {
    NSInteger count = [self itemCount];
    NSInteger rows = ceil(count / (CGFloat)kColumn);
    if (rows == 0) {
        rows = 1;//没有数据也占一行
    }
    return itemWidth * rows + kPadding * (rows - 1);
}

#pragma mark - Private
/*
 * 查看大图
 */
- (void)showPhotoBrower:(NSIndexPath *)indexPath {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.collectionView;
    browser.delegate = self;
    browser.imageCount = self.dataArray.count;
    browser.currentImageIndex = indexPath.item;
    [browser show];
}

/// 显示数量少于最大张数时显示添加图片按钮
- (NSInteger)itemCount {
    return self.dataArray.count >= kPicMaxCount ? kPicMaxCount : self.dataArray.count + 1;
}

/*
 * 从相册选取照片
 */
- (void)choosePhotoFromLibrary {
    // 限制最多选取的照片数量
    self.mediaFetcher.limit = MAX(kPicMaxCount - self.dataArray.count, 0);

    // 选取相册图片
    @KWeakify(self);
    [self.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images, NSMutableArray *selectedAssets, NSString *path, PHAssetMediaType type) {
        @KStrongify(self);
        if (type == PHAssetMediaTypeImage) {
            [self.dataArray addObjectsFromArray:images];
        }
        [self.collectionView reloadData];

        if ([self.delegate respondsToSelector:@selector(albumViewHadAppendPhoto:)]) {
            [self.delegate albumViewHadAppendPhoto:self];
        }
    }];
}

/*
 * 从相机拍照
 */
- (void)choosePhotoFromCamera {
    @KWeakify(self);
    [self.mediaFetcher fetchMediaFromCamera:^(NSString *path, UIImage *image) {
        @KStrongify(self);
        if (image) {
            [self.dataArray addObject:image];
        }
        [self.collectionView reloadData];

        if ([self.delegate respondsToSelector:@selector(albumViewHadAppendPhoto:)]) {
            [self.delegate albumViewHadAppendPhoto:self];
        }
    }];
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return self.dataArray[index];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self itemCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLPickPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId
            forIndexPath:indexPath];
    if (indexPath.item == self.dataArray.count) {
        cell.imageView.image = nil;
    } else {
        cell.imageView.image = self.dataArray[indexPath.item];
    }
    
    cell.deleteBtn.hidden = !cell.imageView.image;

    @KWeakify(self)
    cell.deleteImageBlock = ^(UIImage * _Nonnull currentImage) {
        @KStrongify(self)
        
        [TTPopup alertWithMessage:@"要删除这张照片吗" confirmHandler:^{
            
            [self.dataArray removeObject:currentImage];
            [collectionView reloadData];

            if ([self.delegate respondsToSelector:@selector(albumViewHadDeletePhoto:)]) {
                [self.delegate albumViewHadDeletePhoto:self];
            }
        } cancelHandler:^{
        }];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (indexPath.item < self.dataArray.count) {
        //显示大图
        
        if ([self.delegate respondsToSelector:@selector(albumViewWillBrowserPhoto:)]) {
            [self.delegate albumViewWillBrowserPhoto:self];
        }
        
        [self showPhotoBrower:indexPath];
        return;
    }
    
    //添加图片
    
    if ([self.delegate respondsToSelector:@selector(albumViewWillAppendPhoto:)]) {
        [self.delegate albumViewWillAppendPhoto:self];
    }
    
    @KWeakify(self);
    TTActionSheetConfig *camera = [TTActionSheetConfig normalTitle:@"拍照" clickAction:^{
        @KStrongify(self);
        [self choosePhotoFromCamera];
    }];
    
    TTActionSheetConfig *photoLibrary = [TTActionSheetConfig normalTitle:@"从手机相册选择" clickAction:^{
        @KStrongify(self);
        [self choosePhotoFromLibrary];
    }];
    
    [TTPopup actionSheetWithItems:@[camera, photoLibrary]];
}

#pragma mark - Setter Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = kPadding;
        flowLayout.minimumLineSpacing = kPadding;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.whiteColor;
        [collectionView registerClass:LLPickPicCollectionViewCell.class forCellWithReuseIdentifier:kCellId];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (XCMediaFetcher *)mediaFetcher {
    if (!_mediaFetcher) {
        _mediaFetcher = [[XCMediaFetcher alloc] init];
        _mediaFetcher.limit = kPicMaxCount;
        _mediaFetcher.notAllowPickingOriginalPhoto = YES;
    }
    return _mediaFetcher;
}

- (NSMutableArray<UIImage *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
