//
//  XCPutPictureCollectionView.m
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "XCPutPictureCollectionView.h"
#import "XCPutPictureCell.h"
#import "XCMediaFetcher.h"
#import "SDPhotoBrowser.h"
#import "XCCurrentVCStackManager.h"
#import <Photos/PHImageManager.h>
#import "LTVideoPreviewVC.h"
#import "UIView+NTES.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "XCTheme.h"

@interface XCPutPictureCollectionView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
XCPutPictureCellDelegate,
SDPhotoBrowserDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
//选择图片对象
@property (nonatomic, strong) XCMediaFetcher *mediaFetcher;
///记录已经选中的图片
//@property (nonatomic, strong) NSMutableArray *selectedAssets;
///图片数组
@property (nonatomic, strong) NSMutableArray *imagesArr;
///浏览图片控件
@property (nonatomic, weak) SDPhotoBrowser *photoBrowser;
//视频路径
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) UIImage *coverImage;

@end

@implementation XCPutPictureCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.coverImage = nil;
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[XCPutPictureCell class] forCellWithReuseIdentifier:XCPutPictureCellIdentifier];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shootingPhotoAndVideo:) name:@"fakeName" object:nil];
    
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)shootingPhotoAndVideo:(NSNotification *)notify {
    NSLog(@"notify%@",notify);
    NSArray * imageArr = [notify.userInfo objectForKey:@"imageArr"];
    NSString * videoPath = [notify.userInfo objectForKey:@"videoPath"];
    NSString * cover = [notify.userInfo objectForKey:@"cover"];
    UIImage * img = [UIImage imageWithContentsOfFile:cover];
    if (videoPath) {
        self.videoPath = videoPath;
        self.coverImage = img;
        [self.imagesArr removeAllObjects];
    }
    if (imageArr) {
        [self.imagesArr addObjectsFromArray:imageArr];
    }
    
    [self updateImageArr];
    [self.collectionView reloadData];
}
- (void)addPhotoActions:(int)haveCount {
    //    if (haveCount == 6) {
    //        [UIView showError:@"您已选择了6张照片"];
    //        return;
    //    }
//    self.mediaFetcher.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
//    if (self.videoPath.length>0) {
//        self.mediaFetcher.mediaTypes = @[(NSString *)kUTTypeMovie];
//    }else if (self.imagesArr.count>0){
//        self.mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];
//    }
//    if (haveCount>0) {
//        self.mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];
//        self.mediaFetcher.limit = MAX(6-haveCount, 0);
//        self.haveCount = haveCount;
//    }
    //    self.mediaFetcher.selectedAssets = self.selectedAssets;
    //发送图片
    //    __weak typeof(self) weakSelf = self;
    @weakify(self);
    [self.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images,NSMutableArray *selectedAssets, NSString *path, PHAssetMediaType type) {
        @strongify(self);
        if (type == PHAssetMediaTypeVideo) {
            if (path.length>0) {
                self.videoPath = path;
                self.coverImage = images.firstObject;
                // /var/mobile/Containers/Data/Application/4CA0341B-F896-4A74-82BE-24F8ED36222C/Documents/3fb8f990c9489f8e506a6ddc1788be30/2524/video/9d6051c0b8274b9a90431b69beafaa4c.mp4
            }
        }else if (type == PHAssetMediaTypeImage) {
            [self.imagesArr addObjectsFromArray:images];
            //            self.selectedAssets = selectedAssets;
            //            self.imagesArr =  [NSMutableArray arrayWithArray:images];
        }
        [self updateImageArr];
        [self.collectionView reloadData];
    }];
}

#pragma mark UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    NSInteger count = self.imagesArr.count < 6 ? self.imagesArr.count + 1 : self.imagesArr.count;
    //    return count;
    //
    
    return self.videoPath.length>0 ? 1 : self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XCPutPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XCPutPictureCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.showPlay = NO;
    if (indexPath.row < self.imagesArr.count) {
        cell.image = self.imagesArr[indexPath.row];
    }
    if (self.videoPath.length>0) {
        cell.showPlay = YES;
        cell.image = self.coverImage;
    }
    //    else {
    //        cell.image = nil;
    //    }
    //给cell赋值
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.videoPath.length>0) {
        if (self.coverImage.size.width>self.coverImage.size.height) {
            return CGSizeMake(self.width-30, 212 * (self.width - 30)/345);
        }else{
            return CGSizeMake(141, 221);
        }
    }
    return  CGSizeMake(itemWH,itemWH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSInteger index= indexPath.row;
    if (self.videoPath.length) {
        LTVideoPreviewVC * vc = [LTVideoPreviewVC new];
        vc.videoPath = self.videoPath;
        self.coverImage = self.coverImage;
        @weakify(self);
        vc.deleteVideo = ^{
            @strongify(self);
            if (self.videoPath.length>0) {
                self.videoPath = nil;
                self.coverImage = nil;
                [self updateImageArr];
                [self.collectionView reloadData];
            }
        };
        [[[XCCurrentVCStackManager shareManager] getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
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
    [self addPhotoActions:self.haveCount];
}

- (void)deletePhotoCallBackWithCell:(XCPutPictureCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.videoPath.length>0) {
        self.videoPath = nil;
        self.coverImage = nil;
        [self updateImageArr];
        [self.collectionView reloadData];
        return;
    }
    
    [self.imagesArr removeObjectAtIndex:indexPath.row];
    //    [self.selectedAssets removeObjectAtIndex:indexPath.row];
    if (self.imagesArr.count == 5) {
        [self.collectionView reloadData];
    }else {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    [self updateImageArr];
}

- (void)updateImageArr {
    
    if (self.videoPath.length>0) {
        if (self.coverImage.size.width>self.coverImage.size.height) {
            self.collectionView.height = 212 * (self.width - 30)/345;
        }else{
            self.collectionView.height = 221;
        }
    }else{
        NSInteger row = ceil(self.imagesArr.count / 3.f);
        self.collectionView.height = row * itemWH;
        if (row == 2) self.collectionView.height += 10;
    }
    self.pictureCollectionHeight = self.collectionView.height;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePhotoDataCallBaccWith: video:cover:)]) {
        [self.delegate updatePhotoDataCallBaccWith:self.imagesArr video:self.videoPath cover:self.coverImage];
    }
}

#pragma mark - getters and setters

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =  UIColorFromRGB(0xf5f5f5);
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
//        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        _mediaFetcher.limit = 6;
        _mediaFetcher.notAllowPickingOriginalPhoto = YES;
    }
    return _mediaFetcher;
}
- (NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}
@end
