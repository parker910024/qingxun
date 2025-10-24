//
//  TTMinePhotoCell.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMinePhotoCell.h"
#import "TTMinePhotoCollectionCell.h"

#import "AuthCore.h"
#import "UserPhoto.h"
#import "UIImage+Utils.h"
#import "SDPhotoBrowser.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TTMinePhotoCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
SDPhotoBrowserDelegate
>

@property (nonatomic, strong) UILabel  *noPhotosTip;//
@property (nonatomic, strong) UICollectionView  *collectionView;//

@end

@implementation TTMinePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.noPhotosTip];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15);
        make.right.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
    [self.noPhotosTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15);
        make.right.bottom.mas_equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    UserPhoto *photo = nil;
    
    //    if (GetCore(AuthCore).getUid.userIDValue == self.userID){
    //        photo = [self.privatePhoto safeObjectAtIndex:(index)];
    //    }else{
    photo = [self.privatePhoto safeObjectAtIndex:(index)];
    //    }
    return [NSURL URLWithString:photo.photoUrl];
}

#pragma mark  - CollectionViewDelegate && DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NSInteger count = self.privatePhoto.count;
    if (self.userID != myUid) {
        self.noPhotosTip.text = @"TA还没上传照片噢~";
        self.noPhotosTip.hidden = count?YES:NO;
        self.collectionView.hidden = !count?YES:NO;
    }else {
        //        self.noPhotosTip.text = @"还没上传照片噢~";
        self.noPhotosTip.hidden = YES;
    }
    return (self.userID == myUid) ? count + 1 : count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTMinePhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTMinePhotoCollectionCell class]) forIndexPath:indexPath];
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    if (self.userID == myUid) {
        // 相册小于8个
        if (indexPath.item == 0) {
            cell.personalPhotoImagwView.image = [UIImage imageNamed:@"mineInfo_userPhotoAdd"];
        } else  {
            UserPhoto *userPhoto = [self.privatePhoto safeObjectAtIndex:indexPath.item - 1];
            [cell.personalPhotoImagwView qn_setImageImageWithUrl:userPhoto.photoUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeUserLibary];
        }
    }else {
        if (self.privatePhoto.count > indexPath.item) {
            [cell.personalPhotoImagwView qn_setImageImageWithUrl:self.privatePhoto[indexPath.item].photoUrl placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserLibary  success:^(UIImage *image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    __block UIImage *newImage = [UIImage fixOrientation:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.personalPhotoImagwView.image = newImage;
                    });
                });
                
            }];
        }
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(95, 95);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    NSInteger index = 0;
    if (self.userID == myUid) {
        if (indexPath.item == 0) {
            //点击了 添加相册照片按钮
            if (self.delegate && [self.delegate respondsToSelector:@selector(showPhotosEditController)]) {
                [self.delegate showPhotosEditController];
            }
            return;
        }
    }
    index = indexPath.item;
    NSInteger count = self.privatePhoto.count;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    browser.sourceImagesContainerView = self.collectionView;
    browser.delegate = self;
    browser.imageCount = count;
    browser.currentImageIndex = (self.userID == myUid)?index-1:index;
    browser.isMe = (self.userID == myUid);
    [browser show];
}


#pragma mark - Getter && Setter

- (void)setPrivatePhoto:(NSArray<UserPhoto *> *)privatePhoto {
    _privatePhoto = privatePhoto;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TTMinePhotoCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMinePhotoCollectionCell class])];
        
    }
    return _collectionView;
}

- (UILabel *)noPhotosTip {
    if (!_noPhotosTip) {
        _noPhotosTip = [[UILabel alloc] init];
        _noPhotosTip.backgroundColor = [UIColor whiteColor];
        _noPhotosTip.textColor = UIColorFromRGB(0x666666);
        _noPhotosTip.text = @"     TA还没上传照片噢~";
        _noPhotosTip.font = [UIFont systemFontOfSize:15];
    }
    return _noPhotosTip;
}

@end
