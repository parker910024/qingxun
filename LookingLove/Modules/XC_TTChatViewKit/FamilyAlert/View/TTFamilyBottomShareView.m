//
//  TTFamilyBottomShareView.m
//  TuTu
//
//  Created by gzlx on 2018/11/10.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyBottomShareView.h"
#import "XCShareView.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "ShareCore.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCAlertControllerCenter.h"
#import "AuthCore.h"
#import "XCHtmlUrl.h"
#import "HostUrlManager.h"
#import "ShareCore.h"
#import "ShareModelInfor.h"
#import "FamilyCore.h"
#import "XCKeyWordTool.h"

#import "XCMediator+TTDiscoverModuleBridge.h"


@interface TTFamilyShareCollectionViewCell : UICollectionViewCell
/** 头像*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation TTFamilyShareCollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self initContrations];
    }
    return self;
}

- (void)initContrations{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTMainTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end

@interface TTFamilyBottomShareView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * cancleButton;
@end

@implementation TTFamilyBottomShareView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - response
- (void)cancleButtonAction:(UIButton *)sender{
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
}

#pragma mark - private method
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.cancleButton];
}
- (void)initContrations{
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark- UICollectionViewDelegate and UICollectionViewDeleDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self getShareItems] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 24)/ 4, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(25, 12, 24, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyShareCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTFamilyShareCollectionViewCell" forIndexPath:indexPath];
    XCShareItem * item  = [[self getShareItems] objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.iconImageView.image =[UIImage imageNamed:item.imageName];
        cell.titleLabel.text = item.title;
    }else{
        if (item.disable) {
            cell.iconImageView.image = [UIImage imageNamed:item.disableImageName];
        }else{
            cell.iconImageView.image = [UIImage imageNamed:item.imageName];
        }
        cell.titleLabel.text = item.title;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XCShareItem * item = [[self getShareItems] objectAtIndex:indexPath.row];
    ShareModelInfor * model = [[ShareModelInfor alloc] init];
    if (self.familyModel) {
        model.familyInfor = self.familyModel;
        model.shareType = Custom_Noti_Sub_Share_Family;
    }else if(self.groupModel){
        model.grupInfor = self.groupModel;
        model.shareType = Custom_Noti_Sub_Share_Group;
    }
    model.currentVC = self.currentVC;
    model.Type = XCShare_Type_Share;
    [GetCore(ShareCore) reloadShareModel:model];
    if (indexPath.row == 0) {
        [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
        UIViewController * shareVC = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
//        shareVC.shareType = XCShare_Type_Share;
        [self.currentVC.navigationController pushViewController:shareVC animated:YES];
    }else{
        [self shareFamilyWith:item];
    }
}

- (void)shareFamilyWith:(XCShareItem *)item{
    if (item.disable) {
        return;
    }
    SharePlatFormType platform = 0;
    switch (item.itemTag) {
        case XCShareItemTagMoments:
            platform = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            platform = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            platform = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            platform = Share_Platform_Type_QQ;
            break;
        default:
            break;
    }
    
    NSString *title = nil;
    NSString *describe = nil;
    NSString *icon = nil;
    
    ShareModelInfor *shareModel = [GetCore(ShareCore) getShareModel];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", [HostUrlManager shareInstance].hostUrl,  HtmlUrlKey(kShareFamilyURL)];
    NSString *mark = @"";
    if (![url containsString:@"?"]) mark = @"?";
    url = [NSString stringWithFormat:@"%@%@uid=%@&familyId=%@", url, mark, [GetCore(AuthCore) getUid], shareModel.familyInfor.familyId];
    
    if (shareModel.shareType == Custom_Noti_Sub_Share_Family) {
        icon = shareModel.familyInfor.familyIcon;
        title = [NSString stringWithFormat:@"hi,我想邀请您加入我的%@家族:%@~",[XCKeyWordTool sharedInstance].myAppName, shareModel.familyInfor.familyName];
        describe = @"加入家族,和你兴趣相投的小伙伴一起玩耍吧~";
    }
    
    if (shareModel.shareType == Custom_Noti_Sub_Share_Group) {
        icon = shareModel.grupInfor.icon;
        title = [NSString stringWithFormat:@"hi,我想邀请您加入我的%@群聊:%@~", [XCKeyWordTool sharedInstance].myAppName,shareModel.grupInfor.name];
        describe = @"加入家族,和你兴趣相投的小伙伴一起玩耍吧~";
    }
    
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:YES];
    [GetCore(ShareCore) shareH5WithTitle:title url:url imgUrl:icon desc:describe platform:platform];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 158) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TTFamilyShareCollectionViewCell class] forCellWithReuseIdentifier:@"TTFamilyShareCollectionViewCell"];
    }
    return _collectionView;
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitle:@"取消" forState:UIControlStateSelected];
        [_cancleButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateSelected];
        [_cancleButton setBackgroundColor:[XCTheme getTTSimpleGrayColor]];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (NSArray<XCShareItem *>*)getShareItems{
    
    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];
     XCShareItem *friendItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:!installWeChat];
    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];
    return @[friendItem,momentItem,weChatItem,qqZoneItem,qqItem];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
