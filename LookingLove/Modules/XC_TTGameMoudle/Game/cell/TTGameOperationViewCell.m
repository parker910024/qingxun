//
//  TTGameOperationViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameOperationViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"

static NSString *const kBigRoomCellID = @"kBigRoomCellID";
static NSString *const kRoomCellID = @"kRoomCellID";

@interface TTGameOperationViewCell ()<UITableViewDelegate,UITableViewDataSource,TTGameRecommendCellDelegate>

@end

@implementation TTGameOperationViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    
    [self.contentView addSubview:self.tableView];
}

- (void)initConstraint{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.operationArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TTGameHomeModuleModel *model = [self.operationArray safeObjectAtIndex:section];
    return [self returnCellNumberRowsIfSection:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section];
    
    if (indexPath.row < [self returnBigCellNumberRowsIfSection:listModel]) {
        TTGameRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID];
        if (!cell) {
            cell = [[TTGameRecommendBigRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBigRoomCellID];
        }
        cell.delegate = self;
        cell.dataModelArray = [self bigRoomsFromDatas:listModel.data bigRoomCount:indexPath.row WithBigMaxNum:listModel.maxNum WithCellNumber:[self returnBigCellNumberRowsIfSection:listModel]];
        
        return cell;
    }
    
    TTGameRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomCellID];
    if (!cell) {
        cell = [[TTGameRecommendRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRoomCellID];
    }
    cell.delegate = self;
    //分隔线
    cell.separateLine.hidden = YES;
    //数据源
    TTHomeV4DetailData *model = [listModel.data safeObjectAtIndex:indexPath.row + listModel.maxNum - [self returnBigCellNumberRowsIfSection:listModel]];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section];
    if (indexPath.row < [self returnBigCellNumberRowsIfSection:listModel]) {
        return 172;
    }else{
        return 76;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }else{
        return 37;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
        sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 20)];
        titleLabel.text = listModel.title;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        [sectionView addSubview:titleLabel];
        
        return sectionView;
        
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 37)];
        sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, KScreenWidth - 30, 20)];
        titleLabel.text = listModel.title;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        [sectionView addSubview:titleLabel];
        
        return sectionView;
    }
}

/**
 选中大房间
 
 @param data 选中的数据源，为空表示虚位以待
 */
- (void)didSelectBigRoomCell:(TTGameRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data{
    if (data == nil) {
        ///虚位以待
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBigRoomCell:data:)]) {
        [self.delegate didSelectBigRoomCell:cell data:data];
    }
}

/**
 选中小房间
 
 @param data 选中的数据源
 */
- (void)didSelectSmallRoomCell:(TTGameRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSmallAndJumpRoomCell:data:)]) {
        [self.delegate didSelectSmallAndJumpRoomCell:cell data:data];
    }
}


- (NSInteger )returnBigCellNumberRowsIfSection:(TTGameHomeModuleModel *)model{
    NSMutableArray *listArray = model.data.mutableCopy;
    NSInteger bigCell = 0;
    if (model.maxNum > listArray.count) {
        if (listArray.count % 3 == 0) {
            bigCell = listArray.count / 3;
        }else{
            bigCell = listArray.count / 3 + 1;
        }
    }else{
        if (model.maxNum % 3 == 0) {
            bigCell = model.maxNum / 3;
        }else{
            bigCell = model.maxNum / 3 + 1;
        }
    }
    return bigCell;
}

- (NSInteger )returnCellNumberRowsIfSection:(TTGameHomeModuleModel *)model{
    NSMutableArray *listArray = model.data.mutableCopy;
    NSInteger bigCell = 0;
    NSInteger smallRooms = 0;
    if (model.maxNum > listArray.count) {
        if (listArray.count % 3 == 0) {
            bigCell = listArray.count / 3;
        }else{
            bigCell = listArray.count / 3 + 1;
        }
        smallRooms = 0;
    }else{
        if (model.maxNum % 3 == 0) {
            bigCell = model.maxNum / 3;
        }else{
            bigCell = model.maxNum / 3 + 1;
        }
        smallRooms = (listArray.count - model.maxNum) > model.listNum ? model.listNum : (listArray.count - model.maxNum);
    }
    
    return bigCell + smallRooms;
}

- (NSArray<TTHomeV4DetailData *> *)bigRoomsFromDatas:(NSArray<TTHomeV4DetailData *> *)datas bigRoomCount:(NSUInteger)count WithBigMaxNum:(NSInteger )maxNum WithCellNumber:(NSInteger )bigCellNumber{
    
    NSMutableArray<TTHomeV4DetailData *> *dataArray = [NSMutableArray array];
    if (datas.count > 0) {
        if (datas.count >= maxNum) {
            for (int i = count; i < bigCellNumber; i++) {
                if (i < bigCellNumber - 1) {
                    for ( int j = i * 3; j < 3 * (i + 1); j++ ) {
                        if ([datas safeObjectAtIndex:j]) {
                            [dataArray addObject:[datas safeObjectAtIndex:j]];
                        }
                    }
                    break;
                }else{
                    for (int m = i * 3; m < maxNum; m++) {
                        if ([datas safeObjectAtIndex:m]) {
                            [dataArray addObject:[datas safeObjectAtIndex:m]];
                        }
                    }
                    break;
                }
            }
            return dataArray;
        }else{
            for (int i = count; i < bigCellNumber; i++) {
                if (i < bigCellNumber - 1) {
                    for ( int j = i * 3; j < 3 * (i + 1); j++ ) {
                        if ([datas safeObjectAtIndex:j]) {
                            [dataArray addObject:[datas safeObjectAtIndex:j]];
                        }
                    }
                    break;
                }else{
                    for (int m = i * 3; m < datas.count; m++) {
                        if ([datas safeObjectAtIndex:m]) {
                            [dataArray addObject:[datas safeObjectAtIndex:m]];
                        }
                    }
                    break;
                }
            }
            return dataArray;
        }
    }else{
        return dataArray;
    }
}

- (NSMutableArray *)operationArray{
    if (!_operationArray) {
        _operationArray = [NSMutableArray array];
    }
    return _operationArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
