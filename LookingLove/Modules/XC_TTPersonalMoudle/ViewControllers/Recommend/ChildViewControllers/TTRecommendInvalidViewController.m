//
//  TTRecommendInvalidViewController.m
//  TTPlay
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRecommendInvalidViewController.h"

@interface TTRecommendInvalidViewController ()

@end

@implementation TTRecommendInvalidViewController

- (void)dealloc {
//    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    AddCoreClient(RecommendClient, self);
//    [GetCore(RecommendCore) getMyRecommendCarState:RecommendState_Timeout page:1 state:1];
}
- (TTRecommendCellStyle)style {
    return TTRecommendCellStyleInvalid;
}
@end
