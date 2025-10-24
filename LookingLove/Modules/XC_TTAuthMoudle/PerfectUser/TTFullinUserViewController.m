//
//  TTFullinUserViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTFullinUserViewController.h"

#import "TTAuthEditView.h"

// core
#import "UserCore.h"
#import "AuthCore.h"
#import "FileCore.h"
#import "LinkedMeCore.h"
#import "FileCoreClient.h"
#import "UserCoreClient.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImage+_1x1Color.h"
#import "XCHUDTool.h"
#import "UIImage+Utils.h"
#import "XCKeyWordTool.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MMSheetView.h"
#import <SDWebImage/UIButton+WebCache.h>

// core
#import "AuthCore.h"
#import "AuthCoreClient.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "WeChatUserInfo.h"
#import "QQUserInfo.h"

#import "UIImage+_1x1Color.h"
#import "UIImage+scaledToSize.h"
#import <BaiduMobStatCodeless/BaiduMobStat.h>
#import "TTPopup.h"

@interface TTFullinUserViewController ()<UITextFieldDelegate, FileCoreClient, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserCoreClient>
/** 保存 */
@property (nonatomic, strong) UIButton *saveButton;
/** 照片 */
@property (nonatomic, strong) UIButton *photoButton;
/** 昵称 */
@property (nonatomic, strong) TTAuthEditView *nameEditView;
/** 生日 */
@property (nonatomic, strong) TTAuthEditView *birthEditView;
/** 邀请码 */
@property (nonatomic, strong) TTAuthEditView *invitEditView;
/** 注意提示 */
@property (nonatomic, strong) UIImageView *tipsImageView;
/** 注意提示 */
@property (nonatomic, strong) UILabel *tipsLabel;

/**日期选择器*/
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UserInfo *userInfo;

/** man */
@property (nonatomic, strong) UIButton *manButton;
/** woman */
@property (nonatomic, strong) UIButton *womanButton;
/** tipLabel */
@property (nonatomic, strong) UILabel *tipLabel;
/** tip */
@property (nonatomic, strong) UIImageView *tipImageView;

/** 是否选择是男性 */
//@property (nonatomic, assign) BOOL isMan;
//@property (strong, nonatomic) WeChatUserInfo *weChatInfo;
//@property (strong, nonatomic) QQUserInfo *qqInfo;
/** 是否选择过性别 */
@property (nonatomic, assign) BOOL isSelectedSex;
@end

@implementation TTFullinUserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写资料";
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButton:)];
    
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    [self initView];
    [self initConstrations];
    [self judgeIsThridPartLogin];
    [self isShowSaveEnabled];
    [self initDefaultUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak __typeof__(self) wself = self;
    UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
//    } else {
//        CGRect rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
//        CGFloat min = MIN(rect.size.width, rect.size.height);
//        rect = CGRectMake(0, 0, min, min);
//        selectedPhoto = [selectedPhoto subWithRect:rect];
//    }
    if (selectedPhoto) {
        __strong __typeof (wself) sSelf = wself;
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
        }
        [sSelf.photoButton setBackgroundImage:selectedPhoto forState:UIControlStateNormal];
        [sSelf isShowSaveEnabled];
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.birthEditView.textField) {
        
        // 弹起日期选择框
        [self showDateViewController];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    // 邀请码限制多少位?
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)theTextField {
    NSInteger limitCount = 15;
    if (self.nameEditView.textField.text.length > limitCount) {
        UITextRange *markedRange = [self.nameEditView.textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [self.nameEditView.textField.text rangeOfComposedCharacterSequenceAtIndex:limitCount];
        self.nameEditView.textField.text = [self.nameEditView.textField.text substringToIndex:range.location];
    }
    [self isShowSaveEnabled];
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - UserCoreClient
// 保存用户信息失败
- (void)onSaveUserInfoFailth:(NSString *)message errorCode:(NSInteger)errorCode {
    self.saveButton.enabled = YES;
    [XCHUDTool showErrorWithMessage:message inView:self.view];
    
    // 邀请码错误
    if (errorCode == 1411) {
        self.invitEditView.textField.text = @"";
    }
}

#pragma mark - FileCoreClient
- (void)didUploadAvtorImageSuccessUseQiNiu:(NSString *)key {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];//KeyType_QiNiuBaseURL
    
    if (url != nil) {
        UserID userId = GetCore(AuthCore).getUid.userIDValue;
        NSMutableDictionary *userinfos = [NSMutableDictionary dictionary];
        [userinfos setObject:url forKey:@"avatar"];
        [userinfos setObject:self.nameEditView.textField.text forKey:@"nick"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        [userinfos setObject:self.birthEditView.textField.text forKey:@"birth"];
        
        //        [userinfos setObject:self.invitEditView.textField.text forKey:@"shareCode"];
        
        NSInteger gender;
        if (!self.isMan) {
            gender = 2;
        }else {
            gender = 1;
        }
        [userinfos setObject:@(gender) forKey:@"gender"];
        if (GetCore(LinkedMeCore).H5URL){
            [GetCore(AuthCore) statisticsWith:[NSURL URLWithString:GetCore(LinkedMeCore).H5URL]];
        }
        @weakify(self);
        [[GetCore(UserCore) saveUserInfoWithUserID:userId userInfos:userinfos] subscribeNext:^(id x) {
            @strongify(self);
            [XCHUDTool hideHUDInView:self.view];
            GetCore(AuthCore).info = nil;
            GetCore(AuthCore).qqInfo = nil;
            //            self.saveButton.enabled = NO;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
                
                [GetCore(UserCore) requestRecommendRoomUid];
                NotifyCoreClient(AuthCoreClient, @selector(fullinUserInfoSuccess), fullinUserInfoSuccess);
            }];
        } error:^(NSError *error) {
           [XCHUDTool hideHUDInView:self.view];
        }];
    }
}

- (void)didUploadAvtorImageFailUseQiNiu:(NSString *)message{
    self.saveButton.enabled = YES;
    [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
}

//- (void)onUploadSuccess:(NSString *)url
//{
//    if (url != nil) {
//        UserID userId = GetCore(AuthCore).getUid.userIDValue;
//        NSMutableDictionary *userinfos = [NSMutableDictionary dictionary];
//        [userinfos setObject:url forKey:@"avatar"];
//        [userinfos setObject:self.nameEditView.textField.text forKey:@"nick"];
//
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"YYYY-MM-dd";
//        [userinfos setObject:self.birthEditView.textField.text forKey:@"birth"];
//
////        [userinfos setObject:self.invitEditView.textField.text forKey:@"shareCode"];
//
//        NSInteger gender;
//        if (!self.isMan) {
//            gender = 2;
//        }else {
//            gender = 1;
//        }
//        [userinfos setObject:@(gender) forKey:@"gender"];
//        if (GetCore(LinkedMeCore).H5URL){
//            [GetCore(AuthCore) statisticsWith:[NSURL URLWithString:GetCore(LinkedMeCore).H5URL]];
//        }
//        @weakify(self);
//        [[GetCore(UserCore) saveUserInfoWithUserID:userId userInfos:userinfos] subscribeNext:^(id x) {
//            @strongify(self);
//            [UIView hideToastView];
//            //            GetCore(AuthCore).info = nil;
//            //            GetCore(AuthCore).qqInfo = nil;
////            self.saveButton.enabled = NO;
//            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                [GetCore(UserCore) requestRecommendRoomUid];
//            }];
//        } error:^(NSError *error) {
//            @strongify(self);
//            [UIView hideToastView];
////            self.saveButton.enabled = YES;
////            [UIView showError:@"请求失败，请检查网络"];
//
//        }];
//    }
//}
//
//- (void)onUploadFailth:(NSError *)error {
//    [UIView hideToastView];
//    [self isShowSaveEnabled];
//    [UIView showError:@"请求失败，请检查网络"];
//}

#pragma mark - event response
- (void)datePickValueChange:(UIDatePicker *)pick {
    NSDate * date = pick.date;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate * nowDate = [NSDate date];
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:nowDate options:0];
    if (dateCom.year < 18) {
        [XCHUDTool showErrorWithMessage:[NSString stringWithFormat:@"不满18岁的小可爱不可以来%@玩哦~", [XCKeyWordTool sharedInstance].myAppName] inView:self.view];
        [self limitDateWith:pick and:calendar nowDate:nowDate];
    }else{
        [pick setDate:date animated:YES];
    }
}

/**
 保存
 */
- (void)didClickSaveButton:(UIButton *)button{
    if (self.photoButton.currentBackgroundImage == nil) {
        [XCHUDTool showErrorWithMessage:@"请设置头像" inView:self.view];
        return;
    }
    
    if (self.nameEditView.textField.text == nil || self.nameEditView.textField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请输入昵称" inView:self.view];
        return;
    }
    
    if (!self.isSelectedSex) {
        [XCHUDTool showErrorWithMessage:@"必须选择性别哦 ~ " inView:self.view];
        return;
    }
    if (self.birthEditView.textField.text == nil || self.birthEditView.textField.text.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请输入生日" inView:self.view];
        return;
    }
    
    [XCHUDTool showGIFLoadingInView:self.view];
    
    [[BaiduMobStat defaultStat]logEvent:@"login_repari_success_click" eventLabel:@"完善资料的保存按钮"];
    [GetCore(FileCore) qiNiuUploadImage:self.photoButton.currentBackgroundImage uploadType:UploadImageTypeAvtor];
}

/**
 日期确认
 */
- (void)didClcikBirthDayButton:(UIButton *)button {
    NSDate *theDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:theDate];
    self.birthEditView.textField.text = dateStr;
    
    [TTPopup dismiss];
    
    [self isShowSaveEnabled];
}

- (void)showPhotoView {
    @weakify(self)
    TTActionSheetConfig *takePhotoConf = [TTActionSheetConfig normalTitle:@"拍照上传" clickAction:^{
        
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
    
    TTActionSheetConfig *pickPhotoConf = [TTActionSheetConfig normalTitle:@"本地相册" clickAction:^{
        
        [YYUtility checkAssetsLibrayAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
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
    
    [TTPopup actionSheetWithItems:@[takePhotoConf, pickPhotoConf]];
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

/**点击照片*/
- (void)didClickPhotoButton:(UIButton *)button {
    [self showPhotoView];
}

- (void)didClickManSelectButton:(UIButton *)btn {
    self.isMan = YES;
}

- (void)didClickWomanSelectButton:(UIButton *)btn {
    self.isMan = NO;
}

//- (void)didClickBackButton:(UIButton *)btn {
//    [self dismissViewControllerAnimated:YES completion:^{
//        [GetCore(AuthCore) logout];
//    }];
//}

#pragma mark - private method

- (void)limitDateWith:(UIDatePicker *)datePick and:(NSCalendar *)calendar nowDate:(NSDate *)nowDate
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];//设置最大时间为：当前时间推后十年
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:nowDate options:0];
    [datePick setDate:maxDate animated:YES];
}

/**
 日期选择器
 */
- (void)showDateViewController {
    UIView * birthView = [[UIView alloc] init];
    birthView.bounds = CGRectMake(0, 0, KScreenWidth, 216+kSafeAreaBottomHeight+54);
    [birthView addSubview:self.datePicker];
    self.datePicker.frame = CGRectMake(10, 0, KScreenWidth-20, 216);
    UIButton * sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(10, 221, KScreenWidth-20, 44);
    [sureBtn addTarget:self action:@selector(didClcikBirthDayButton:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = [UIColor whiteColor];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [birthView addSubview:sureBtn];
    
    [TTPopup popupView:birthView style:TTPopupStyleActionSheet];
}

//判断是否第三方登录
- (void)judgeIsThridPartLogin {
    if (GetCore(AuthCore).info.openid) {
        self.qqInfo = nil;
        self.weChatInfo = GetCore(AuthCore).info;
        GetCore(AuthCore).isNewRegister = YES;
        self.isMan = [self.weChatInfo.sex isEqualToString:@"1"];
        
    } else if (GetCore(AuthCore).qqInfo.openID) {
        self.weChatInfo = nil;
        self.qqInfo = GetCore(AuthCore).qqInfo;
        GetCore(AuthCore).isNewRegister = YES;
        self.isMan = [self.qqInfo.gender isEqualToString:@"男"];
    }
}

- (void)isShowSaveEnabled {
    //    bool isShow = NO;
    //    if ((self.photoButton.currentBackgroundImage != nil) &&
    //        self.nameEditView.textField.text.length > 0 &&
    //        self.birthEditView.textField.text.length > 0 &&
    //        (self.manButton.selected || self.womanButton.selected)) {
    //        isShow = YES;
    //    }
    //    self.saveButton.enabled = isShow;
}

- (void)initDefaultUserInfo {
    if (self.qqInfo || self.weChatInfo) {
        return;
    }
    
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"common_default_avatar"] forState:UIControlStateNormal];
    self.nameEditView.textField.text = @"我是一个小萌新";
    self.birthEditView.textField.text = @"2000-01-01";
    [self isShowSaveEnabled];
}

- (void)initView {
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.nameEditView];
    [self.view addSubview:self.birthEditView];
    //    [self.view addSubview:self.invitEditView];
    [self.view addSubview:self.tipsImageView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.saveButton];
    
    [self.view addSubview:self.manButton];
    [self.view addSubview:self.womanButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipImageView];
    
    [self.nameEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.manButton addTarget:self action:@selector(didClickManSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton addTarget:self action:@selector(didClickWomanSelectButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(83 + statusbarHeight);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.nameEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(48);
        make.top.mas_equalTo(self.photoButton.mas_bottom).offset(42);
        make.height.mas_equalTo(44);
    }];
    
    [self.birthEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameEditView);
        make.top.mas_equalTo(self.nameEditView.mas_bottom).offset(20);
    }];
    
    //    [self.invitEditView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.height.mas_equalTo(self.nameEditView);
    //        make.top.mas_equalTo(self.birthEditView.mas_bottom).offset(20);
    //    }];
    
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameEditView);
        make.height.mas_equalTo(self.nameEditView);
        make.top.mas_equalTo(self.birthEditView.mas_bottom).offset(20);
        make.width.mas_equalTo(self.nameEditView.mas_width).multipliedBy(0.45);
    }];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.nameEditView);
        make.height.top.width.mas_equalTo(self.manButton);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.manButton.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameEditView);
        if (KScreenWidth > 320) {//适配 iPhone 5 文字重叠
            make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottomHeight - 85);
        } else {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(20);
        }
        make.height.mas_equalTo(44);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.saveButton.mas_bottom).offset(17);
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.tipsLabel);
        make.right.mas_equalTo(self.tipsLabel.mas_left).offset(-5);
    }];
    
}

#pragma mark - getters and setters
- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.layer.masksToBounds = YES;
        _photoButton.layer.cornerRadius = 50;
        [_photoButton setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
        //        [_photoButton setImage:[UIImage imageNamed:@"auth_info_full_photo_PD"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(didClickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    //    NSString *image = (_photoButton.currentBackgroundImage == nil) ? @"auth_info_full_photo_PD": @"";
    //    [_photoButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return _photoButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xdbdbdb)] forState:UIControlStateDisabled];
        [_saveButton setBackgroundImage:[UIImage instantiate1x1ImageWithColor:[XCTheme getTTMainColor]] forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 22;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveButton addTarget:self action:@selector(didClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (TTAuthEditView *)nameEditView {
    if (!_nameEditView) {
        _nameEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入昵称"];
        _nameEditView.textField.delegate = self;
        _nameEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _nameEditView.layer.cornerRadius = 22.f;
    }
    return _nameEditView;
}

- (TTAuthEditView *)birthEditView {
    if (!_birthEditView) {
        _birthEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请选择生日"];
        _birthEditView.textField.delegate = self;
        _birthEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _birthEditView.layer.cornerRadius = 22.f;
    }
    return _birthEditView;
}

- (TTAuthEditView *)invitEditView {
    if (!_invitEditView) {
        _invitEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"填写邀请码（非必填）"];
        _invitEditView.textField.delegate = self;
        _invitEditView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _invitEditView.layer.cornerRadius = 22.f;
    }
    return _invitEditView;
}

- (UIButton *)manButton {
    if (!_manButton) {
        _manButton = [[UIButton alloc] init];
        UIImage *normal = [UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xF0F0F0)];
        UIImage *selected = [UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0x43C5FF)];
        [_manButton setBackgroundImage:normal forState:UIControlStateNormal];
        [_manButton setBackgroundImage:selected forState:UIControlStateSelected];
        _manButton.layer.cornerRadius = 22.f;
        _manButton.layer.masksToBounds = YES;
        [_manButton setTitle:@"男生" forState:UIControlStateNormal];
        [_manButton setTitleColor:UIColorFromRGB(0xBFBFBF) forState:UIControlStateNormal];
        [_manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _manButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [_manButton setImage:[UIImage imageNamed:@"auth_info_sex_male_selected"] forState:UIControlStateSelected];
        [_manButton setImage:[UIImage imageNamed:@"auth_info_sex_male_normal"] forState:UIControlStateNormal];
    }
    return _manButton;
}

- (UIButton *)womanButton {
    if (!_womanButton) {
        _womanButton = [[UIButton alloc] init];
        UIImage *normal = [UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xF0F0F0)];
        UIImage *selected = [UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xFF5A79)];
        [_womanButton setBackgroundImage:normal forState:UIControlStateNormal];
        [_womanButton setBackgroundImage:selected forState:UIControlStateSelected];
        _womanButton.layer.cornerRadius = 22.f;
        _womanButton.layer.masksToBounds = YES;
        [_womanButton setTitle:@"女生" forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"auth_info_sex_female_selected"] forState:UIControlStateSelected];
        [_womanButton setImage:[UIImage imageNamed:@"auth_info_sex_female_normal"] forState:UIControlStateNormal];
        [_womanButton setTitleColor:UIColorFromRGB(0xBFBFBF) forState:UIControlStateNormal];
        _womanButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [_womanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _womanButton;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        _tipImageView.image = [UIImage imageNamed:@"auth_tip_icon"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipLabel.text = @"性别选择后不可更改";
        _tipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipLabel;
}

- (UIImageView *)tipsImageView{
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_tip_icon"]];
    }
    return _tipsImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"未满18岁的小朋友不可以注册哦～";
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _tipsLabel;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        _datePicker.layer.cornerRadius = 5;
        _datePicker.layer.masksToBounds = YES;
        NSString *dateStr = @"";
        if (dateStr.length > 0) {
            dateStr = self.birthEditView.textField.text;
        } else {
            dateStr = @"2000-01-01";
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        NSDate *date = [dateFormatter dateFromString:dateStr];
        _datePicker.date = date;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(datePickValueChange:) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
    return _datePicker;
}

- (void)setWeChatInfo:(WeChatUserInfo *)weChatInfo {
    _weChatInfo = weChatInfo;
    if (weChatInfo == nil) {
        return;
    }
    @KWeakify(self);
    
    [self.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:weChatInfo.headimgurl] forState:(UIControlState)UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @KStrongify(self);
        [self isShowSaveEnabled];
        
    }];
    self.nameEditView.textField.text = weChatInfo.nickname;
    self.birthEditView.textField.text = @"2000-01-01";
    [self isShowSaveEnabled];
}

- (void)setQqInfo:(QQUserInfo *)qqInfo{
    _qqInfo = qqInfo;
    if (qqInfo==nil) {
        return;
    }
    
    @KWeakify(self);
    [self.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:qqInfo.figureurl_qq_2] forState:(UIControlState)UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @KStrongify(self);
        [self isShowSaveEnabled];
        
    }];
    
    self.nameEditView.textField.text = qqInfo.nickname;
    self.birthEditView.textField.text = @"2000-01-01";
    [self isShowSaveEnabled];
}

- (void)setIsMan:(BOOL)isMan{
    _isMan = isMan;
    if (isMan == NO) {
        self.manButton.selected = NO;
        self.womanButton.selected = YES;
    } else {
        self.manButton.selected = YES;
        self.womanButton.selected = NO;
    }
    [self isShowSaveEnabled];
    self.isSelectedSex = YES;
}

@end
