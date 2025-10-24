//
//  TTWorldletMainViewController.m
//  AFNetworking
//
//  Created by apple on 2019/7/1.
//

#import "TTWorldletMainViewController.h"

#import "TTWorldletMainTableViewCell.h"
#import "TTNewbieGuideView.h"

#import "TTWorldletJoinSuccessAlertView.h"
#import "TTWorldletNoChatGroupAlertView.h"
#import "TTWorldletGroupFullAlertView.h"
#import "TTWorldletJoinGroupConfirmAlertView.h"

/** module 内 view(cell)（业务组件自定义view） */
#import "LittleWorldCoreClient.h"

/** module 内 工具类（业务组件的工具类）*/
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSString+Utils.h"
#import "TTPopup.h"
#import "XCHUDTool.h"
#import "AuthCore.h"
#import "UIViewController+EmptyDataView.h"
#import "UIView+NTES.h"
#import "TTStatisticsService.h"
/** bridge */
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
/** xc_tt（兔兔私有组件） */
/** xc类 （平台公共组件） */
#import "AuthCore.h"
#import "LittleWorldCore.h"

/** 第三方工具（第三方pod） */
#import <Masonry/Masonry.h> // 约束

@interface TTWorldletMainViewController ()
@end

@implementation TTWorldletMainViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    
    self.hiddenNavBar = YES;
    [self initView];
    [self initConstraint];
}

- (void)initView {
    [self.view addSubview:self.tableView];
}

- (void)initConstraint {
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    self.tableView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTWorldletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"worldletCell"];
    
    if (!cell) {
        cell = [[TTWorldletMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"worldletCell"];
        
        cell.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.model) {
        cell.model = self.model;
    }
    
    @KWeakify(self);
    cell.avatorClick = ^{
        @KStrongify(self);
        UIViewController *VC = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:self.model.ownerUid.userIDValue];
        [self.navigationController pushViewController:VC animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str;
    
    if (self.model) {
        str = [NSString stringWithFormat:@"  %@",self.model.notice];
    }
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    paragraphStyle1.firstLineHeadIndent = 35;
    
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 30 - 24 - 19 , MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle1} context:nil].size.height;
    CGFloat heightToll = (81 + height + 22) + 26 + (32 + 55 + kSafeAreaBottomHeight);
    
    return heightToll;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - Setter Getter
- (void)setModel:(LittleWorldListItem *)model {
    _model = model;

    if (model.notice.length > 0) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self removeEmptyDataView];
    } else {
        self.tableView.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"common_noDataWorldlet_empty"];
        [self showEmptyDataViewWithTitle:@"暂无任何内容" color:UIColorRGBAlpha(0xffffff, 0.5) image:image offsetY:-114 view:self.view complete:^{
        }];
    }
    
    NSString *uidStr = [GetCore(LittleWorldCore) receiveDictWithKey:self.model.worldId];
    
    if (uidStr.length > 0 && model.inWorld) {
        if (uidStr.userIDValue == GetCore(AuthCore).getUid.userIDValue) {
            [GetCore(LittleWorldCore) removeDictWithKey:self.model.worldId];
        }
    }
}

@end
