//
//  LLPostDynamicViewController.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLPostDynamicViewController.h"

#import "LLPostDynamicAlbumView.h"
#import "LLPostDynamicSucceccAlert.h"
#import "LLPostDynamicSelectLittleWorldView.h"
#import "LLPostDynamicLittleWorldTagView.h"
#import "LLPostDynamicAnchorOrderPickerView.h"

#import "AnchorOrderPickerViewController.h"

#import "XCMediator+TTPersonalMoudleBridge.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCAlertControllerCenter.h"
#import "TTStatisticsService.h"

#import "AuthCore.h"
#import "UserCore.h"
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "FileCore.h"

#import <SZTextView/SZTextView.h>
#import <Masonry/Masonry.h>
#import <YYImage/YYImage.h>

static NSInteger const kTextMaxCount = 500; // 文本输入最大字符数
static CGFloat const kMargin = 20.f; // 间距

@interface LLPostDynamicViewController ()
<
UITextViewDelegate,
UIGestureRecognizerDelegate,
LittleWorldCoreClient,
LLPostDynamicAlbumViewDelegate
>

@property (nonatomic, copy) NSString *worldID; //所在的小世界ID，为空值表示不指定小世界
@property (nonatomic, copy) NSString *worldName; //小世界名称

@property (nonatomic, strong) UIScrollView *scrollView;//滚动视图容器，存放中间内容

@property (nonatomic, strong) UIButton *postBtn; //发布按钮
@property (nonatomic, strong) UILabel *tipsLabel; //提示语
@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) UILabel *limitLabel; //字数最大限制
@property (nonatomic, strong) LLPostDynamicLittleWorldTagView *worldTagView; //小世界标签，小世界内部发布时才显示，动态广场发布时隐藏

@property (nonatomic, strong) LLPostDynamicAlbumView *albumView; //图片相册
@property (nonatomic, strong) LLPostDynamicAnchorOrderPickerView *anchorOrderView;//选择主播订单
@property (nonatomic, strong) LLPostDynamicSelectLittleWorldView *selectTagView;//选择小世界标签
@end

@implementation LLPostDynamicViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

/// 初始化指定小世界里面的发布动态
/// @discussion 如果不指定小世界，直接调用【init】方法
/// @param worldId 小世界Id
/// @param worldName 小世界名称
- (instancetype)initWithWorldId:(NSString *)worldId worldName:(NSString *)worldName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _worldID = worldId;
        _worldName = worldName;
    }
    return self;
}

/// 动态分享图片
- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.albumView.dataArray = images.mutableCopy;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self defaultConfig];
    [self initViews];
    [self initConstraints];
    
    AddCoreClient(LittleWorldCoreClient, self);
    
    //为空值表示不指定小世界
    if (_worldID == nil) {
        [GetCore(LittleWorldCore) requestWorldDynamicPostWorldListWithType:DynamicPostWorldRequestTypeRecommend page:1];
    }
    
    if (self.albumView.dataArray.count > 0) {
        [self changePostBtnStatus];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setupScrollViewContentSize];
}

#pragma mark - lifeCyle
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
//        如果是返回手势。进行判断是否有动态草稿数据
        if (self.navigationItem.rightBarButtonItem.enabled &&
            [self.navigationController.topViewController isKindOfClass:[LLPostDynamicViewController class]]) {
            [self showCancelAlert];
            return NO;
        }
    }
    return YES;
}

- (void)showCancelAlert {
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"还没发布诶~\n确定返回吗";
    config.confirmButtonConfig.title = @"手滑了";
    config.cancelButtonConfig.title = @"忍痛取消";

    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        [TTStatisticsService trackEvent:@"word_return_cancel" eventDescribe:@"未发布弹窗选择-取消"];
        [TTStatisticsService trackEvent:@"world_give_up" eventDescribe:@"已编辑内容中途返回:手滑了"];
    } cancelHandler:^{
        @strongify(self);
        [TTStatisticsService trackEvent:@"word_return_cancel" eventDescribe:@"未发布弹窗选择-返回"];
        [TTStatisticsService trackEvent:@"world_give_up" eventDescribe:@"已编辑内容中途返回:忍痛取消"];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)defaultConfig {
    self.title = @"图文发布";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.postBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 进入后默认为不可操作状态
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

// 点击返回按钮
- (void)goBack {
    // 如果是可以发布状态，说明是有填写内容
    if (self.navigationItem.rightBarButtonItem.enabled) {
        [self showCancelAlert];
        return;
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initViews {
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.limitLabel];
    [self.view addSubview:self.worldTagView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.albumView];
    [self.scrollView addSubview:self.anchorOrderView];
    [self.scrollView addSubview:self.selectTagView];
    
    @weakify(self)
    self.anchorOrderView.selectOrderHandler = ^{
        @strongify(self)
        NSString *des = self.worldID ? @"小世界" : @"动态广场";
        [TTStatisticsService trackEvent:@"world_fill_in_order" eventDescribe:des];
        
        //进入订单设置
        AnchorOrderPickerViewController *vc = [[AnchorOrderPickerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.orderHandler = ^(AnchorOrderInfo * _Nonnull order) {
            self.anchorOrderView.selectOrder = order;
        };
    };
    
    self.selectTagView.selectWorldHandler = ^{
        @strongify(self)
        [self.textView resignFirstResponder];
    };
}

- (void)initConstraints {
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(20);
        make.bottom.mas_equalTo(self.view).inset(kSafeAreaBottomHeight + 30);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).inset(20);
        make.height.mas_equalTo(150);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.mas_equalTo(kNavigationHeight);
        }
    }];
    
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.textView);
    }];
    
    [self.worldTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(0);
        make.height.mas_equalTo(26);
        make.left.mas_equalTo(20);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.limitLabel.mas_bottom).offset(24);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.tipsLabel.mas_top).offset(-10);
    }];

    [self.albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view).inset(kMargin);
        make.height.mas_equalTo([self.albumView height]);
    }];
    
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
    BOOL showOrderView = userInfo.attestationBackPic != nil;//主播身份
    self.anchorOrderView.hidden = !showOrderView;
    
    [self.anchorOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.albumView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(showOrderView ? 52 : 0);
    }];
    
    [self.selectTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.anchorOrderView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(280);
    }];
}

#pragma mark - private Method
/// 根据是否填写了发布资料，改变发布按钮的状态
- (void)changePostBtnStatus {
    // 当有添加图片 or 输入不是纯空格的文案的时候可以进行发布
    if (self.albumView.dataArray.count > 0 ||
        (self.textView.text.length > 0 && ![self isEmpty:self.textView.text])) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

// 判断文本内容是否全是空格组成
- (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        return YES;
    }  else {
        return NO;
    }
}

/// 重新布局相册高度
- (void)relayoutAlbumView {
    [self.albumView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self.albumView height]);
    }];
    [self.view layoutIfNeeded];
    [self setupScrollViewContentSize];
}

/// 设置滚动容器大小
- (void)setupScrollViewContentSize {
    if (self.worldID == nil) {
        self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(self.selectTagView.frame));
    } else {
        self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(self.albumView.frame));
    }
}

#pragma mark - button Events
- (void)onClickPostBtnAction:(UIButton *)postBtn {
    
    [self.textView resignFirstResponder];
    [XCHUDTool showGIFLoading];
   
    [TTStatisticsService trackEvent:@"world_publish_moments" eventDescribe:self.worldName];
        
    //动态类型，0-纯文本，1-声音，2-图文，3-视频
    if (self.textView.text.length >= 0 &&
        self.albumView.dataArray.count > 0) {
        
        @weakify(self);
        [GetCore(FileCore) uploadImages:self.albumView.dataArray bizType:HttpRequestHelperUploadBizTypeDynamic success:^(NSArray<UploadImage *> *data) {
            
            @strongify(self);
            if (data.count != self.albumView.dataArray.count) {
                [XCHUDTool hideHUD];
                [XCHUDTool showErrorWithMessage:@"选择的图片和上传成功图片数量不一致（开发测试使用）"];
                return;
            }

            NSMutableArray *imageDictArray = [NSMutableArray array];
            for (UploadImage *model in data) {
                NSDictionary *dict = @{@"resUrl" : model.url ?: @"",
                                       @"format" : model.format ?: @"",
                                       @"width" : @(model.width),
                                       @"height" : @(model.height)};
                [imageDictArray addObject:dict];
            }
            
            [self post:self.textView.text images:imageDictArray];

        } failure:^(NSNumber *resCode, NSString *message) {
            
        }];
        
    } else if (self.textView.text.length > 0) {
        [self post:self.textView.text images:nil];
    }
}

#pragma mark - Request Post
- (void)post:(NSString *)content images:(NSArray *)images {
    
    //动态类型，0-纯文本，1-声音，2-图文，3-视频
    int type = images.count > 0 ? 2 : 0;

    if (self.worldID != nil) {
        ///小世界内发布动态
        [GetCore(LittleWorldCore) requestWorldPostSquareDynamicWithWorldID:self.worldID type:type content:content resList:images workOrder:self.anchorOrderView.selectOrder];
        return;
    }
    
    ///广场发布动态
    
    LittleWorldDynamicPostWorld *world = self.selectTagView.selectWorld;
    if (world && !world.inWorld) {
        //选择了未加入的小世界，弹窗提醒
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = @"加入小世界就可发布内容啦~";
        config.confirmButtonConfig.title = @"加入并发布";
        config.cancelButtonConfig.title = @"我再想想";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            [GetCore(LittleWorldCore) requestWorldPostSquareDynamicWithWorldID:world.worldId type:type content:content resList:images workOrder:self.anchorOrderView.selectOrder];
            
            [TTStatisticsService trackEvent:@"square_join_world" eventDescribe:@"加入并发布"];

        } cancelHandler:^{
            [XCHUDTool hideHUD];
            
            [TTStatisticsService trackEvent:@"square_join_world" eventDescribe:@"我再想想"];
        }];
        return;
    }
    
    [GetCore(LittleWorldCore) requestWorldPostSquareDynamicWithWorldID:world.worldId type:type content:content resList:images workOrder:self.anchorOrderView.selectOrder];
}

#pragma mark - LLPostDynamicAlbumViewDelegate
/// 将要新增照片
- (void)albumViewWillAppendPhoto:(LLPostDynamicAlbumView *)view {
    [self.textView resignFirstResponder];
}

/// 将要浏览照片
- (void)albumViewWillBrowserPhoto:(LLPostDynamicAlbumView *)view {
    [self.textView resignFirstResponder];
}

/// 已经新增照片
- (void)albumViewHadAppendPhoto:(LLPostDynamicAlbumView *)view {
    [self changePostBtnStatus];
    [self relayoutAlbumView];
}

/// 已经删除照片
- (void)albumViewHadDeletePhoto:(LLPostDynamicAlbumView *)view {
    [self changePostBtnStatus];
    [self relayoutAlbumView];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > kTextMaxCount) {
        [XCHUDTool showErrorWithMessage:@"最多只能输入 500 个字符哦" inView:self.view];
        textView.text = [textView.text substringToIndex:kTextMaxCount];
    } else {
        [self changePostBtnStatus];
    }
    
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/%ld",((unsigned long)textView.text.length), (long)kTextMaxCount];
}

#pragma mark - LittleWorldCoreClient
- (void)responseWorldPostDynamicSuccess:(BOOL)success code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    [self.textView resignFirstResponder];
    [XCHUDTool hideHUD];

    if (success) {
                
        LittleWorldDynamicPostWorld *world = self.selectTagView.selectWorld;
        if (world) {
            [TTStatisticsService trackEvent:@"square_choose_world" eventDescribe:world.worldName];
            [TTStatisticsService trackEvent:@"world_publish_succeed" eventDescribe:world.worldName];

            for (LittleWorldDynamicPostWorld *model in self.selectTagView.worldArray) {
                if ([model.worldId isEqualToString:world.worldId]) {
                    [TTStatisticsService trackEvent:@"square_recommend_world" eventDescribe:world.worldName];
                    break;
                }
            }
        } else {
            [TTStatisticsService trackEvent:@"world_publish_succeed" eventDescribe:@"无小世界"];
        }
        
        if (self.anchorOrderView.selectOrder) {
            NSString *worldName = world ? world.worldName : @"无小世界";
            [TTStatisticsService trackEvent:@"world_publish_order_success" eventDescribe:worldName];
        }
        
        @weakify(self);
        
        LLPostDynamicSucceccAlert *successAlert = [[LLPostDynamicSucceccAlert alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        
        TTPopupService *service = [[TTPopupService alloc] init];
        service.contentView = successAlert;
        service.filterIdentifier = NSStringFromClass([LLPostDynamicSucceccAlert class]);
        service.shouldFilterPopup = YES;
        service.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
            @strongify(self);
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        
        [TTPopup popupWithConfig:service];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TTPopup dismiss];
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });

        !self.refreshDynamicBlock ? : self.refreshDynamicBlock(); // 刷新回调
    } else {
        [XCHUDTool showSuccessWithMessage:msg];
    }
}

/// 动态发布里的世界列表
- (void)responseWorldDynamicPostWorldList:(NSArray<LittleWorldDynamicPostWorld *> *)data type:(DynamicPostWorldRequestType)type code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    if (type == DynamicPostWorldRequestTypeRecommend) {
        self.selectTagView.worldArray = data;
    }
}

#pragma mark - setter && getter
- (UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setFrame:CGRectMake(0, 0, 55, 27)];
        [_postBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_postBtn setBackgroundImage:[UIImage imageNamed:@"littleWorld_dynamic_postBnt_enabled"] forState:UIControlStateNormal];
        [_postBtn setBackgroundImage:[UIImage imageNamed:@"littleWorld_dynamic_postBnt_normal"] forState:UIControlStateDisabled];
        [_postBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_postBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _postBtn.layer.cornerRadius = 13.5;
        _postBtn.layer.masksToBounds = YES;
        _postBtn.enabled = NO;
        [_postBtn addTarget:self action:@selector(onClickPostBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"禁止出现商业广告、微信号码、QQ号码、电话号码,  以及低俗、色情、恐怖、暴力和具有侮辱性语言等内容，违规者封号处理 ！";
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = UIColorFromRGB(0xBDBDBF);
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] init];
        _textView.textColor = XCThemeMainTextColor;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.placeholder = @"说点什么吧...";
        _textView.placeholderTextColor = UIColorFromRGB(0xBDBDBF);
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.text = @"0/500";
        _limitLabel.textColor = UIColorFromRGB(0xB3B3B3);
        _limitLabel.font = [UIFont systemFontOfSize:12];
        _limitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _limitLabel;
}

- (LLPostDynamicLittleWorldTagView *)worldTagView {
    if (!_worldTagView) {
        
        LittleWorldDynamicPostWorld *world = [[LittleWorldDynamicPostWorld alloc] init];
        world.worldName = _worldName;
        world.worldId = _worldID;
        
        _worldTagView = [[LLPostDynamicLittleWorldTagView alloc] init];
        _worldTagView.userInteractionEnabled = NO;
        _worldTagView.model = world;
        
        _worldTagView.hidden = _worldID==nil;

    }
    return _worldTagView;
}

- (LLPostDynamicAlbumView *)albumView {
    if (!_albumView) {
        _albumView = [[LLPostDynamicAlbumView alloc] init];
        _albumView.delegate = self;
    }
    return _albumView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (LLPostDynamicSelectLittleWorldView *)selectTagView {
    if (_selectTagView == nil) {
        _selectTagView = [[LLPostDynamicSelectLittleWorldView alloc] init];
        
        _selectTagView.hidden = _worldID!=nil;
    }
    return _selectTagView;
}

- (LLPostDynamicAnchorOrderPickerView *)anchorOrderView {
    if (_anchorOrderView == nil) {
        _anchorOrderView = [[LLPostDynamicAnchorOrderPickerView alloc] init];
        _anchorOrderView.hidden = YES;//默认隐藏
    }
    return _anchorOrderView;
}

@end
