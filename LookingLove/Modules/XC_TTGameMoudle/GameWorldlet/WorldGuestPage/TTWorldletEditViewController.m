//
//  TTWorldletEditViewController.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletEditViewController.h"
/** 类内部 view(cell) */
#import "TTWorldletTypeListView.h"

/** module 内 view(cell)（业务组件自定义view） */
/** module 内 工具类（业务组件的工具类）*/
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "UIButton+EnlargeTouchArea.h"
#import "XCHUDTool.h"
#import "FileCore.h"
#import "LittleWorldCore.h"
#import "FileCoreClient.h"
#import "TTServiceCore.h"
#import <UIButton+WebCache.h>
#import "AuthCore.h"
/** VC */
/** bridge */
/** xc_tt（兔兔私有组件） */
#import "TTPopup.h"
/** xc类 （平台公共组件） */
#import "LittleWorldCore.h"

/** 第三方工具（第三方pod） */
#import <Masonry/Masonry.h> // 约束
#import "TTWKWebViewViewController.h"
#import "ClientCore.h"
#import "XCHtmlUrl.h"

@interface TTWorldletEditViewController ()<TTWorldletTypeListViewDelegate,FileCoreClient,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *categoryLabel; // 选择小世界分类标题
@property (nonatomic, strong) UILabel *cateLabel; // 小世界分类名称
@property (nonatomic, strong) UIButton *cateSelectBtn; // 选择小世界分类
@property (nonatomic, strong) UIImageView *cateSelectImage; // 选择小世界分类
@property (nonatomic, strong) UIView *cateLineView;  // 分隔线
@property (nonatomic, strong) UILabel *nameLael;  //  小世界名称
@property (nonatomic, strong) UILabel *nameNumLabel;  // 小世界字数限制
@property (nonatomic, strong) UITextField *nameTextField; // 小世界名称输入框
@property (nonatomic, strong) UIView *nameLineView; // 分割线
@property (nonatomic, strong) UILabel *describeLabel; // 小世界描述
@property (nonatomic, strong) UILabel *desNumLabel;  // 小世界描述字数限制
@property (nonatomic, strong) UIView *desView;  // 小世界描述输入框背景
@property (nonatomic, strong) UITextView *desTextView; // 小世界描述输入框
@property (nonatomic, strong) UILabel *desTextLabel; // 小世界描述输入框 ploceHolder
@property (nonatomic, strong) UILabel *noticeLabel;  // 小世界公告
@property (nonatomic, strong) UILabel *notiNumLabel;  // 小世界公告字数限制
@property (nonatomic, strong) UIView *noticeView; // 小世界公告输入框背景
@property (nonatomic, strong) UITextView *noticeTextView;  // 小世界公告输入框
@property (nonatomic, strong) UILabel *noticeTextLabel; // 小世界描述输入框 ploceHolder
@property (nonatomic, strong) UILabel *coverLabel; // 小世界封面
@property (nonatomic, strong) UIView *selectBackView; // 选择图片的背景View
@property (nonatomic, strong) UIButton *selectImageBtn; // 选择图片
@property (nonatomic, strong) UIImageView *selectImageView; // 选择图片指引
@property (nonatomic, strong) UILabel *permissionsLabel; // 小世界权限
@property (nonatomic, strong) UIButton *applyButton; // 申请进入
@property (nonatomic, strong) UIButton *enterButton; // 任何人都可以
@property (nonatomic, strong) UIButton *amendButton; // 确认修改
@property (nonatomic, strong) UIButton *contactButton;  // 联系客服
@property (nonatomic, assign) BOOL agreeIndex;
@property (nonatomic, strong) NSMutableDictionary *textDictionary;
@property (nonatomic, strong) LittleWorldCategory *categoryModel;
@end

@implementation TTWorldletEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"编辑资料";
    
    AddCoreClient(FileCoreClient, self);
    
    [self initView];
    [self initConstraint];
    
    //隐藏小世界申请权限，默认所有人可进
    self.permissionsLabel.hidden = YES;
    self.applyButton.hidden = YES;
    self.enterButton.hidden = YES;
}

- (void)initView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.categoryLabel];
    [self.scrollView addSubview:self.cateLabel];
    [self.scrollView addSubview:self.cateSelectBtn];
    [self.scrollView addSubview:self.cateSelectImage];
    [self.scrollView addSubview:self.cateLineView];
    [self.scrollView addSubview:self.nameLael];
    [self.scrollView addSubview:self.nameNumLabel];
    [self.scrollView addSubview:self.nameTextField];
    [self.scrollView addSubview:self.nameLineView];
    [self.scrollView addSubview:self.describeLabel];
    [self.scrollView addSubview:self.desNumLabel];
    [self.scrollView addSubview:self.desView];
    [self.desView addSubview:self.desTextView];
    [self.desView addSubview:self.desTextLabel];
    [self.scrollView addSubview:self.noticeLabel];
    [self.scrollView addSubview:self.notiNumLabel];
    [self.scrollView addSubview:self.noticeView];
    [self.noticeView addSubview:self.noticeTextView];
    [self.noticeView addSubview:self.noticeTextLabel];
    [self.scrollView addSubview:self.coverLabel];
    [self.scrollView addSubview:self.selectBackView];
    [self.selectBackView addSubview:self.selectImageBtn];
    [self.selectBackView addSubview:self.selectImageView];
    [self.scrollView addSubview:self.permissionsLabel];
    [self.scrollView addSubview:self.applyButton];
    [self.scrollView addSubview:self.enterButton];
    [self.scrollView addSubview:self.amendButton];
    [self.scrollView addSubview:self.contactButton];
}

- (void)initConstraint {
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
    }];
    
    [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.categoryLabel.mas_bottom).offset(20);
    }];
    
    [self.cateSelectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.cateLabel);
    }];
    
    [self.cateSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cateSelectImage.mas_left).offset(-11);
        make.centerY.mas_equalTo(self.cateLabel);
    }];
    
    [self.cateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.cateSelectBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(1);
    }];

    [self.nameLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.cateLineView.mas_bottom).offset(34);

    }];

    [self.nameNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.nameLael);
    }];

    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.nameNumLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(33);
    }];

    [self.nameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(10);
    }];

    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.nameLineView.mas_bottom).offset(35);
    }];

    [self.desNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.describeLabel);
    }];

    [self.desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.desNumLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(87);
    }];
    
    [self.desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(self.desView.mas_right).offset(-11);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.desTextLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(13);
    }];

    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.desView.mas_bottom).offset(35);
    }];

    [self.notiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.noticeLabel);
    }];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.notiNumLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(150);
    }];

    [self.noticeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(self.noticeView.mas_right).offset(-11);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.noticeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(13);
    }];
    
    [self.coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.noticeView.mas_bottom).offset(35);
    }];
    
    [self.selectBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.coverLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(73);
    }];
    
    [self.selectImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
 
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectBackView.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.selectImageBtn);
    }];
    
    [self.permissionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.selectBackView.mas_bottom).offset(35);
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.permissionsLabel.mas_bottom).offset(16);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-78);
        make.centerY.mas_equalTo(self.applyButton);
    }];
    
    [self.amendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.top.mas_equalTo(self.selectBackView.mas_bottom).offset(44);
        make.size.mas_equalTo(CGSizeMake(320, 43));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amendButton.mas_bottom).offset(25);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationHeight);
        make.bottom.mas_greaterThanOrEqualTo(self.contactButton.mas_bottom).offset(26);
    }];
    
}

- (void)setModel:(LittleWorldListItem *)model {
    _model = model;
    
    if (model.typeName.length > 0) {
        self.cateLabel.text = model.typeName;
        [self.textDictionary setValue:model.typeName forKey:@"typeName"];
    }
    
    if (model.name.length > 0) {
        self.nameNumLabel.text = [NSString stringWithFormat:@"%ld/7",model.name.length];
        self.nameTextField.text = model.name;
        [self.textDictionary setValue:self.nameTextField.text forKey:@"textField"];
    }
    
    if (model.desc.length > 0) {
        self.desTextLabel.hidden = YES;
        self.desTextView.text = model.desc;
        self.desNumLabel.text = [NSString stringWithFormat:@"%ld/36",model.desc.length];
        [self.textDictionary setValue:self.desTextView.text forKey:@"desTextView"];
    }
    
    if (model.notice.length > 0) {
        self.noticeTextLabel.hidden = YES;
        self.noticeTextView.text = model.notice;
        self.notiNumLabel.text = [NSString stringWithFormat:@"%ld/500",model.notice.length];
        [self.textDictionary setValue:self.noticeTextView.text forKey:@"noticeTextView"];
    }
    
    if (model.icon.length > 0) {
        [self.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal];
        [self.textDictionary setValue:model.icon forKey:@"icon"];
    }
    
    if (model.agreeFlag) {
        self.applyButton.selected = YES;
    } else {
        self.enterButton.selected = YES;
    }
    self.agreeIndex = model.agreeFlag;
    
    if (model.typeName.length > 0 && model.name.length > 0 && model.desc.length > 0 && model.notice.length > 0 && model.icon.length > 0) {
        self.amendButton.backgroundColor = UIColorFromRGB(0xFFB606);
        self.amendButton.userInteractionEnabled = YES;
    }
}

#pragma mark --- TTWorldletTypeListViewDelegate ---
- (void)worldletTypeClickWithName:(LittleWorldCategory *)model {
    _categoryModel = model;
    
    self.cateLabel.text = model.typeName;
    
    [self updateAmendButtonStatus];
    
    [TTPopup dismiss];
}

- (void)worldletTypeViewDismiss:(TTWorldletTypeListView *_Nonnull)view {
    [TTPopup dismiss];
}

#pragma mark --- button Aciton ---
// 选择世界type
- (void)selectWorldTypeList:(UIButton *)sender {
    [GetCore(LittleWorldCore) fetchWorldCategoryListWithRefresh:YES completion:^(NSArray<LittleWorldCategory *> * _Nonnull data, NSNumber * _Nonnull errorCode, NSString * _Nonnull msg) {
        if (data) {
            
            TTWorldletTypeListView *listView = [[TTWorldletTypeListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            listView.dataArray = [data mutableCopy];
            listView.delegate = self;
            [TTPopup popupView:listView style:TTPopupStyleActionSheet];
            
        } else {
            [XCHUDTool showErrorWithMessage:msg];
        }
    }];
}

// 申请进入
- (void)appleBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.enterButton.selected = NO;
        self.agreeIndex = YES;
    }
}

// 任何人都可以
- (void)enterBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.applyButton.selected = NO;
        self.agreeIndex = NO;
    }
}

// 确认修改
- (void)amendBtnAction:(UIButton *)sender {
    [[GetCore(LittleWorldCore) requestWorldLetEditDataWithWorld:self.model.worldId uid:self.model.ownerUid.userIDValue name:self.nameTextField.text icon:[self.textDictionary objectForKey:@"icon"] description:self.desTextView.text notice:self.noticeTextView.text worldTypeId:self.categoryModel.typeId agreeFlag:self.agreeIndex] subscribeError:^(NSError *error) {
        [XCHUDTool showErrorWithMessage:error.domain];
    } completed:^{
        [XCHUDTool showSuccessWithMessage:@"修改成功"];
        [GetCore(LittleWorldCore) requestWorldLetDetailDataWithUid:self.model.worldId uid:GetCore(AuthCore).getUid.userIDValue];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

// 找客服
- (void)contactBtnAction:(UIButton *)sender {
//    if(GetCore(ClientCore).customerType == 1){
//        [self.navigationController pushViewController:[GetCore(TTServiceCore) getQYSessionViewController] animated:YES];
//    }else{
        TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
        webView.urlString = HtmlUrlKey(kLive800);
        [self.navigationController pushViewController:webView animated:YES];
//    }
}

#pragma mark --- UITextView ---
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.desTextView) {
        if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) { // 说明只有空格
            [self.textDictionary removeObjectForKey:@"desTextView"];
            self.noticeTextLabel.hidden = NO;
            [self updateAmendButtonStatus];
            return;
        }
        if (textView.text.length > 0) {
            [self.textDictionary setValue:textView.text forKey:@"desTextView"];
        } else {
            [self.textDictionary removeObjectForKey:@"desTextView"];
            self.desTextLabel.hidden = NO;
        }
    }else if (textView == self.noticeTextView) {
        if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) { // 说明只有空格
            [self.textDictionary removeObjectForKey:@"noticeTextView"];
            self.noticeTextLabel.hidden = NO;
            [self updateAmendButtonStatus];
            return;
        }
        if (textView.text.length > 0) {
            [self.textDictionary setValue:textView.text forKey:@"noticeTextView"];
        } else {
            [self.textDictionary removeObjectForKey:@"noticeTextView"];
            self.noticeTextLabel.hidden = NO;
        }
    }
    [self updateAmendButtonStatus];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.desTextView) {
        self.desTextLabel.hidden = YES;
    }else if (textView == self.noticeTextView) {
        self.noticeTextLabel.hidden = YES;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger maxNum = 0;
    
    if (textView == self.desTextView) {
        maxNum = 36;
    }else if (textView == self.noticeTextView) {
        maxNum = 500;
    }
    //删除
    if (text.length == 0) {
        if (textView == self.desTextView) {
            self.desNumLabel.text = [NSString stringWithFormat:@"%lu/36", range.location];
        }else if (textView == self.noticeTextView) {
            self.notiNumLabel.text = [NSString stringWithFormat:@"%lu/500", range.location];
        }
        return YES;
    }
    
    NSMutableString *mText = [NSMutableString stringWithString:textView.text];
    [mText insertString:text atIndex:range.location];
    
    //字数在范围内
    if (mText.length >= maxNum) {
        //字数在范围外
        textView.text = [mText substringToIndex:maxNum];
        if (textView == self.desTextView) {
            self.desNumLabel.text = [NSString stringWithFormat:@"%lu/36", textView.text.length];
        }else if (textView == self.noticeTextView) {
            self.notiNumLabel.text = [NSString stringWithFormat:@"%lu/500", textView.text.length];
        }
        return NO;
    }
    
    if (textView == self.desTextView) {
        self.desNumLabel.text = [NSString stringWithFormat:@"%lu/36", mText.length];
    }else if (textView == self.noticeTextView) {
        self.notiNumLabel.text = [NSString stringWithFormat:@"%lu/500", mText.length];
    }
    return YES;
}

#pragma mark --- UITextField ---
- (void)textFieldInputEnd:(UITextField *)textField {
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) { // 说明只有空格
        [self.textDictionary removeObjectForKey:@"textField"];
        [self updateAmendButtonStatus];
        return;
    }
    
    if (textField.text.length > 0) {
        [self.textDictionary setValue:textField.text forKey:@"textField"];
    } else {
        [self.textDictionary removeObjectForKey:@"textField"];
    }
    [self updateAmendButtonStatus];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除
    if (string.length == 0) {
        [self updateCount:range.location];
        return YES;
    }
    
    NSMutableString *mText = [NSMutableString stringWithString:textField.text];
    [mText insertString:string atIndex:range.location];
    
    //字数在范围内
    if (mText.length >= 7) {
        //字数在范围外
        textField.text = [mText substringToIndex:7];
        [self updateCount:textField.text.length];
        return NO;
    }
    
    [self updateCount:mText.length];
    
    return YES;
}

/// 更新计数
- (void)updateCount:(unsigned long)count {
    self.nameNumLabel.text = [NSString stringWithFormat:@"%lu/7", count];
}

#pragma mark --- 选择图片 ---
- (void)selectImageAction {
    [self showPhotoView];
}

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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (selectedPhoto) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
        }
        [GetCore(FileCore) qiNiuUploadImage:selectedPhoto uploadType:UploadDataTypeLittleWorld];
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - FileCoreClient
- (void)didUploadTTLittleWorldImageSuccess:(NSString *)key {
    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim",keyWithType(KeyType_QiNiuBaseURL, NO),key];//KeyType_QiNiuBaseURL
    
    [self.selectImageBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    
    [self.textDictionary setValue:url forKey:@"icon"];
    
    [self updateAmendButtonStatus];
}

- (void)didUploadTTLittleWorldFail:(NSString *)message{
    [XCHUDTool showErrorWithMessage:@"请求失败，请检查网络" inView:self.view];
}

- (void)updateAmendButtonStatus {
    if (self.textDictionary.allKeys.count == 5) {
        self.amendButton.backgroundColor = UIColorFromRGB(0xFFB606);
        self.amendButton.userInteractionEnabled = YES;
    } else {
        self.amendButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        self.amendButton.userInteractionEnabled = NO;
    }
}


#pragma mark --- setter ---
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UILabel *)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.text = @"选择一个小世界分类";
        _categoryLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _categoryLabel.font = [UIFont systemFontOfSize:14];
    }
    return _categoryLabel;
}

- (UILabel *)cateLabel {
    if (!_cateLabel) {
        _cateLabel = [[UILabel alloc] init];
        _cateLabel.textColor = UIColorFromRGB(0x333333);
        _cateLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cateLabel;
}

- (UIButton *)cateSelectBtn {
    if (!_cateSelectBtn) {
        _cateSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cateSelectBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_cateSelectBtn setTitleColor:UIColorFromRGB(0xB1B1B2) forState:UIControlStateNormal];
        _cateSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cateSelectBtn addTarget:self action:@selector(selectWorldTypeList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cateSelectBtn;
}

- (UIImageView *)cateSelectImage {
    if (!_cateSelectImage) {
        _cateSelectImage = [[UIImageView alloc] init];
        _cateSelectImage.image = [UIImage imageNamed:@"littleworld_edit_select"];
    }
    return _cateSelectImage;
}

- (UIView *)cateLineView {
    if (!_cateLineView) {
        _cateLineView = [[UIView alloc] init];
        _cateLineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    }
    return _cateLineView;
}

- (UILabel *)nameLael {
    if (!_nameLael) {
        _nameLael = [[UILabel alloc] init];
        _nameLael.text = @"小世界名称";
        _nameLael.textColor = UIColorFromRGB(0xB1B1B3);
        _nameLael.font = [UIFont systemFontOfSize:14];
    }
    return _nameLael;
}

- (UILabel *)nameNumLabel {
    if (!_nameNumLabel) {
        _nameNumLabel = [[UILabel alloc] init];
        _nameNumLabel.text = @"0/7";
        _nameNumLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _nameNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameNumLabel;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.textColor = UIColorFromRGB(0x333333);
        _nameTextField.font = [UIFont systemFontOfSize:15];
        _nameTextField.placeholder = @"请输入小世界名称";
        [_nameTextField addTarget:self action:@selector(textFieldInputEnd:) forControlEvents:UIControlEventEditingDidEnd];
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UIView *)nameLineView {
    if (!_nameLineView) {
        _nameLineView = [[UIView alloc] init];
        _nameLineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    }
    return _nameLineView;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.text = @"小世界描述";
    }
    return _describeLabel;
}

- (UILabel *)desNumLabel {
    if (!_desNumLabel) {
        _desNumLabel = [[UILabel alloc] init];
        _desNumLabel.text = @"0/36";
        _desNumLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _desNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _desNumLabel;
}

- (UIView *)desView {
    if (!_desView) {
        _desView = [[UIView alloc] init];
        _desView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _desView.layer.cornerRadius = 15;
        _desView.layer.masksToBounds = YES;
    }
    return _desView;
}

- (UITextView *)desTextView {
    if (!_desTextView) {
        _desTextView = [[UITextView alloc] init];
        _desTextView.textColor = UIColorFromRGB(0x333333);
        _desTextView.font = [UIFont systemFontOfSize:15];
        _desTextView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        _desTextView.delegate = self;
    }
    return _desTextView;
}

- (UILabel *)desTextLabel {
    if (!_desTextLabel) {
        _desTextLabel = [[UILabel alloc] init];
        _desTextLabel.text = @"请输入小世界描述";
        _desTextLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _desTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _desTextLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"小世界公告";
        _noticeLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _noticeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noticeLabel;
}

- (UILabel *)notiNumLabel {
    if (!_notiNumLabel) {
        _notiNumLabel = [[UILabel alloc] init];
        _notiNumLabel.text = @"0/500";
        _notiNumLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _notiNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _notiNumLabel;
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        _noticeView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _noticeView.layer.cornerRadius = 15;
        _noticeView.layer.masksToBounds = YES;
    }
    return _noticeView;
}

- (UITextView *)noticeTextView {
    if (!_noticeTextView) {
        _noticeTextView = [[UITextView alloc] init];
        _noticeTextView.textColor = UIColorFromRGB(0x333333);
        _noticeTextView.font = [UIFont systemFontOfSize:15];
        _noticeTextView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        _noticeTextView.delegate = self;
    }
    return _noticeTextView;
}

- (UILabel *)noticeTextLabel {
    if (!_noticeTextLabel) {
        _noticeTextLabel = [[UILabel alloc] init];
        _noticeTextLabel.text = @"请输入小世界公告";
        _noticeTextLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _noticeTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _noticeTextLabel;
}

- (UILabel *)coverLabel {
    if (!_coverLabel) {
        _coverLabel = [[UILabel alloc] init];
        _coverLabel.text = @"小世界封面";
        _coverLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _coverLabel.font = [UIFont systemFontOfSize:14];
    }
    return _coverLabel;
}

- (UIView *)selectBackView {
    if (!_selectBackView) {
        _selectBackView = [[UIView alloc] init];
        _selectBackView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageAction)];
        [_selectBackView addGestureRecognizer:tapGes];
    }
    return _selectBackView;
}

- (UIButton *)selectImageBtn {
    if (!_selectImageBtn) {
        _selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectImageBtn.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _selectImageBtn.layer.cornerRadius = 12;
        _selectImageBtn.layer.masksToBounds = YES;
        [_selectImageBtn setImage:[UIImage imageNamed:@"gameWorldlet_add"] forState:UIControlStateNormal];
        _selectImageBtn.userInteractionEnabled = NO;
    }
    return _selectImageBtn;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"discover_family_arrow"];
    }
    return _selectImageView;
}

- (UILabel *)permissionsLabel {
    if (!_permissionsLabel) {
        _permissionsLabel = [[UILabel alloc] init];
        _permissionsLabel.text = @"小世界权限";
        _permissionsLabel.textColor = UIColorFromRGB(0xB1B1B3);
        _permissionsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _permissionsLabel;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyButton setTitle:@"  申请通过可进入" forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_applyButton setTitleColor:UIColorFromRGB(0xB1B1B3) forState:UIControlStateNormal];
        [_applyButton setTitleColor:XCTheme.getTTMainTextColor forState:UIControlStateSelected];
        [_applyButton setImage:[UIImage imageNamed:@"gameWorldlet_unselected"] forState:UIControlStateNormal];
        [_applyButton setImage:[UIImage imageNamed:@"gameWorldlet_selected"] forState:UIControlStateSelected];
        [_applyButton addTarget:self action:@selector(appleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"  所有人可进" forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_enterButton setTitleColor:UIColorFromRGB(0xB1B1B3) forState:UIControlStateNormal];
        [_enterButton setTitleColor:XCTheme.getTTMainTextColor forState:UIControlStateSelected];
        [_enterButton setImage:[UIImage imageNamed:@"gameWorldlet_unselected"] forState:UIControlStateNormal];
        [_enterButton setImage:[UIImage imageNamed:@"gameWorldlet_selected"] forState:UIControlStateSelected];
        [_enterButton addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)amendButton {
    if (!_amendButton) {
        _amendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _amendButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        _amendButton.layer.cornerRadius = 22;
        [_amendButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_amendButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _amendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _amendButton.userInteractionEnabled = NO;
        [_amendButton addTarget:self action:@selector(amendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _amendButton;
}

- (UIButton *)contactButton {
    if (!_contactButton) {
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setTitle:@"如有疑问请联系客服 >" forState:UIControlStateNormal];
        _contactButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_contactButton setTitleColor:UIColorFromRGB(0x00a1ea) forState:UIControlStateNormal];
        [_contactButton addTarget:self action:@selector(contactBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactButton;
}

- (NSMutableDictionary *)textDictionary {
    if (!_textDictionary) {
        _textDictionary = [NSMutableDictionary dictionary];
    }
    return _textDictionary;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

@end
