//
//  LLFullinUserViewController.h
//  XC_TTAuthMoudle
//
//  Created by apple on 2019/7/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//


#import "LLFullinUserViewController.h"

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
#import "UIButton+EnlargeTouchArea.h"
#import <SDWebImage/UIView+WebCache.h>

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
// 埋点
#import "TTStatisticsService.h"

@interface LLFullinUserViewController ()<UITextFieldDelegate, FileCoreClient, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserCoreClient>

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 保存 */
@property (nonatomic, strong) UIButton *saveButton;
/** 照片 */
@property (nonatomic, strong) UIButton *photoButton;
/// 随机头像按钮
@property (nonatomic, strong) UIButton *randomAvatarButton;
/** 昵称 */
@property (nonatomic, strong) TTAuthEditView *nameEditView;
/// 随机昵称按钮
@property (nonatomic, strong) UIButton *randomNickButton;
/** 昵称 下划线 */
@property (nonatomic, strong) UIView *nameEditLineView;
/** 生日 */
@property (nonatomic, strong) TTAuthEditView *birthEditView;
/** 生日 下划线 */
@property (nonatomic, strong) UIView *birthEditLineView;
/** 邀请码 */
@property (nonatomic, strong) TTAuthEditView *invitEditView;
/** 选择性别 */
@property (nonatomic, strong) UIView *seleceSexView;
/** 选择性别 */
@property (nonatomic, strong) UILabel *seleceSexLabel;
/** 选择性别 */
@property (nonatomic, strong) UIImageView *seleceSexImageView;
/** 选择性别 下划线 */
@property (nonatomic, strong) UIView *seleceSexLineView;
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

@property (nonatomic, assign) BOOL isSelectedSex;
@end

@implementation LLFullinUserViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    AddCoreClient(FileCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    
    [self initView];
    [self initConstrations];
    [self judgeIsThridPartLogin];
    [self isShowSaveEnabled];
    [self initDefaultUserInfo];
    
    [GetCore(UserCore) getUserRandomInfoStatus];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (selectedPhoto) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
        }
        
        [self.photoButton setBackgroundImage:selectedPhoto forState:UIControlStateNormal];
        [self isShowSaveEnabled];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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

- (void)userRandomInfoSuccessWithNick:(NSString *)randomNick randomAvatar:(NSURL *)randomAvatarUrl resCode:(NSNumber *)resCode resMsg:(NSString *)resMsg {
    
    if (!randomNick && !randomAvatarUrl) {
        [XCHUDTool showErrorWithMessage:resMsg];
        return;
    }
    
    if (randomNick) {
        self.nameEditView.textField.text = randomNick;
    }
    
    if (randomAvatarUrl) {
        [self.photoButton sd_setShowActivityIndicatorView:YES];
        [self.photoButton sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.photoButton sd_setBackgroundImageWithURL:randomAvatarUrl forState:UIControlStateNormal];
    }
}

- (void)getUserRandomInfoStatus:(BOOL)nickStatus avatarStatus:(BOOL)avatarStatus resCode:(NSNumber *)resCode resMsg:(NSString *)resMsg {
    self.randomNickButton.hidden = !nickStatus;
    self.randomAvatarButton.hidden = !avatarStatus;
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
                
        NSInteger gender;
        if (!self.isMan) {
            gender = 2;
        } else {
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
    [XCHUDTool showErrorWithMessage:message ?: @"请求失败，请检查网络" inView:self.view];
}

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
    
    [[BaiduMobStat defaultStat] logEvent:@"login_repari_success_click" eventLabel:@"完善资料的保存按钮"];
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
    } else if (GetCore(AuthCore).appleInfo.user) {
        self.appleInfo = nil;
        self.appleInfo = GetCore(AuthCore).appleInfo;
        GetCore(AuthCore).isNewRegister = YES;
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
    if (self.qqInfo || self.weChatInfo || self.appleInfo) {
        return;
    }
    
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"common_default_avatar"] forState:UIControlStateNormal];
    self.nameEditView.textField.text = @"我是一个小萌新";
    self.birthEditView.textField.text = @"2000-01-01";
    [self isShowSaveEnabled];
}

- (void)selectViewTapAction:(UITapGestureRecognizer *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"性别选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    @weakify(self);
    UIAlertAction *manAlert = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.seleceSexLabel.text = @"男";
        self.seleceSexLabel.textColor = XCTheme.getTTMainTextColor;
        self.isMan = YES;
    }];
    
    UIAlertAction *womanAlert = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.seleceSexLabel.text = @"女";
        self.seleceSexLabel.textColor = XCTheme.getTTMainTextColor;
        self.isMan = NO;
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertVC addAction:manAlert];
    [alertVC addAction:womanAlert];
    [alertVC addAction:actionCancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)initView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.randomAvatarButton];
    [self.view addSubview:self.nameEditView];
    [self.view addSubview:self.randomNickButton];
    [self.view addSubview:self.nameEditLineView];
    [self.view addSubview:self.seleceSexView];
    [self.seleceSexView addSubview:self.seleceSexLabel];
    [self.seleceSexView addSubview:self.seleceSexImageView];
    [self.view addSubview:self.seleceSexLineView];
    [self.view addSubview:self.birthEditView];
    [self.view addSubview:self.birthEditLineView];
    [self.view addSubview:self.tipsImageView];
    [self.view addSubview:self.tipsLabel];
    
    [self.view addSubview:self.saveButton];
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipImageView];
    
    [self.nameEditView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.manButton addTarget:self action:@selector(didClickManSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton addTarget:self action:@selector(didClickWomanSelectButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        if (KScreenWidth > 320) {//适配 iPhone 5 文字重叠
            make.top.mas_equalTo(kNavigationHeight + 21);
        } else {
            make.top.mas_equalTo(kNavigationHeight);
        }
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(40);
        make.width.height.mas_equalTo(85);
    }];
    
    [self.randomAvatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.photoButton);
        make.width.height.mas_equalTo(27);
    }];
    
    [self.nameEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(self.photoButton.mas_bottom).offset(16);
        make.height.mas_equalTo(44);
    }];
    
    [self.randomNickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self.nameEditView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(38);
    }];
    
    [self.nameEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.nameEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.seleceSexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.nameEditView.mas_bottom).offset(26);
    }];
    
    [self.seleceSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.seleceSexView);
    }];
    
    [self.seleceSexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.seleceSexView);
    }];
    
    [self.seleceSexLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.seleceSexView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.birthEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameEditView);
        make.top.mas_equalTo(self.seleceSexView.mas_bottom).offset(26);
    }];
    
    [self.birthEditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(26);
        make.top.mas_equalTo(self.birthEditView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.top.mas_equalTo(self.birthEditView.mas_bottom).offset(16);
        make.left.mas_equalTo(26);
    }];

    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.tipsImageView.mas_centerY);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(38);
        if (KScreenWidth > 320) {//适配 iPhone 5 文字重叠
            make.bottom.mas_equalTo(self.view).offset(-kSafeAreaBottomHeight - 107);
        } else {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(55);
        }
        make.height.mas_equalTo(44);
    }];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)onClickRandomButtonClickAction:(UIButton *)btn {
    [GetCore(UserCore) userRandomInfoWithType:btn.tag];
    
    if (btn.tag == 1000) {
        [TTStatisticsService trackEvent:@"information_random_avatar" eventDescribe:@"随机头像"];
    } else if (btn.tag == 1001) {
        [TTStatisticsService trackEvent:@"information_random_name" eventDescribe:@"随机昵称"];
    }
}

#pragma mark - getters and setters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = XCTheme.getTTMainTextColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        _titleLabel.text = @"填写资料";
    }
    return _titleLabel;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.layer.masksToBounds = YES;
        _photoButton.layer.cornerRadius = 42;
        [_photoButton setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
        [_photoButton addTarget:self action:@selector(didClickPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _photoButton;
}

- (UIButton *)randomAvatarButton {
    if (!_randomAvatarButton) {
        _randomAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_randomAvatarButton setImage:[UIImage imageNamed:@"randomAvatar_icon"] forState:UIControlStateNormal];
        _randomAvatarButton.tag = 1000;
        [_randomAvatarButton addTarget:self action:@selector(onClickRandomButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _randomAvatarButton.hidden = YES;
    }
    return _randomAvatarButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        _saveButton.layer.cornerRadius = 22;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveButton addTarget:self action:@selector(didClickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        if (projectType() == ProjectType_LookingLove) {
            _saveButton.layer.borderWidth = 2;
            _saveButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
            [_saveButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        } else if (projectType() == ProjectType_Planet) {
            _saveButton.backgroundColor = XCTheme.getTTMainColor;
            [_saveButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
    }
    return _saveButton;
}

- (TTAuthEditView *)nameEditView {
    if (!_nameEditView) {
        _nameEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请输入昵称"];
        _nameEditView.textField.delegate = self;
        _nameEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _nameEditView;
}

- (UIButton *)randomNickButton {
    if (!_randomNickButton) {
        _randomNickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_randomNickButton setTitle:@"随机" forState:UIControlStateNormal];
        [_randomNickButton setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
        [_randomNickButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_randomNickButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_randomNickButton addTarget:self action:@selector(onClickRandomButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _randomNickButton.layer.cornerRadius = 5;
        _randomNickButton.layer.masksToBounds = YES;
        _randomNickButton.tag = 1001;
        [_randomNickButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        _randomNickButton.hidden = YES;
    }
    return _randomNickButton;
}

- (UIView *)nameEditLineView {
    if (!_nameEditLineView) {
        _nameEditLineView = [[UIView alloc] init];
        _nameEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _nameEditLineView;
}

- (UIView *)seleceSexView {
    if (!_seleceSexView) {
        _seleceSexView = [[UIView alloc] init];
        UITapGestureRecognizer *tapSelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTapAction:)];
        [_seleceSexView addGestureRecognizer:tapSelect];
    }
    return _seleceSexView;
}

- (UILabel *)seleceSexLabel {
    if (!_seleceSexLabel) {
        _seleceSexLabel = [[UILabel alloc] init];
        _seleceSexLabel.textColor = UIColorFromRGB(0xB3B3B3);
        _seleceSexLabel.font = [UIFont systemFontOfSize:15];
        _seleceSexLabel.text = @"请选择性别（选择后不可更改）";
    }
    return _seleceSexLabel;
}

- (UIImageView *)seleceSexImageView {
    if (!_seleceSexImageView) {
        _seleceSexImageView = [[UIImageView alloc] init];
        _seleceSexImageView.image = [UIImage imageNamed:@"littleworld_edit_select"];
    }
    return _seleceSexImageView;
}

- (UIView *)seleceSexLineView {
    if (!_seleceSexLineView) {
        _seleceSexLineView = [[UIView alloc] init];
        _seleceSexLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _seleceSexLineView;
}

- (TTAuthEditView *)birthEditView {
    if (!_birthEditView) {
        _birthEditView = [[TTAuthEditView alloc] initWithPlaceholder:@"请选择生日"];
        _birthEditView.textField.delegate = self;
        _birthEditView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _birthEditView;
}

- (UIView *)birthEditLineView {
    if (!_birthEditLineView) {
        _birthEditLineView = [[UIView alloc] init];
        _birthEditLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _birthEditLineView;
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
        _tipsLabel.text = @"未满18岁的小朋友不可以注册哦~";
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textColor = [XCTheme getTTMainTextColor];
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
    
    @weakify(self);
    [self.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:weChatInfo.headimgurl] forState:(UIControlState)UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        
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
    
    @weakify(self);
    [self.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:qqInfo.figureurl_qq_2] forState:(UIControlState)UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        
        [self isShowSaveEnabled];
        
    }];
    
    self.nameEditView.textField.text = qqInfo.nickname;
    self.birthEditView.textField.text = @"2000-01-01";
    [self isShowSaveEnabled];
}

- (void)setAppleInfo:(AppleAccountInfo *)appleInfo {
    _appleInfo = appleInfo;
    if (!appleInfo) {
        return;
    }
    
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"common_default_avatar"] forState:UIControlStateNormal];
    self.birthEditView.textField.text = @"2000-01-01";
    
    // 如果使用苹果登录，获取不到用户的全称
    if (appleInfo.fullName.familyName && appleInfo.fullName.givenName) {
        self.nameEditView.textField.text = appleInfo.appleFullName;
        
    } else if (appleInfo.fullName.familyName) {
        self.nameEditView.textField.text = appleInfo.fullName.familyName;
        
    } else if (appleInfo.fullName.givenName) {
        self.nameEditView.textField.text = appleInfo.fullName.givenName;
        
    } else {
        self.nameEditView.textField.text = @"我是一个小萌新";
    }
    
    [self isShowSaveEnabled];
}

- (void)setIsMan:(BOOL)isMan{
    _isMan = isMan;
    
    [self isShowSaveEnabled];
    self.isSelectedSex = YES;
}

@end
