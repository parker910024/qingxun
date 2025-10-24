//
//  TTEditMinePhotosViewContorller.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTEditMinePhotosViewContorller.h"

#import "TTMineEditPhotoCell.h"


#import "TwiceRemindView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "XCHUDTool.h"

#import "UserCore.h"
#import "FileCore.h"
#import "FileCoreClient.h"
#import "AuthCoreClient.h"
#import "UserCoreClient.h"
#import "UserPhoto.h"
#import "AuthCore.h"
#import "SDPhotoBrowser.h"
#import "TTPopup.h"

@interface TTEditMinePhotosViewContorller ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
FileCoreClient,
UserCoreClient,
SDPhotoBrowserDelegate,
TTMineEditPhotoCellDelegate
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UserPhoto *> *photos;
@property (nonatomic, strong) UserInfo *userinfo;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger successCout;
@property (nonatomic, strong) UIButton  *navRightButton;//
@property (nonatomic, assign) BOOL isUploading;

@end

@implementation TTEditMinePhotosViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TTMineEditPhotoCell class] forCellWithReuseIdentifier:@"XCPersonalPhotoCell"];
    [self.collectionView registerClass:[TTMineEditPhotoCell class] forCellWithReuseIdentifier:@"XCPersonalPhotoCell2"];
    [self initView];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}


- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)initView {
    self.title = @"我的相册";
    
    if (@available(iOS 11, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }];
    @weakify(self)
    [GetCore(UserCore)getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:NO success:^(UserInfo *info) {
        @strongify(self)
        self.userinfo = info;
        [self.collectionView reloadData];
        //        [MBProgressHUD hideHUD];
    }failure:nil];
}

- (void)onRightBtnClicked {
    if (self.isEditing) {
        self.isEditing = NO;
        [self.navRightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else {
        self.isEditing = YES;
        [self.navRightButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    
    [self.collectionView reloadData];
}

#pragma mark - PhotoSelectedController
-(void)showPhotosPickerController {
    if (self.isUploading) {
        return;
    }
    [self showPhotoView];
}


/**
 选择照片Toast
 */

- (void)showPhotoView {
    
    @weakify(self);
    TTActionSheetConfig *cameraConfig = [TTActionSheetConfig normalTitle:@"拍照上传" clickAction:^{
        [YYUtility checkCameraAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相机权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
    }];
    
    TTActionSheetConfig *photoLibrayConfig = [TTActionSheetConfig normalTitle:@"本地相册" clickAction:^{
        [YYUtility checkAssetsLibrayAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.modalPresentationCapturesStatusBarAppearance = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
    }];
    
    [TTPopup actionSheetWithItems:@[cameraConfig, photoLibrayConfig]];
}

- (void)showNotPhoto:(NSString *)title content:(NSString *)content{
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = title;
    config.message = content;
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } cancelHandler:^{
    }];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.photos.count + 1;
    return self.userinfo.privatePhoto.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TTMineEditPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCPersonalPhotoCell2" forIndexPath:indexPath];
        cell.personalPhotoImagwView.image = [UIImage imageNamed:@"mineInfo_userPhotoAdd"];
        [cell.deleteBtn setHidden:YES];
        return cell;
    } else if (indexPath.item > 0) {
        
        TTMineEditPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCPersonalPhotoCell" forIndexPath:indexPath];
        
        if (self.userinfo.privatePhoto.count > 0) {
            [cell.personalPhotoImagwView qn_setImageImageWithUrl:self.userinfo.privatePhoto[indexPath.item - 1].photoUrl placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
        }
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        if (self.isEditing) {
            [cell.deleteBtn setHidden:NO];
        }else {
            [cell.deleteBtn setHidden:YES];
        }
        return cell;
        
    }
    TTMineEditPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCPersonalPhotoCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 50) / 3, (self.view.frame.size.width - 50) / 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    if (indexPath.row == 0) {
        if (self.userinfo.privatePhoto.count < 8) {
            [self showPhotosPickerController];
            [self cancelEditing];
        }else{
            [XCHUDTool showErrorWithMessage:@"最多只能上传8张照片" inView:self.view];
        }
    }else {
        if (!self.isEditing) {
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
            browser.sourceImagesContainerView = self.collectionView;
            browser.delegate = self;
            browser.imageCount = self.userinfo.privatePhoto.count;
            browser.currentImageIndex = indexPath.item - 1;
            [browser show];
        }
    }
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:self.userinfo.privatePhoto[index].photoUrl];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (selectedPhoto) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
            }
            
            [GetCore(FileCore) qiNiuUploadImage:selectedPhoto uploadType:UploadImageTypeLibary];
            self.isUploading = YES;
            [XCHUDTool showGIFLoadingInView:self.view];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



#pragma mark - FileCoreClient

- (void)onUploadImageSuccess {
    self.isUploading = NO;
    [XCHUDTool hideHUDInView:self.view];
}

- (void)onUploadImageFailth:(NSString *)message {
    self.isUploading = NO;
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - FileCoreClient 7N
- (void)didUploadPhotoImageSuccessUseQiNiu:(NSString *)key{
    [XCHUDTool hideHUDInView:self.view];
    self.isUploading = NO;
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL,YES),key];
    [GetCore(UserCore) uploadImageUrlToServer:url];
}
-(void)didUploadPhotoImageFailUseQiNiu:(NSString *)message{
    [XCHUDTool showErrorWithMessage:message inView:self.view];
    self.isUploading = NO;
}


#pragma mark - UserCore

- (void)onUploadImageUrlToServerFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

- (void)onUploadImageUrlToServerSuccess {
    [self updateTheUserInfo];
    [XCHUDTool showSuccessWithMessage:@"上传成功" inView:self.view];
}

- (void)deleteImageToServerSuccess {
    [self updateTheUserInfo];
    [XCHUDTool showErrorWithMessage:@"删除成功" inView:self.view];
}

- (void)deleteImageUrlToServerFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

/** 更新上一个界面数据 */
- (void)updateUserInfoPhotoHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTuTuRefreshUserInfoNoti" object:nil userInfo:@{@"userInfo" : self.userinfo}];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoDataReload:)]) {
        [self.delegate photoDataReload:self.userinfo];
    }
}

#pragma mark - XCPersonalPhotoCellDelegate
/** 删除 */
- (void)deletePhoto:(NSIndexPath *)indexPath {
    [TwiceRemindView showTheTwiceRemindAlertWithMessage:@"删除是不可逆操作" title:@"是否需要删除？" targetVc:self enter:^{
        [self deletePhotoWithIndexPath:indexPath];
    } cancle:^{
        
    }];
    
}

#pragma mark - Private Method
/** 取消编辑 */
- (void)cancelEditing {
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    self.isEditing = NO;
    [self.collectionView reloadData];
}

/** 更新用户信息 */
- (void)updateTheUserInfo  {
    @weakify(self);
    [GetCore(UserCore) getUserInfo:[GetCore(AuthCore) getUid].userIDValue refresh:YES success:^(UserInfo *info) {
        @strongify(self);
        self.userinfo = info;
        [self.collectionView reloadData];
        [self updateUserInfoPhotoHandler];
    } failure:nil];
}

- (void)deletePhotoWithIndexPath:(NSIndexPath *)indexPath {
    
    [XCHUDTool showGIFLoadingInView:self.view];
    NSString *pid = self.userinfo.privatePhoto[indexPath.item - 1].pid;
    [GetCore(UserCore) deleteImageUrlToServerWithPid:pid];
    
}

#pragma mark - Getter && Setter
- (BOOL)isHiddenNavBar {
    return NO;
}

- (UIButton *)navRightButton {
    if (!_navRightButton) {
        _navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightButton addTarget:self action:@selector(onRightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_navRightButton setFrame:CGRectMake(0, 0, 50, 30)];
        [_navRightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _navRightButton;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.delegate  = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


@end
