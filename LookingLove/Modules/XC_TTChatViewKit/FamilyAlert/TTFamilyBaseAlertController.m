//
//  TTFamilyBaseAlertController.m
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyBaseAlertController.h"
#import "TTFamilyMessageView.h"
#import "XCMacros.h"
#import "TTFamilyShareAlertView.h"
#import "TTFamilyBottomShareView.h"
#import "MMSheetView.h"
#import "UIImage+Utils.h"

@interface TTFamilyBaseAlertController ()<TTFamilyMessageViewDelegate, TTFamilyShareAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) ActionBlock  sureBlock;
@property (nonatomic, copy) ActionBlock cancleBlock;
@property (nonatomic, copy) TextBlock textBlock;
@property (nonatomic, strong) UIViewController * controller;
@property (nonatomic, assign) id<TTFamilyBaseAlertControllerDelegate>delegate;
@end

@implementation TTFamilyBaseAlertController
/** 这个代码 不能删除 因为继承了一个 单利 如果删除这个 可能会出现崩溃 找不到子类的方法*/
+ (instancetype)defaultCenter{
    static dispatch_once_t onceToken = 0;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

/** 只展示文字没有输入框*/
- (void)showAlertViewWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok{
    if (!config) {
        return;
    }
    CGFloat height = 190;
    CGFloat textHeight = 0;
    if (config.content && config.content.length > 0) {
        //文字的高度
      textHeight = [self getContentheightWiht:config.content];
    }
    if (textHeight + 142 > height) {
        height = textHeight + 142;
    }
    config.textFiledHidden = YES;
    TTFamilyMessageView * messageView = [[TTFamilyMessageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, height) withConfig:config];
    messageView.delegate = self;
    self.sureBlock = sureBlock;
    self.cancleBlock = cancleBlcok;
    [[TTFamilyBaseAlertController defaultCenter] presentAlertWith:controller view:messageView dismissBlock:nil];
}

/** 有输入框*/
- (void)showAlertViewWithTextFiledWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok text:(TextBlock)textBlock{
    if (!config) {
        return;
    }
    CGFloat height = 210;
    CGFloat textHeight = 0;
    CGFloat contribuHeight = 0;//除开文字显示的其余的高度
    if (config.contribuMember && config.contribuMember.length > 0) {
        //家族b 转让
        contribuHeight = 200;
    }else{
        contribuHeight = 180;
    }
    if (config.content && config.content.length > 0) {
        //文字的高度
        textHeight = [self getContentheightWiht:config.content];
    }
    if (textHeight + contribuHeight > height) {
        height = textHeight + contribuHeight;
    }
    config.textFiledHidden = NO;
    TTFamilyMessageView * messageView = [[TTFamilyMessageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, height) withConfig:config];
    messageView.delegate = self;
    self.sureBlock = sureBlock;
    self.cancleBlock = cancleBlcok;
    self.textBlock = textBlock;
    [self presentAlertWith:controller view:messageView dismissBlock:nil];
}

/** 族长邀请好友的弹框*/
- (void)showShareAlertViewWith:(UIViewController *)controller alertConfig:(TTFamilyAlertModel *)config sure:(ActionBlock)sureBlock canle:(nullable ActionBlock)cancleBlcok{
    if (!config) {
        return;
    }
    CGFloat width;
    if (KScreenWidth > 320) {
        width = KScreenWidth - 80;
    }else{
        width = KScreenWidth - 60;
    }
    TTFamilyShareAlertView * shareAlertView = [[TTFamilyShareAlertView alloc] initWithFrame:CGRectMake(0, 0, width, 212) config:config];
    shareAlertView.delegate = self;
    self.sureBlock = sureBlock;
    self.cancleBlock = cancleBlcok;
    [[TTFamilyBaseAlertController defaultCenter] presentAlertWith:controller view:shareAlertView dismissBlock:nil];
}
/** 谈起分享框*/
- (void)shareAppcationActionSheetWith:(UIViewController *)controller{
    TTFamilyBottomShareView * shareView = [[TTFamilyBottomShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 202)];
    shareView.currentVC = controller;
    shareView.familyModel = self.family;
    shareView.groupModel = self.group;
    [[TTFamilyBaseAlertController defaultCenter] presentAlertWith:controller view:shareView preferredStyle:TYAlertControllerStyleActionSheet dismissBlock:nil completionBlock:nil];
}
/**选择图片*/
- (void)showChoosePhotoWith:(UIViewController *)controller delegate:(nonnull id<TTFamilyBaseAlertControllerDelegate>)delegate{
    self.controller = controller;
    self.delegate = delegate;
    [self showPhotoViewWith:controller];
}

/**消失*/
- (void)dismissAlert{
    [[TTFamilyBaseAlertController defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
}
#pragma mark - 选择图片
- (void)showPhotoViewWith:(UIViewController *)controller{
    NSMutableArray *items = [NSMutableArray array];
    @weakify(self);
    [items addObject:MMItemMake(@"拍照上传",MMItemTypeNormal, ^(NSInteger index) {
        [YYUtility checkCameraAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            [controller presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相机权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相机不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
        
    })];
    [items addObject:MMItemMake(@"本地相册",MMItemTypeNormal, ^(NSInteger index) {
        [YYUtility checkAssetsLibrayAvailable:^{
            @strongify(self);
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            [controller presentViewController:imagePicker animated:YES completion:NULL];
        } denied:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        } restriction:^{
            @strongify(self);
            [self showNotPhoto:@"相册不可用" content:@"相册权限受限,点击确定去系统设置"];
        }];
        
    })];
    MMSheetView*alert = [[MMSheetView alloc]initWithStyle:MMSheetViewStyleCornerRadius title:nil items:items];
    alert.type = MMPopupTypeSheet;
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    alert.animationDuration = 0.1;
    [alert show];
}

- (void)showNotPhoto:(NSString *)title content:(NSString *)content {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *enter = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:enter];
    [self.controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
        if (selectedPhoto) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
            }
            selectedPhoto = [UIImage fixOrientation:selectedPhoto];
            if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerdidFinishPickingMediaWithInfo:)]) {
                [self.delegate imagePickerControllerdidFinishPickingMediaWithInfo:selectedPhoto];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TTFamilyShareAlertViewDelegate
- (void)cancleActionDismissAlertView:(UIButton *)sender{
    if (self.cancleBlock) {
        self.cancleBlock();
    }else{
        [[TTFamilyBaseAlertController defaultCenter] dismissAlertNeedBlock:NO];
    }
}

#pragma mark - TTFamilyMessageViewDelegate
- (void)cancleDismissWith:(UIButton *)sender{
    if (self.cancleBlock) {
        self.cancleBlock();
    }else{
         [[TTFamilyBaseAlertController defaultCenter] dismissAlertNeedBlock:NO];
    }
}

- (void)sureButtonActionWith:(UIButton *)sender{
    if (self.sureBlock) {
        self.sureBlock();
        [self dismissAlert];
    }
}

- (void)textFiledChangeWith:(UITextField *)textFiled{
    if (self.textBlock) {
         self.textBlock(textFiled.text);
    }
}


- (CGFloat)getContentheightWiht:(NSString *)contet{
    CGSize size = [contet boundingRectWithSize:CGSizeMake(KScreenWidth - 80 -60, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return size.height+ 5;
}
@end
