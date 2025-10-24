//
//  TTRedbagConditionListView.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/14.
//

#import "TTRedbagConditionListView.h"
#import "TTRedbagConditionListTableViewCell.h"

#import <Masonry/Masonry.h>

@interface TTRedbagConditionListView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TTRedbagConditionListView

- (instancetype)init {
    if (self == [super init]) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

/*添加控件*/
- (void)initViews {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
}

// 布局设置
- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requireTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTRedbagConditionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTRedbagConditionListTableViewCell"];
    cell.titleLabel.text = self.requireTypeList[indexPath.row][@"desc"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.conditionListSelectBlock(self.requireTypeList[indexPath.row]);
}

#pragma mark - Setter && Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 97;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TTRedbagConditionListTableViewCell class] forCellReuseIdentifier:@"TTRedbagConditionListTableViewCell"];
    }
    return _tableView;
}

- (void)setRequireTypeList:(NSArray *)requireTypeList {
    _requireTypeList = requireTypeList;
    [self.tableView reloadData];
}

@end
