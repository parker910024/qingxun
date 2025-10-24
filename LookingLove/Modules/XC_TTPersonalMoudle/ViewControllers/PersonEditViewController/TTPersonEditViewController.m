//
//  TTPersonEditViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonEditViewController.h"
#import "TTEditNickViewController.h"
#import "TTEditDescibeViewController.h"
#import "TTEditMinePhotosViewContorller.h"
#import "XCMediator+TTGameModuleBridge.h"

//view
#import "TTPersonEditCell.h"
#import "TTPersonEditImageCell.h"
#import "TTPersonEditRecordCell.h"
#import "TTDatePickView.h"

//model
#import "UserInfo.h"
//core
#import "UserCore.h"
#import "UserCoreClient.h"
#import "AuthCore.h"
#import "FileCore.h"
#import "FileCoreClient.h"

//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "TTPopup.h"
#import "TTStatisticsService.h"
//cate
#import "UIImageView+QiNiu.h"
#import "XCHUDTool.h"
#import "UIImage+scaledToSize.h"
#import "XCKeyWordTool.h"

@interface TTPersonEditViewController ()
<
    FileCoreClient,
    UserCoreClient,
    TTDatePickViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>
@property (nonatomic, strong) UserInfo  *userinfo;//
/** 音频地址 */
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) TTDatePickView  *brithPickView;//
@property (nonatomic, strong) NSDateFormatter  *dateFormatter;//
@end

@implementation TTPersonEditViewController

- (void)dealloc {
    RemoveCoreClient(FileCoreClient, self);
    RemoveCoreClient(UserCoreClient, self);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人资料";
    [self.tableView registerClass:[TTPersonEditCell class] forCellReuseIdentifier:@"TTPersonEditCell"];
     [self.tableView registerClass:[TTPersonEditImageCell class] forCellReuseIdentifier:@"TTPersonEditImageCell"];
    [self.tableView registerClass:[TTPersonEditRecordCell class] forCellReuseIdentifier:@"TTPersonEditRecordCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    UIView *headView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    self.tableView.tableHeaderView = headView;
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUserInfo];
}


#pragma mark - TabelView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }else {
        return 40;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.row == 3) {
        TTPersonEditImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTPersonEditImageCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TTPersonEditImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTPersonEditImageCell"];
        }
        NSArray *photos;
        if (self.userinfo.privatePhoto.count >=3) {
           photos = [[[self.userinfo.privatePhoto subarrayWithRange:NSMakeRange(0, 3)] reverseObjectEnumerator] allObjects];
        } else {
           photos = [[self.userinfo.privatePhoto reverseObjectEnumerator] allObjects];
        }
        cell.titleLabel.text = @"相册：";
        cell.photos = photos;
        return cell;
    }else if (indexPath.row == 4) {
        TTPersonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTPersonEditCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TTPersonEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTPersonEditCell"];
        }
        cell.avatar.hidden = YES;
        cell.dataLabel.hidden= NO;
        cell.titleLabel.text = @"我的声音：";
        if (!self.userinfo.userVoice.length) {
            cell.dataLabel.attributedText = [[NSAttributedString alloc] initWithString:@"录制声音" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
        } else {
            cell.dataLabel.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
        }
        return cell;
    }else {
        TTPersonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTPersonEditCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TTPersonEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTPersonEditCell"];
        }
        cell.avatar.hidden = YES;
        cell.dataLabel.hidden= NO;
        if (indexPath.row == 0) {
            cell.avatar.hidden = NO;
            cell.dataLabel.hidden= YES;
            [cell.avatar qn_setImageImageWithUrl:self.userinfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeRoomFace];
            cell.titleLabel.text = @"头像：";
        }else if (indexPath.row == 1){
            cell.dataLabel.text = self.userinfo.nick;
            cell.titleLabel.text = @"昵称：";
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"生日：";
            NSString *dateStr = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.userinfo.birth/1000]];
            cell.dataLabel.text = dateStr;
        }else {
            cell.titleLabel.text = @"个人介绍：";
            cell.dataLabel.text = self.userinfo.userDesc.length?self.userinfo.userDesc:@"请设置";
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self showPhotoView];
    }else if (indexPath.row == 1) {
        TTEditNickViewController *vc = [[TTEditNickViewController alloc] init];
        vc.info = self.userinfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else  if (indexPath.row == 2) {
        [self showDatePickerView];
    }else if (indexPath.row == 3){
        TTEditMinePhotosViewContorller *vc = [[TTEditMinePhotosViewContorller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        [TTStatisticsService trackEvent:@"my_sound" eventDescribe:@"编辑资料"];
        UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMyViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 5) {
        TTEditDescibeViewController *vc = [[TTEditDescibeViewController alloc] init];
        vc.info = self.userinfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    if (selectedPhoto) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
        }
        [GetCore(FileCore) qiNiuUploadImage:selectedPhoto uploadType:UploadImageTypeAvtor];
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UsercoreClient

- (void)onSaveUserInfoFailth:(NSString *)message errorCode:(NSInteger)errorCode {
    [XCHUDTool hideHUDInView:self.view];
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - FileCoreClient
- (void)didUploadAvtorImageSuccessUseQiNiu:(NSString *)key {
    [XCHUDTool hideHUDInView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];//KeyType_QiNiuBaseURL
    [self updateUserInfo:@"avatar" value:url];
}


#pragma mark - TTDatePickViewDelegate

- (void)ttDatePickLimitAction {
    [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"必须满18周岁才能使用%@哦～", [XCKeyWordTool sharedInstance].myAppName] inView:self.view];
}

- (void)ttDatePickCancelAction {
    [TTPopup dismiss];
}

- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date {
    [self updateUserInfo:@"birth" value:YMd];
}

#pragma mark - event

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

- (void)showNotPhoto:(NSString *)title content:(NSString *)content {
    
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


- (void)showDatePickerView {
    
    self.brithPickView.time = self.userinfo.birth/1000;
    [TTPopup popupView:self.brithPickView style:TTPopupStyleActionSheet];
}

#pragma mark - private

- (void)updateUserInfo {
    @weakify(self)
    [[GetCore(UserCore) getUserInfoByRac:GetCore(AuthCore).getUid.longLongValue refresh:YES] subscribeNext:^(UserInfo *x) {
        @strongify(self)
        self.userinfo = x;
        // 更新成功后回调出去
        !self.infoRefreshHandler ? : self.infoRefreshHandler(self.userinfo);
    }];
}

- (void)updateUserInfo:(NSString *)key value:(NSString *)value;
{
    [XCHUDTool showGIFLoadingInView:self.view];
    NSMutableDictionary *userinfos = [NSMutableDictionary dictionary];
    [userinfos setObject:value forKey:key];
    @weakify(self)
    [[GetCore(UserCore) saveUserInfoWithUserID:self.userinfo.uid userInfos:userinfos] subscribeNext:^(id x) {
        @strongify(self)
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showSuccessWithMessage:@"修改成功" inView:self.view];
        [self updateUserInfo];
    } error:^(NSError *error) {
        @strongify(self)
        [XCHUDTool hideHUDInView:self.view];
        [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
    }];
}


#pragma mark - Getter && Setter

- (void)setUserinfo:(UserInfo *)userinfo {
    _userinfo = userinfo;
    [self.tableView reloadData];
}

- (TTDatePickView *)brithPickView {
    if (!_brithPickView) {
        _brithPickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 216+kSafeAreaBottomHeight+54)];
        _brithPickView.limitAge = 18;
        _brithPickView.delegate = self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *endDate = [formatter dateFromString:@"1945-01-01"];
        
        _brithPickView.minimumDate = endDate;
        _brithPickView.maximumDate = [NSDate date];
    }
    return _brithPickView;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"YYYY-MM-dd";
    }
    return _dateFormatter;
}

@end
