//
//  TTGameSquareTableViewCell.m
//  AFNetworking
//
//  Created by User on 2019/5/7.
//

#import "TTGameSquareTableViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "TTGameSquareCollectionViewCell.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTHomeV4DetailData.h"

@interface TTGameSquareTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTGameSquareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
        [self initConstraint];
    }
    
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
}

- (void)setDatasourceArray:(NSMutableArray *)datasourceArray {
    _datasourceArray = datasourceArray;
    [self.collectionView reloadData];
}


- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGameSquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SquareItemCell" forIndexPath:indexPath];
    
    cell.model = self.datasourceArray[indexPath.row];
    
    return cell;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake((KScreenWidth - 17 * 3) / 2, (KScreenWidth - 17 * 3) / 2 + 50);
        layout.sectionInset = UIEdgeInsetsMake(0, 17, 0, 17);
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 17;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[TTGameSquareCollectionViewCell class] forCellWithReuseIdentifier:@"SquareItemCell"];
    }
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTHomeV4DetailData *data = self.datasourceArray[indexPath.row];
    
    if (data == nil) {
//        assert(0);
        return;
    }
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
