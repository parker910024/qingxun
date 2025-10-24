//
//  XCBoxTrophyHistoryViewController.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxTrophyHistoryViewController.h"
#import "XCBoxTableViewCell.h"

//model
#import "BoxPrizeModel.h"

//core
#import "BoxCore.h"
#import "BoxCoreClient.h"
//t
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import <Masonry.h>
#import "UIViewController+EmptyDataView.h"
//#import "UIView+XCToast.h"
#import "XCEmptyDataView.h"

@interface XCBoxTrophyHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *closeBtn;//关闭按钮
@property (nonatomic, strong) UILabel *titleLable;//标题
@property (nonatomic, strong) UIView *segmentContentView;//选项卡
@property (nonatomic, strong) UIButton *timeBtn;//时间不btn
@property (nonatomic, strong) UIButton *vlaueBtn;//奖品价值Btn
@property (nonatomic, strong) NSMutableArray<BoxPrizeModel *> *dataMArray;//数据源
@property (nonatomic, assign) int currentPage;//当前页数
@property (nonatomic, assign) BoxDrawRecordSortType sortType;//
@property (nonatomic, strong) UIImageView *imageEmpty;//
@property (nonatomic, strong) UILabel *labelEmpty;//

@property (nonatomic, strong) UIImageView *goldEggIcon; // 中奖记录icon
@property (nonatomic, strong) UIImageView *goldTextIcon; // 中奖记录文案

@end

@implementation XCBoxTrophyHistoryViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    self.currentPage = 1;
    
    AddCoreClient(BoxCoreClient, self);
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - puble method
- (void)setIsJackpot:(BOOL)isJackpot{
    _isJackpot = isJackpot;
    if (self.isJackpot) {
        if (self.isDiamondJackpot == NO) {
            [GetCore(BoxCore) getBoxPrizesV2Probability];//
        }
    }else {
        [self timeBtnAction:self.timeBtn];
    }
}

- (void)setIsDiamondJackpot:(BOOL)isDiamondJackpot {
    _isDiamondJackpot = isDiamondJackpot;
    if (self.isDiamondJackpot == NO) {
        [GetCore(BoxCore) getBoxPrizesV2Probability];
    } else {
        [GetCore(BoxCore) getDiamondBoxPrizes];
    }
}

- (void)setIsDiamondBox:(BOOL)isDiamondBox {
    _isDiamondBox = isDiamondBox;
    if (self.isDiamondBox) {
        self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"goldEgg_glod_list_bg"].CGImage);
        
        self.segmentContentView.backgroundColor = UIColorRGBAlpha(0x7247ED, 0.32);
        self.timeBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
        self.vlaueBtn.backgroundColor = UIColorRGBAlpha(0x8820E0, 0.32);
        
    } else {
        self.view.backgroundColor = UIColorFromRGB(0x4C076C);
        self.segmentContentView.backgroundColor = UIColorRGBAlpha(0x8820E0, 0.32);
        self.timeBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
        self.vlaueBtn.backgroundColor = UIColorRGBAlpha(0x8820E0, 0.32);
    }
}
#pragma mark - System Delegate

#pragma makr -TableViewDelegate && Datasoruce

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XCBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XCBoxTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[XCBoxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XCBoxTableViewCell"];
    }
    BoxPrizeModel *prizeModel = [self.dataMArray safeObjectAtIndex:indexPath.row];
    prizeModel.isJackpot = self.isJackpot;
    cell.isTimeList = self.sortType == BoxDrawRecordSortTypeTime;
    cell.model = prizeModel;
    
    return cell;
}

#pragma mark - Core Client

#pragma mark - DiamondBoxCoreClient
- (void)onGetDiamondBoxPrizesSuccess:(NSArray *)boxPrizes {
    [self updateBoxPrizes:boxPrizes];
}

#pragma mark - BoxCoreClient

//奖池
- (void)onGetBoxPrizeProbabilitySuccess:(NSArray *)boxPrizes {
    
    [self updateBoxPrizes:boxPrizes];
}
- (void)onGetBoxPrizesFailth:(NSString *)message {
    
}

//中奖纪录
- (void)onGetBoxDrawRecordByState:(int)state success:(NSArray *)boxDrawRecord {
    if (self.currentPage == 1) {
        [self.dataMArray removeAllObjects];
    }
    if(boxDrawRecord.count) {
        [self.dataMArray addObjectsFromArray:boxDrawRecord];
    }

    if (boxDrawRecord.count>0) {
        [self successEndRefreshStatus:state hasMoreData:YES];
    }else{
        [self successEndRefreshStatus:state hasMoreData:NO];
    }
    
    self.imageEmpty.hidden = self.dataMArray.count>0;
    self.labelEmpty.hidden = self.dataMArray.count>0;
    [self.tableView reloadData];
}
- (void)onGetBoxDrawRecordByState:(int)state failth:(NSString *)message {
    [self failEndRefreshStatus:state];
}


#pragma mark - Event

- (void)closeBtnAction:(UIButton *)btn {
    [self.view removeFromSuperview];
}

- (void)timeBtnAction:(UIButton *)btn {
    self.timeBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
    self.vlaueBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0);
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.vlaueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sortType = BoxDrawRecordSortTypeTime;
    [self pullDownRefresh:1];
}

- (void)vlaueBtnAction:(UIButton *)btn {
    self.timeBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0);
    self.vlaueBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
    [self.vlaueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sortType = BoxDrawRecordSortTypeWorth;
    [self pullDownRefresh:1];
}


#pragma mark - Public Method

#pragma mark - Priavte Method
- (void)updateBoxPrizes:(NSArray *)boxPrizes {
    [self.dataMArray removeAllObjects];
    [self.dataMArray addObjectsFromArray:boxPrizes];
    self.imageEmpty.hidden = self.dataMArray.count>0;
    self.labelEmpty.hidden = self.dataMArray.count>0;
    [self.tableView reloadData];
}
//下拉刷新
- (void)pullDownRefresh:(int)page{
    NSLog(@"pullDownRefresh");
    
    self.currentPage = 1;
    [GetCore(BoxCore) getBoxDrawRecordByState:0 page:self.currentPage sortType:self.sortType];
}


//上拉刷新
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    NSLog(@"pullUpRefresh");
    self.currentPage = page;
    if (isLastPage) {
        NSLog(@"已经最后一页了");
        return;
    }
    [GetCore(BoxCore) getBoxDrawRecordByState:1 page:self.currentPage sortType:self.sortType];
    
}

- (void)initSubViews {
    self.view.backgroundColor = UIColorFromRGB(0x4C076C);
    self.view.layer.cornerRadius = 20;
    self.view.layer.masksToBounds = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableViewHeightOnScreen = 1;
    if (!self.isJackpot) {
        [self setupRefreshTarget:self.tableView];
    }
    
    [self.tableView registerClass:[XCBoxTableViewCell class] forCellReuseIdentifier:@"XCBoxTableViewCell"];
    self.tableView.rowHeight = 75;
    
    [self.view addSubview:self.goldEggIcon];
    [self.view addSubview:self.goldTextIcon];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.segmentContentView];
    [self.segmentContentView addSubview:self.timeBtn];
    [self.segmentContentView addSubview:self.vlaueBtn];
    [self.view addSubview:self.imageEmpty];
    [self.view addSubview:self.labelEmpty];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view).inset(12);
    }];
    
    [self.goldEggIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(22);
    }];
    
    [self.goldTextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goldEggIcon.mas_right).offset(6);
        make.centerY.mas_equalTo(self.goldEggIcon);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goldTextIcon.mas_right).offset(6);
        make.centerY.equalTo(self.goldEggIcon);
        make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-6);
    }];
    
    if (self.isJackpot) {
        self.segmentContentView.hidden = YES;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            make.bottom.equalTo(self.view).inset(10);
            make.leading.trailing.equalTo(self.view);
        }];
        self.titleLable.text = @"选择连砸，中奖几率更大哦~";
        self.goldTextIcon.image = [UIImage imageNamed:@"goldEgg_Pool_icon"];
    } else {
        
        [self.segmentContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.titleLable.mas_bottom).offset(13);
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(172);
        }];
        [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self.segmentContentView).inset(3);
            make.width.mas_equalTo(self.vlaueBtn);
        }];
        [self.vlaueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(self.segmentContentView).inset(3);
            make.left.mas_equalTo(self.timeBtn.mas_right);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.segmentContentView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.view).inset(10);
            make.leading.trailing.mas_equalTo(self.view);
        }];
        
        [self.imageEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(95);
            make.top.mas_equalTo(self.segmentContentView.mas_bottom).offset(60);
            make.centerX.mas_equalTo(self.view);
        }];
        
        [self.labelEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageEmpty.mas_bottom).mas_offset(30);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
    }
   
}

#pragma makr - Getters and Setters

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"room_box_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.text = @"展示最近300条中奖纪录";
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont boldSystemFontOfSize:12];
        _titleLable.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLable;
}

- (UIView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [[UIView alloc] init];
        _segmentContentView.layer.cornerRadius = 18;
        _segmentContentView.layer.masksToBounds = YES;
        _segmentContentView.backgroundColor = UIColorFromRGB(0x8820E0);
    }
    return _segmentContentView;
}

- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0.1);
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timeBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _timeBtn.layer.masksToBounds = YES;
        _timeBtn.layer.cornerRadius = 15;
    }
    return _timeBtn;
}
- (UIButton *)vlaueBtn {
    if (!_vlaueBtn) {
        _vlaueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _vlaueBtn.backgroundColor = UIColorRGBAlpha(0xFFFFFF, 0);
        _vlaueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_vlaueBtn setTitle:@"奖品价值" forState:UIControlStateNormal];
        [_vlaueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_vlaueBtn addTarget:self action:@selector(vlaueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _vlaueBtn.layer.masksToBounds = YES;
        _vlaueBtn.layer.cornerRadius = 15;
    }
    return _vlaueBtn;
}

- (NSMutableArray<BoxPrizeModel *> *)dataMArray{
    if (!_dataMArray) {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
}

- (UIImageView *)imageEmpty{
    if (!_imageEmpty) {
        _imageEmpty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_empty"]];
        _imageEmpty.hidden = YES;
    }
    return _imageEmpty;
}
- (UILabel *)labelEmpty{
    if (!_labelEmpty) {
        _labelEmpty = [[UILabel alloc] init];
        _labelEmpty.font = [UIFont systemFontOfSize:13];
        _labelEmpty.textColor = UIColorFromRGB(0x999999);
        _labelEmpty.textAlignment = NSTextAlignmentCenter;
        _labelEmpty.text = @"暂无中奖纪录";
        _labelEmpty.hidden = YES;
    }
    return _labelEmpty;
}

- (UIImageView *)goldEggIcon {
    if (!_goldEggIcon) {
        _goldEggIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldEgg_tips_icon"]];
    }
    return _goldEggIcon;
}

- (UIImageView *)goldTextIcon {
    if (!_goldTextIcon) {
        _goldTextIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldEgg_text_icon"]];
    }
    return _goldTextIcon;
}

@end
