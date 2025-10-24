//
//  TTRecommendUsedViewController.m
//  TTPlay
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRecommendUsedViewController.h"

@interface TTRecommendUsedViewController ()

@end

@implementation TTRecommendUsedViewController

- (void)dealloc {
//    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    AddCoreClient(RecommendClient, self);
//    [GetCore(RecommendCore) getMyRecommendCarState:RecommendState_HadUse page:1 state:1];
}
- (TTRecommendCellStyle)style {
    return TTRecommendCellStyleUsed;
}

@end
