//
//  TTGameViewController+FocusList.m
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController+FocusList.h"
#import "TTGameViewController+Request.h"

#import "PraiseCore.h"
#import "Attention.h"

#import "NSArray+Safe.h"
#import "XCCurrentVCStackManager.h"

@implementation TTGameViewController (FocusList)

#pragma mark - AuthCoreClinet
- (void)onLoginSuccess {
    [self pullDownRefresh:1];
    
    // ‘登录页’和‘自动登录’都会触发 onLoginSuccess
    // 如果是登录页触发，理论上此时页面应该是停留在登录页，此时请求签到详情 requestSignDetail
    // 可能导致登录页尝试弹出签到弹窗（该情况不被允许，已作忽略处理）
    // 所以，此处只在显示当前控制器时请求（即自动登录的情况）
    // ‘登录页’的触发在 loginViewControllerDismiss 流程里处理
    
    if ([[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass: self.class]) {
        [self requestSignDetail];
    }
}

- (void)onImLogoutSuccess {
    [self.focusArray removeAllObjects];
    
    [self.tableView reloadData];
}


#pragma mark - ImFriendCoreClient
- (void)onFriendChanged{
    [self pullDownRefresh:1];
}

#pragma mark - PraiseCoreClient
- (void) onRequestAttentionListStateForGamePage:(int)state success:(NSArray *)attentionList{
    if (self.currentpage == 1) {
        [self.focusArray removeAllObjects];
    }
    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_Attention)];
    if (attentionList.count > 0) {
        NSMutableArray *attentionArray = [NSMutableArray array];
        if (state) { //上拉
            [self.focusArray addObjectsFromArray:[attentionList mutableCopy]];
        }else { //下拉
            self.focusArray = [attentionList mutableCopy];
        }
        [self.tableView endRefreshStatus:state hasMoreData:YES];
        
        for (int i = 0; i < self.focusArray.count; i++) {
            Attention *attention = [self.focusArray safeObjectAtIndex:i];
            if (attention.userInRoom.valid) {
                [attentionArray addObject:attention];
            }
        }
        
        [self.focusArray removeAllObjects];
        
        [self.focusArray addObjectsFromArray:attentionArray];
        
        if (self.focusArray.count > 0) {
            [self.allDataDictionary setObject:self.focusArray forKey:@(GameDataIndexForArray_Attention)];
            [self arraySorting];
            //            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            //            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self.allDataDictionary setObject:@"NoData" forKey:@(GameDataIndexForArray_Attention)];
            //            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            //            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        [self.allDataDictionary setObject:@"NoData" forKey:@(GameDataIndexForArray_Attention)];
        [self arraySorting];
        //        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        //        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //        [self.tableView endRefreshStatus:state hasMoreData:YES];
    }
}

- (void)arraySorting{
    self.dictKeyArray = self.allDataDictionary.allKeys.mutableCopy;
    [self.dictKeyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
}

@end
