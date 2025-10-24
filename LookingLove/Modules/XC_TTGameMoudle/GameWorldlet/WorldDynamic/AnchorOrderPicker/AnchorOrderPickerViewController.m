//
//  AnchorOrderPickerViewController.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/4/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "AnchorOrderPickerViewController.h"

#import "AnchorOrderPickerCell.h"
#import "AnchorOrderPickerFooterView.h"
#import "AnchorOrderDataPickerView.h"

#import "AnchorOrderStatus.h"
#import "LittleWorldCore.h"

#import "XCMacros.h"
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellId";

@interface AnchorOrderPickerViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) AnchorOrderPickerFooterView *footerView;

/// 样式列表
@property (nonatomic, strong) NSArray *styleArray;

/// 当前订单数据
@property (nonatomic, strong) AnchorOrderInfo *orderInfo;

/// 订单系统配置
@property (nonatomic, strong) AnchorOrderConfig *config;

@end

@implementation AnchorOrderPickerViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接单信息";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [self setupUI];
    
    //预加载配置文件
    [self requestConfigWithCompletion:nil];
}

#pragma mark - Private
- (void)setupUI {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:AnchorOrderPickerCell.class forCellReuseIdentifier:kCellID];
    
    self.footerView = [[AnchorOrderPickerFooterView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
    self.tableView.tableFooterView = self.footerView;
    
    @weakify(self)
    self.footerView.doneHandler = ^{
        @strongify(self)
        [self doneAction];
    };
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
    }];
}

- (void)doneAction {
    
    [TTStatisticsService trackEvent:@"world_save_order" eventDescribe:@"填写接单_保存"];

    [self.view endEditing:YES];
    
    if (self.orderInfo.orderPrice.length == 0) {
        self.orderInfo.orderPrice = @"0";
    }
    
    if (self.orderInfo.orderPrice.integerValue < self.config.price.min ||
        self.orderInfo.orderPrice.integerValue > self.config.price.max) {
        
        NSString *msg = [NSString stringWithFormat:@"金币范围：%ld~%ld", self.config.price.min, self.config.price.max];
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    if (self.orderInfo.orderDuration < self.config.duration.min ||
        self.orderInfo.orderDuration > self.config.duration.max) {
        
        NSString *msg = [NSString stringWithFormat:@"时长范围：%ld~%ld", self.config.duration.min, self.config.duration.max];
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    !self.orderHandler ?: self.orderHandler(self.orderInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
//        如果是返回手势。进行判断是否有草稿数据
        if (self.navigationItem.rightBarButtonItem.enabled &&
            [self.navigationController.topViewController isKindOfClass:[self class]]) {
            [self showCancelAlert];
            return NO;
        }
    }
    return YES;
}

- (void)showCancelAlert {
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.message = @"还没保存哦，确定返回吗";
    config.confirmButtonConfig.title = @"去意已决";
    config.cancelButtonConfig.title = @"继续填写";

    @weakify(self);
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
        [TTStatisticsService trackEvent:@"world_order_leave" eventDescribe:@"去意已决"];
    } cancelHandler:^{
        [TTStatisticsService trackEvent:@"world_order_leave" eventDescribe:@"继续填写"];
    }];
}

// 点击返回按钮
- (void)goBack {
    // 有填写内容
    BOOL valid = self.orderInfo.orderPrice.length
    || self.orderInfo.orderDuration > 0
    || self.orderInfo.orderType.length
    || self.orderInfo.orderValidTime.length;
    
    if (valid) {
        [self showCancelAlert];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/// 请求配置文件
/// @param completion 完成回调
- (void)requestConfigWithCompletion:(void(^ _Nullable)(void))completion {
    
    if (self.config) {
        !completion ?: completion();
        return;
    }
    
    [GetCore(LittleWorldCore) requestAnchorOrderConfigWithCompletion:^(AnchorOrderConfig * _Nonnull data, NSNumber * _Nonnull errorCode, NSString * _Nonnull msg) {
        
        self.config = data;
        
        if (completion) {
            completion();
            
            if (errorCode) {
                dispatch_main_sync_safe(^{
                    [XCHUDTool showErrorWithMessage:msg ?: @"数据请求出错了"];
                });
            }
        }
    }];
}

- (void)selectDataWithStyle:(AnchorOrderPickerStyle)style {
    [self.view endEditing:YES];
    
    AnchorOrderDataPickerView *picker = [[AnchorOrderDataPickerView alloc] init];

    @weakify(self)
    picker.selectHandler = ^(NSString * _Nonnull content) {
        @strongify(self)
        if (style == AnchorOrderPickerStyleType) {
            self.orderInfo.orderType = content;
        } else if (style == AnchorOrderPickerStyleEffectTime) {
            self.orderInfo.orderValidTime = content;
        }
        
        [self.footerView updateButtonStatusWithOrder:self.orderInfo];
        
        NSInteger row = style == AnchorOrderPickerStyleType ? 2 : 3;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    picker.dataList = style == AnchorOrderPickerStyleType ? self.config.typeList : self.config.validTimeList;
    picker.selectData = style == AnchorOrderPickerStyleType ? self.orderInfo.orderType : self.orderInfo.orderValidTime;
    
    [picker showAlert];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.styleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnchorOrderPickerStyle style = [self.styleArray[indexPath.row] integerValue];
    
    AnchorOrderPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.style = style;
    cell.orderInfo = self.orderInfo;
    
    @weakify(self)
    cell.completeInputHandler = ^(NSString * _Nonnull input) {
        @strongify(self)
        if (style == AnchorOrderPickerStylePrice) {
            self.orderInfo.orderPrice = input;
        } else if (style == AnchorOrderPickerStylePlayTime) {
            self.orderInfo.orderDuration = input.integerValue;
        }
        
        [self.footerView updateButtonStatusWithOrder:self.orderInfo];
    };
    cell.buttonActionHandler = ^{
        @strongify(self)
        [self requestConfigWithCompletion:^{
            if (!self.config) {
                return;
            }
            [self selectDataWithStyle:style];
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

#pragma mark - Lazy Load
- (NSArray *)styleArray {
    if (_styleArray == nil) {
        _styleArray = @[@(AnchorOrderPickerStylePrice),
                        @(AnchorOrderPickerStylePlayTime),
                        @(AnchorOrderPickerStyleType),
                        @(AnchorOrderPickerStyleEffectTime)];
    }
    return _styleArray;
}

- (AnchorOrderInfo *)orderInfo {
    if (_orderInfo == nil) {
        _orderInfo = [[AnchorOrderInfo alloc] init];
    }
    return _orderInfo;
}

@end
