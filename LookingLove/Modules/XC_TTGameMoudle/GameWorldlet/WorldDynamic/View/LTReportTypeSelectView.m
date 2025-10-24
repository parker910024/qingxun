//
//  LTReportTypeSelectView.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTReportTypeSelectView.h"

//model
#import "LTReportModel.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
//core

@interface LTReportTypeSelectView ()<
UITableViewDataSource,
UITableViewDelegate
>
///选择举报类型
@property (nonatomic, strong) UILabel *titleLab;
///展开箭头
@property (nonatomic, strong) UIButton *arrowImg;
///数据table
@property (nonatomic, strong) UITableView *tableView;
///数据
@property (nonatomic, strong) NSArray *reportModelList;


@end

@implementation LTReportTypeSelectView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        [self addCore];
        [self loadData];
    }
    return self;
}

#pragma mark - public methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tableView.superview) {
        [self hiddenTableList];
    }else {
        [self showTableList];
    }
}

#pragma mark - [系统控件的Protocol]


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reportCell"];
        cell.backgroundColor = UIColorFromRGB(0xF5F5F5);
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    LTReportModel *model = self.reportModelList[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.reportModel = self.reportModelList[indexPath.row];
    self.titleLab.attributedText = nil;
    self.titleLab.text = self.reportModel.name;
    [self hiddenTableList];
}

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol]
- (void)requestrReportGetTypeValueSuccess:(NSArray *)typesArr {
    self.reportModelList = typesArr;
    [self.tableView reloadData];
}

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.layer.cornerRadius = 10;
    [self addSubview:self.titleLab];
    [self addSubview:self.arrowImg];
}

- (void)initConstrations {
    self.titleLab.left = 16;
    self.titleLab.centerY = self.height/2.f;
    self.arrowImg.right = self.width - 15;
    self.arrowImg.centerY = self.height/2.f;
}

- (void)addCore {
//    AddCoreClient(UserSettingCoreClient, self);
}

- (void)loadData {
//    [GetCore(UserSettingCore) requestrReportGetTypeValue];
}

- (void)hiddenTableList {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.height = 0;
    }completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
    }];
}

- (void)showTableList {
    if (!self.reportModelList.count) {
        [self loadData];
    }
    self.tableView.frame = CGRectMake(15, CGRectGetMaxY(self.frame) + 10, KScreenWidth - 15*2, self.superview.height - CGRectGetMaxY(self.frame) - 10);
    [self.superview insertSubview:self.tableView belowSubview:self];
    self.tableView.height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.height = self.superview.height - CGRectGetMaxY(self.frame) - 10;
    }];
}

#pragma mark - getters and setters

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = UIColorFromRGB(0x222222);
        _titleLab.font = [UIFont systemFontOfSize:16];
        NSString *str = @"* 选择类型";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF2960)} range:[str rangeOfString:@"*"]];
        _titleLab.attributedText = attStr;
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UIButton *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowImg setImage:[UIImage imageNamed:@"report_arrow_down"] forState:UIControlStateNormal];
        [_arrowImg setImage:[UIImage imageNamed:@"report_arrow_up"] forState:UIControlStateSelected];
        [_arrowImg sizeToFit];
    }
    return _arrowImg;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 15*2, 420) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
