//
//  TTBaseDressShopViewController.h
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "TTDressUpUIClient.h"

@interface TTBaseDressUpShopViewController : BaseCollectionViewController
<
    ZJScrollPageViewChildVcDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (nonatomic, assign) TTDressUpPlaceType type;//
@property (nonatomic, strong) NSMutableArray  *data;//数据
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) long long userID;//
@property (nonatomic, assign) NSInteger currentSelectIndex;//当前选择

@end
