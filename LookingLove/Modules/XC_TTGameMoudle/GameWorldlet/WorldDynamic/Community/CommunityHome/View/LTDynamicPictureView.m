//
//  XCMyVestPictureView.m
//  UKiss
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTDynamicPictureView.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "SDPhotoBrowser.h"
#import "CTDynamicModel.h"
#import "XCCurrentVCStackManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "XCConst.h"
#import "CTDynamicModel.h"
#import "LLDynamicImageModel.h"
#import "UIView+NTES.h"

//#define bgWidth (KScreenWidth - 40)

static CGFloat bgWidth = 0;
//图片间距
#define ALBUM_IMAGE_INTERVAL 8
#define picW ((KScreenWidth-50)/2)//(KScreenWidth < 375 ? 132 * 0.8 : 132)

@implementation LLDynamicPictureCustomLayout
- (void)prepareLayout {
    [super prepareLayout];
    
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes*>* original = [super layoutAttributesForElementsInRect:rect];
    if (original.count == 1) {
        CGRect frame = original[0].frame;
        frame.origin.x = 0;
        original[0].frame = frame;
    }
    return original;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
   
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

@end

@interface LTDynamicPictureView ()<SDPhotoBrowserDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, weak) SDPhotoBrowser *photoBrowser;
@property (nonatomic, assign) LLDynamicPicViewStyle style;

@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation LTDynamicPictureView

- (instancetype)initWithStyle:(LLDynamicPicViewStyle)style {

    if (self = [super init]) {
        CGFloat squareW = KScreenWidth - 90;
        CGFloat worldW = KScreenWidth - 40;
        bgWidth = style == LLDynamicPicViewStyleSquare ? squareW : worldW;
        _style = style;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapEmptyAreaAction)];
        tapGR.delegate = self;
        [self.collectionView addGestureRecognizer:tapGR];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
//    [super intrinsicContentSize];
    // 外部使用了 stackView 这里必须确定 intrinSize 才可以自动 layout
    CGSize size = CGSizeMake(bgWidth, [[self class] getPictureViewHeightWithImageInfoList:self.imageUrls]);
    return size;
}

#pragma mark - Action
- (void)didTapEmptyAreaAction {
    !self.didTapEmptyAreaHandler ?: self.didTapEmptyAreaHandler();
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 如果点击UICollectionView就执行手势，否则不执行
    if ([touch.view isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark -
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)cell.backgroundView;
    if (!imageView.image) {
        return [CTDynamicModel modelWithPictureImageBg];
    }
    return imageView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    LLDynamicImageModel *model = self.imageUrls[index];
    NSURL *url = [NSURL URLWithString:model.resUrl];
    return url;
}

- (void)tapImageAction:(UITapGestureRecognizer *)tap {
    [[XCCurrentVCStackManager shareManager].getCurrentVC.view endEditing:YES];
    UIImageView *img = (UIImageView *)tap.view;
    NSInteger index= img.tag - 100;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    self.photoBrowser = browser;
    browser.sourceImagesContainerView = self;
    browser.delegate = self;
    browser.imageCount = self.imageUrls.count;
    browser.currentImageIndex = index;
    [browser show];
}

///计算图片高度
+ (CGFloat)getPictureViewHeightWithImageCount:(NSInteger)count {
    CGFloat imgWidth = count > 2 ? (bgWidth - 40 -10*2)/3 : picW;
    NSInteger numRow = count ? (count - 1) / 3 + 1 : 0;
    CGFloat imgBgHeight = count ? (imgWidth *numRow + (numRow - 1)*10) : 0;
    return imgBgHeight;
}

+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<LLDynamicImageModel *> *)imageList {
    return [self getPictureViewHeightWithImageInfoList:imageList realWidth:0];
}

+ (CGFloat)getPictureViewHeightWithImageInfoList:(NSArray<LLDynamicImageModel *> *)imageList realWidth:(CGFloat)width {
    
    if (width) {
        bgWidth = width;
    }
    
    CGFloat bgViewHeight = 0;
    CGSize size = [self imageSize:imageList];

    if (imageList.count == 1) {
        bgViewHeight = size.height;
    } else if (imageList.count == 2) {
        bgViewHeight = size.height;
    } else {
        NSInteger rows = ceil(imageList.count / 3.0);
        bgViewHeight = size.width * rows + ALBUM_IMAGE_INTERVAL * (rows - 1);
    }
    
    return bgViewHeight;
}

/// 计算图片大小，区分一、二、三张
/// @param imageList 图片数组
+ (CGSize)imageSize:(NSArray<LLDynamicImageModel *> *)imageList {
    CGSize size = CGSizeZero;
    
    if (imageList.count == 1) {
        LLDynamicImageModel *imageModel = [imageList firstObject];
        
        // 单张图片最大尺寸为屏幕的 0.68
        CGFloat singleWidth = bgWidth * 0.68;
        // 宽高比
        CGFloat widthAspectRatio = imageModel.width / imageModel.height;
        // 高宽比
        CGFloat heightAspectRatio = imageModel.height / imageModel.width;
        // 最大的比例
        CGFloat maxAspectRatio = 2.5f;
        
//        A. 当1≤x≤2.5，y≤1时，图片预览时宽度一致，且缩略图和原图比例一致。
//        B. 当x＞2.5，y≤1时，缩略图和原图比例发生改变，缩略图高度为h不变，宽度为2.5*h（即缩略图宽高比为2.5:1），缩略图居中显示，水平方向隐藏，两端显示不完整；
//        C.当x≤1，1≤y≤2.5时，图片预览时高度一致，且缩略图和原图比例一致。
//        D.当x≤1，y＞2.5时，缩略图和原图比例发生改变，缩略图宽度为w不变，高度为2.5*w（即缩略图高宽比为2.5:1），缩略图居中显示，垂直方向隐藏，两端显示不完整；
        
        // 宽大于长时
        if (widthAspectRatio > heightAspectRatio) {
            if (widthAspectRatio > maxAspectRatio) {
                // 宽高的比例大于 2.5 时
                size = CGSizeMake(singleWidth, singleWidth / maxAspectRatio);
            } else if (imageModel.width > singleWidth) {
                // 比例不够2.5 但是宽度又比既定宽度要宽
                size = CGSizeMake(singleWidth, singleWidth * heightAspectRatio);
            }
        // 长大于宽时
        } else if (heightAspectRatio > widthAspectRatio) {
            if (heightAspectRatio > maxAspectRatio) {
                // 高宽的比例大于 2.5 时
                size = CGSizeMake(singleWidth / maxAspectRatio, singleWidth);
            } else if (imageModel.height > singleWidth) {
                size = CGSizeMake(singleWidth * widthAspectRatio, singleWidth);
            }
        } else {
            // 普通情况下
            if (imageModel.width > singleWidth) {
                CGFloat aspectRatio = imageModel.height/imageModel.width;
                size = CGSizeMake(singleWidth, singleWidth * aspectRatio);
            } else {
                size = CGSizeMake(imageModel.width, imageModel.height);
            }
        }
        
    } else if (imageList.count == 2) {
        CGFloat width = (bgWidth - ALBUM_IMAGE_INTERVAL) / 2.0;
        size = CGSizeMake(width, width);
    } else {
        CGFloat width = (bgWidth - (ALBUM_IMAGE_INTERVAL * 2)) / 3.0;
        size = CGSizeMake(width, width);
    }
    
    return size;
}

- (void)setImageUrls:(NSArray<LLDynamicImageModel *> *)imageUrls {
    _imageUrls = imageUrls;
    //图片高度/宽度  间距为10   两张图以下是132
    
    CGFloat squareW = KScreenWidth - 90;
    CGFloat worldW = KScreenWidth - 40;
    bgWidth = _style == LLDynamicPicViewStyleSquare ? squareW : worldW;

    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.class imageSize:self.imageUrls];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *img = [[UIImageView alloc] init];
    LLDynamicImageModel *obj = self.imageUrls[indexPath.item];
    [img qn_setImageImageWithUrl:obj.resUrl placeholderImage:nil type:ImageTypeUserLibaryDetail];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.layer.cornerRadius = 8;
    img.layer.masksToBounds = YES;
    cell.backgroundView = img;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    self.photoBrowser = browser;
    browser.sourceImagesContainerView = cell;
    browser.delegate = self;
    browser.imageCount = self.imageUrls.count;
    browser.currentImageIndex = indexPath.item;
    
    [browser show];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LLDynamicPictureCustomLayout *flowLayout = [[LLDynamicPictureCustomLayout alloc] init];
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.minimumInteritemSpacing = 8;
//        flowLayout.minimumLineSpacing = 8;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}

@end
