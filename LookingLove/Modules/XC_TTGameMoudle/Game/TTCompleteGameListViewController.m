//
//  TTCompleteGameListViewController.m
//  TTPlay
//
//  Created by new on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCompleteGameListViewController.h"
#import "CPGameCore.h"
#import "AuthCore.h"
#import "CPGameCoreClient.h"
#import "RoomCoreV2.h"

#import "XCCurrentVCStackManager.h"
#import "TTPopup.h"

#import <Masonry/Masonry.h>
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCMacros.h"
#import "XCCurrentVCStackManager.h"
#import "XCHUDTool.h"

#import "TTGameListCollectionViewCell.h"
#import "TTGameFindFriendViewController.h"
#import "TTGameMatchingViewController.h"

#import "XCMediator+TTRoomMoudleBridge.h" // 匹配到跳转房间
#import "XCMediator+TTGameModuleBridge.h"
#import "TTFamilyBaseAlertController.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"

static NSString *const kCompleteCell = @"kCompleteID";

@interface TTCompleteGameListViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL controlMatch;

@end

@implementation TTCompleteGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"全部游戏";
    
    [self initConstrations];
    
    [self addCore];
    
    self.dataArray = [NSMutableArray array];
    
    [[GetCore(CPGameCore) requestGameList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
    }];
    
    [self addNavigationItemWithImageNames:@[@"icon_game_top"] isLeft:NO target:self action:@selector(rightItemClickCompleteGamelistAction:) tags:@[@(1001)]];
    
    [self setupRefreshTarget:self.collectionView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.controlMatch = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.controlMatch = NO;
}

- (void)pullDownRefresh:(int)page {
    [[GetCore(CPGameCore) requestGameList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
    }];
}

- (void)initConstrations{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationHeight + 10);
    }];
    
    [self.collectionView registerClass:[TTGameListCollectionViewCell class] forCellWithReuseIdentifier:kCompleteCell];
}

- (void)addCore{
    AddCoreClient(CPGameCoreClient, self);
}

#pragma mark -
#pragma mark rightItem Click Action
- (void)rightItemClickCompleteGamelistAction:(UIButton *)item {
    if (item.tag == 1001) {
        [[BaiduMobStat defaultStat]logEvent:@"gamepage_homepage" eventLabel:@"游戏榜单"];
        
        NSString *skipurl = HtmlUrlKey(kGameRankURL);
        
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        vc.urlString = skipurl;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTGameListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCompleteCell forIndexPath:indexPath];
    
    [cell configCompleteGameData:self.dataArray WithIndexPath:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = (KScreenWidth - 20 - 26) / 3 * 1.18 + 10;
    
    NSInteger number = (self.dataArray.count - 1) / 3;
    
    return height + number * height;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.controlMatch) {
        self.controlMatch = YES;
    }else{
        return;
    }
    if (indexPath.row == 0) {
        [[BaiduMobStat defaultStat] logEvent:@"game_homepage_player" eventLabel:@"游戏首页-找玩友入口"];
#ifdef DEBUG
        NSLog(@"game_homepage_player");
#else
        
#endif
        UIViewController *findFriendVC = [[XCMediator sharedInstance] ttGameMoudle_TTGameFindFriendViewController];
        [self.navigationController pushViewController:findFriendVC animated:YES];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterYouRoom"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterMyRoom"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"matchType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[BaiduMobStat defaultStat]logEvent:@"all_game_choice" eventLabel:@"选择游戏发起"];
        
        TTGameMatchingViewController *gameVC = [[TTGameMatchingViewController alloc] init];
        CPGameListModel *model = [self.dataArray safeObjectAtIndex:indexPath.row - 1];
        gameVC.hiddenNavBar = YES;
        gameVC.model = model;
        
        if (GetCore(RoomCoreV2).isInRoom){
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstExitRoomTip"] isEqualToString:@"FirstExitRoomTip"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstExitRoomTip" forKey:@"firstExitRoomTip"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                @weakify(self)
                [TTPopup alertWithMessage:@"匹配游戏需退出当前房间" confirmHandler:^{
                    
                    @strongify(self)
                    [GetCore(RoomCoreV2) closeRoomWithBlock:GetCore(AuthCore).getUid.userIDValue Success:^(UserID uid) {
                        
                        [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                        [self.navigationController pushViewController:gameVC animated:YES];
                        
                    } failure:^(NSNumber *resCode, NSString *message) {
                        self.controlMatch = NO;
                    }];
                    
                } cancelHandler:^{
                    self.controlMatch = NO;
                }];
                
                return;
                
            }else{
                [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                [XCHUDTool showGIFLoading];
                @weakify(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [XCHUDTool hideHUD];
                    self.controlMatch = NO;
                    [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:gameVC animated:YES];
                });
            }
        }else{
            [self.navigationController pushViewController:gameVC animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (KScreenWidth - 20 - 26) / 3;
    CGFloat height = (KScreenWidth - 20 - 26) / 3 * 1.18;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 12);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark --- CPGameCoreClient ---
- (void)onGameList:(NSArray *)listArray{
    
    [self.dataArray removeAllObjects];
    
    [self.dataArray addObjectsFromArray:listArray];
    
    [self.collectionView reloadData];
    
    [self successEndRefreshStatus:0 hasMoreData:NO];
    
}

- (void)dealloc{
    
    RemoveCoreClientAll(self);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
