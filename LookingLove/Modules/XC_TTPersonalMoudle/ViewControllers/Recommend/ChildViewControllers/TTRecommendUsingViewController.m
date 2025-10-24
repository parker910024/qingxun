//
//  TTRecommendUsingViewController.m
//  TTPlay
//
//  Created by lee on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRecommendUsingViewController.h"

@interface TTRecommendUsingViewController ()

@end

@implementation TTRecommendUsingViewController

- (void)dealloc {
//    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    AddCoreClient(RecommendClient, self);
//    [GetCore(RecommendCore) getMyRecommendCarState:RecommendState_Using page:1 state:1];
//    self.currentStyle = TTRecommendCellStyleUsing;
}

- (TTRecommendCellStyle)style {
    return TTRecommendCellStyleUsing;
}

@end
