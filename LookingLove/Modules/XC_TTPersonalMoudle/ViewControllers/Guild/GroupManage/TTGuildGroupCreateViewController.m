//
//  TTGuildGroupCreateViewController.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/8.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupCreateViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTGuildMemberlistViewController.h"

#import "TTGuildGroupContentCell.h"
#import "TTGuildGroupMultiLineTextCell.h"
#import "TTGuildGroupCollectionCell.h"

#import "TTGuildGroupManageConfig.h"
#import "TTGuildGroupCreateModel.h"

#import "TTRoomSettingsInputAlertView.h"

#import "XCMediator+TTPersonalMoudleBridge.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"
#import "TTGuildGroupManageConst.h"

#import "NSArray+Safe.h"
#import "UIImage+Utils.h"
#import "UIImageView+QiNiu.h"

#import "XCHUDTool.h"
#import "TTPopup.h"

#import "FileCore.h"
#import "FileCoreClient.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"

#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

static NSString *const kSeparateLineCellId = @"kSeparateLineCellId";
static NSString *const kContentCellId = @"kContentCellId";
static NSString *const kMultiLineCellId = @"kMultiLineCellId";
static NSString *const kCollectionCellId = @"kCollectionCellId";

@interface TTGuildGroupCreateViewController ()
<FileCoreClient,
GuildCoreClient,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSArray<TTGuildGroupManageConfig *> *dataSourceArray;


@property (nonatomic, strong) TTGuildGroupCreateModel *createModel;//群创建模型

@property (nonatomic, strong) GuildGroupInfoLimit *groupLimit;//群聊数量限制配置

@end

@implementation TTGuildGroupCreateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建群聊";
    
    self.createModel = [[TTGuildGroupCreateModel alloc] init];
    self.createModel.type = GuildHallGroupTypeOuter;
    
    [self configDataSource];
    [self initView];

    AddCoreClient(FileCoreClient, self);
    AddCoreClient(GuildCoreClient, self);
    
    [GetCore(GuildCore) requestGuildGroupInfoLimit];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar:
        case TTGuildGroupManageTypeName:
        case TTGuildGroupManageTypeMemberTitle:
        case TTGuildGroupManageTypeManagerTitle:
        case TTGuildGroupManageTypeNoticeTitle:
        case TTGuildGroupManageTypeMuteSetting:
        case TTGuildGroupManageTypeMsgDoNotDisturb:
        case TTGuildGroupManageTypeClassify: {
            TTGuildGroupContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kContentCellId forIndexPath:indexPath];
            cell.config = config;
            
            if (config.type==TTGuildGroupManageTypeAvatar && self.createModel.avatar.length>0) {
                [cell.avatarImageView qn_setImageImageWithUrl:self.createModel.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
            }
            
            if (config.type==TTGuildGroupManageTypeName && self.createModel.name.length>0) {
                cell.contentLabel.text = self.createModel.name;
            }
            
            if (config.type == TTGuildGroupManageTypeClassify) {
                @weakify(self)
                [cell setOuterGroupClickBlock:^{
                    @strongify(self)
                    self.createModel.type = GuildHallGroupTypeOuter;
                }];
                [cell setInnerGroupClickBlock:^{
                    @strongify(self)
                    self.createModel.type = GuildHallGroupTypeInner;
                }];
            }
            
            return cell;
        }
        case TTGuildGroupManageTypeMemberList: {
            TTGuildGroupCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionCellId forIndexPath:indexPath];
            cell.backgroundColor = config.nameColor;
            
            NSMutableArray *mArray = [NSMutableArray array];
            for (UserInfo *user in self.createModel.selectingUserArray) {
                [mArray addObject:user.avatar];
            }
            
            cell.dataModelArray = [mArray copy];
            
            return cell;
        }
        case TTGuildGroupManageTypeCreateDescribe:
        case TTGuildGroupManageTypeNotice: {
            TTGuildGroupMultiLineTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kMultiLineCellId forIndexPath:indexPath];
            cell.backgroundColor = config.type == TTGuildGroupManageTypeCreateDescribe ? UIColor.clearColor : UIColor.whiteColor;
            cell.contentLabel.text = config.name;
            cell.separateLine.hidden = !config.isShowUnderLine;
            return cell;
        }
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparateLineCellId forIndexPath:indexPath];
            cell.backgroundColor = config.nameColor;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar:
            return 74;
        case TTGuildGroupManageTypeName:
            return 54;
        case TTGuildGroupManageTypeSeparateLine:
            return 10;
        case TTGuildGroupManageTypeMemberList:
        case TTGuildGroupManageTypeManagerList: {
            if (self.createModel.selectingUserArray.count == 0) {
                return CGFLOAT_MIN;
            }
            
            NSInteger line = config.type == TTGuildGroupManageTypeManagerList ? 1 : 2;
            CGFloat height = (TTGuildGroupCollectionCellLenth+TTGuildGroupCollectionCellTopMargin+TTGuildGroupCollectionCellBottomMargin)*line;
            return height;
        }
        case TTGuildGroupManageTypeCreateDescribe:
        case TTGuildGroupManageTypeNotice:
            return UITableViewAutomaticDimension;
            
        default:
            return 54;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTGuildGroupManageConfig *config = self.dataSourceArray[indexPath.row];
    switch (config.type) {
        case TTGuildGroupManageTypeAvatar: {
            [self photoPicker];
        }
            break;
        case TTGuildGroupManageTypeName: {
            TTRoomSettingsInputAlertView *alert = [[TTRoomSettingsInputAlertView alloc] init];
            alert.title = @"群名称";
            alert.placeholder = @"请输入群名称";
            alert.content = self.createModel.name;
            alert.maxCount = 15;

            @weakify(self)
            [alert showAlertWithCompletion:^(NSString * _Nonnull content) {
                @strongify(self)
                self.createModel.name = content;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } dismiss:^{
            }];
        }
            break;
        case TTGuildGroupManageTypeMemberTitle: {
            TTGuildMemberlistViewController *vc = [[TTGuildMemberlistViewController alloc] init];
            vc.hallInfo = self.hallInfo;
            vc.listType = GuildHallListTypeMutableMember;
            @weakify(self);
            vc.tranfromHandler = ^(NSMutableArray<UserInfo *> * _Nonnull array) {
                @strongify(self);
                self.createModel.selectingUserArray = [array copy];
                [self reloadRowWithType:TTGuildGroupManageTypeMemberList];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark GuildCoreClient

/**
 创建群聊
 
 @param data 创建成功返回数据
 @param code 错误码
 @param msg 错误信息
 */
- (void)responseGuildGroupCreate:(GuildHallGroupCreateResponse *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    
    if (data) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TTGuildGroupManageDidCreateGroupNoti object:nil];
        
        [XCHUDTool showSuccessWithMessage:@"创建成功，开始聊天吧" inView:self.view];
        
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTGuildGroupSessionViewControllerWithSessionId:data.tid];
            [weakself.navigationController pushViewController:vc animated:YES];
        });
        return;
    }
    
    self.doneButton.userInteractionEnabled = YES;

    [XCHUDTool showErrorWithMessage:msg ?: @"请求出错了" inView:self.view];
}

- (void)responseGuildGroupInfoLimit:(GuildGroupInfoLimit *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    self.groupLimit = data;
    [self configDataSource];
}

#pragma mark FileCoreClient
- (void)didUploadGroupIconImageSuccessUseQiNiu:(NSString *)key {
    [XCHUDTool hideHUDInView:self.view];

    NSString *url = [NSString stringWithFormat:@"%@/%@?imageslim", keyWithType(KeyType_QiNiuBaseURL, NO), key];
    self.createModel.avatar = url;
    
    [self reloadRowWithType:TTGuildGroupManageTypeAvatar];
}

- (void)didUploadGroupIconImageFailUseQiNiu:(NSString *)message {
    message = message ?: @"上传图片出错";
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - event response
- (void)doneButtonDidTapped:(UIButton *)sender {
    if (self.createModel.name.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请填写群名称" inView:self.view];
        return;
    }
    
    NSString *noWhitespaceName = [self.createModel.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (noWhitespaceName.length == 0) {
        [XCHUDTool showErrorWithMessage:@"输入不能为空" inView:self.view];
        return;
    }

    if (self.createModel.avatar.length == 0) {
        [XCHUDTool showErrorWithMessage:@"请上传群头像" inView:self.view];
        return;
    }
    
    sender.userInteractionEnabled = NO;
    [XCHUDTool showGIFLoadingInView:self.view];
    
    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.longLongValue];

    NSMutableString *members = [NSMutableString stringWithString:@""];
    NSMutableArray *mArray = [NSMutableArray array];
    for (UserInfo *user in self.createModel.selectingUserArray) {
        if (members.length > 0) {
            [members appendString:@","];
        }
        
        [members appendString:@(user.uid).stringValue];
    }
    
    [GetCore(GuildCore) requestGuildGroupCreateWithHallId:@(info.hallId).stringValue type:self.createModel.type name:self.createModel.name icon:self.createModel.avatar notice:@"" members:members];
}

#pragma mark - private method
- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = self.tableView.backgroundColor;
    
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSeparateLineCellId];
    [self.tableView registerClass:TTGuildGroupContentCell.class forCellReuseIdentifier:kContentCellId];
    [self.tableView registerClass:TTGuildGroupMultiLineTextCell.class forCellReuseIdentifier:kMultiLineCellId];
    [self.tableView registerClass:TTGuildGroupCollectionCell.class forCellReuseIdentifier:kCollectionCellId];

    [self.view addSubview:self.doneButton];
    
    __weak typeof(self) weakself = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.left.right.mas_equalTo(weakself.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.left.right.mas_equalTo(weakself.view);
        }
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.tableView.mas_bottom);
        make.left.right.mas_equalTo(weakself.view).inset(15);
        make.height.mas_equalTo(40);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(weakself.view.mas_safeAreaLayoutGuide).offset(-22);
        } else {
            make.bottom.mas_equalTo(weakself.view).offset(-22);
        }
    }];
}

- (void)reloadRowWithType:(TTGuildGroupManageType)type {
    
    __block NSInteger row = -1;
    [self.dataSourceArray enumerateObjectsUsingBlock:^(TTGuildGroupManageConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.type == type) {
            row = idx;
            *stop = YES;
        }
    }];
    
    if (row != -1) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
}

- (void)configDataSource {
    
    TTGuildGroupManageConfig *avatar =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeAvatar
                                    name:@"上传群头像："
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:YES
                               showArrow:YES];
    TTGuildGroupManageConfig *name =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeName
                                    name:@"输入群名称："
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:NO
                               showArrow:YES];
    TTGuildGroupManageConfig *separateLine =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeSeparateLine
                                    name:@"分割线"
                               nameColor:UIColorFromRGB(0xf5f5f5)
                           showUnderLine:NO
                               showArrow:NO];
    TTGuildGroupManageConfig *memberTitle =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMemberTitle
                                    name:@"选择群成员"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:YES];
    TTGuildGroupManageConfig *memberList =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeMemberList
                                    name:@"群成员列表"
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:NO];
    TTGuildGroupManageConfig *classify =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeClassify
                                    name:@"选择群分类："
                               nameColor:[XCTheme getTTMainTextColor]
                           showUnderLine:NO
                               showArrow:NO];
    
    NSString *des = @"";
    if (self.groupLimit) {
        des = [NSString stringWithFormat:@"公开群全站用户可加入，只能创建%ld个;\n内部群仅厅成员可加入，最多创建%ld个。\n群聊成员最多不超过%ld人。", self.groupLimit.publicMax, self.groupLimit.privateMax, self.groupLimit.memberMax];
    }
    
    TTGuildGroupManageConfig *describe =
    [TTGuildGroupManageConfig configType:TTGuildGroupManageTypeCreateDescribe
                                    name:des
                               nameColor:[XCTheme getTTDeepGrayTextColor]
                           showUnderLine:NO
                               showArrow:NO];
    
//    NSValue *value = [NSValue valueWithNonretainedObject:avatar];
    
//    __weak TTGuildGroupManageConfig *weakAvatar = avatar;
//    self.dataSourceArray = @[avatar, name, separateLine, memberTitle, memberList, separateLine, classify];
    self.dataSourceArray = @[avatar, name, separateLine, memberTitle, memberList, separateLine, classify, describe];
    [self.tableView reloadData];
}

#pragma mark 选择图片
- (void)photoPicker {
    
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @KWeakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        @KStrongify(self);
        UIImage *selectedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
        if (selectedPhoto) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                UIImageWriteToSavedPhotosAlbum(selectedPhoto, nil, nil, nil);
            }
            
            selectedPhoto = [UIImage fixOrientation:selectedPhoto];
            [GetCore(FileCore) qiNiuUploadImage:selectedPhoto uploadType:UploadImageTypeGroupIcon];
            
            [XCHUDTool showGIFLoadingInView:self.view];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (NSArray<TTGuildGroupManageConfig *> *)dataSourceArray {
    if (_dataSourceArray == nil) {
        _dataSourceArray = @[];
    }
    return _dataSourceArray;
}

- (UIButton *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"确定创建" forState:UIControlStateNormal];
        [_doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _doneButton.backgroundColor = [XCTheme getTTMainColor];
        _doneButton.layer.cornerRadius = 20;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self action:@selector(doneButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

@end
