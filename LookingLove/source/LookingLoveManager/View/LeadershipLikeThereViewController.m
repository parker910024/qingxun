//
//  LeadershipLikeThereViewController.m
//  TestConfusion

//  Created by KevinWang on 19/07/18.
//  Copyright ©  2019年 WUJIE INTERACTIVE. All rights reserved.
//

#import "WeMustContentFemaleViewController.h"
#import "TrustDeityYesterdayViewController.h"
#import "InvitedCookTestedViewController.h"
#import "MayEnterRichManTireViewController.h"
#import "PresenceDepthPhilosophiesViewController.h"

#import "SimpleWalkMinuteObject.h"
#import "ReligionMaterialFieldObject.h"
#import "CareLeastDemandObject.h"
#import "KindWithinBelieveObject.h"
#import "TogetherHistoryTrainObject.h"
#import "LeadershipLikeThereViewController.h"

@interface LeadershipLikeThereViewController()

 @end

@implementation LeadershipLikeThereViewController

- (void)viewDidLoad { 

 [super viewDidLoad];
 
  NSInteger classType = 10;

  switch (classType) {
    case 0: {
        UILabel * OppositeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 100, 30)];
        OppositeLabel.backgroundColor = [UIColor yellowColor];
        OppositeLabel.textColor = [UIColor redColor];
        OppositeLabel.text = @"label的文字";
        OppositeLabel.font = [UIFont systemFontOfSize:16];
        OppositeLabel.numberOfLines = 1;
        OppositeLabel.highlighted = YES;
        [self.view addSubview:OppositeLabel];
    
        [self comeTobutterflyrecommendtheyMethodAction:classType]; 
    break;
    }            
    case 1: {
        UIButton *OppositeBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        OppositeBtn.frame = CGRectMake(100, 100, 100, 40);
        [OppositeBtn setTitle:@"按钮01" forState:UIControlStateNormal];
        [OppositeBtn setTitle:@"按钮按下" forState:UIControlStateHighlighted];
        OppositeBtn.backgroundColor = [UIColor grayColor];
        [OppositeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        OppositeBtn .titleLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:OppositeBtn];
   
        [self comeTocherisharguepermitMethodAction:classType]; 
    break;
    }            
    case 2: {
        UIView *OppositeBgView = [[UIView alloc] init];
        OppositeBgView.frame = CGRectMake(0, 0, 100, 200);
        OppositeBgView.alpha = 0.5;
        OppositeBgView.hidden = YES;
        [self.view addSubview:OppositeBgView];
    
        [self comeToserendipitybadfantasticMethodAction:classType];
    break;
    }            
    case 3: {
        UIScrollView *OppositeScrollView = [[UIScrollView alloc] init];
        OppositeScrollView.bounces = NO;
        OppositeScrollView.alwaysBounceVertical = YES;
        OppositeScrollView.alwaysBounceHorizontal = YES;
        OppositeScrollView.backgroundColor = [UIColor redColor];
        OppositeScrollView.pagingEnabled = YES;
        [self.view addSubview:OppositeScrollView];
    
        [self comeToserendipitybadfantasticMethodAction:classType];
    break;
    }            
    case 4: {
        UITextField *OppositeTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
        OppositeTextField.placeholder = @"请输入文字";
        OppositeTextField.text = @"测试";
        OppositeTextField.textColor = [UIColor redColor];
        OppositeTextField.font = [UIFont systemFontOfSize:14];
        OppositeTextField.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:OppositeTextField];
    
        [self comeTopeacesentimentdelicacyMethodAction:classType];
    break;
    }
    default:
      break;
  }

 [self comeTokangarooparticularhorizonMethodAction:classType];
 [self comeTomotherinsteadcombineMethodAction:classType];

}

- (void)comeTokangarooparticularhorizonMethodAction:(NSInteger )indexCount{

  NSString *TheseStr=@"These";
  if ([TheseStr isEqualToString:@"TheseStrWheel"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Snow"];                  
      [array addObject:@"Deliver"];
       
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([TheseStr isEqualToString:@"TheseStrAndIfYou"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Snake"  forKey:@"who"];                    
      [dictionary setObject:@"Threaten"  forKey:@"poor"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([TheseStr isEqualToString:@"TheseStrCook"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Snow"];                  
      [array addObject:@"Deliver"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([TheseStr isEqualToString:@"TheseStrwhether"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Snow"];                  
      [array addObject:@"Deliver"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodryfinishframeMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTomotherinsteadcombineMethodAction:(NSInteger )indexCount{

  NSString *ScheduleStr=@"Schedule";
  if ([ScheduleStr isEqualToString:@"ScheduleStrGather"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"fantastic"];                  
      [array addObject:@"Disease"];
       
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ScheduleStr isEqualToString:@"ScheduleStrnot"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"altered"  forKey:@"Exact"];                    
      [dictionary setObject:@"Dependence"  forKey:@"Birth"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ScheduleStr isEqualToString:@"ScheduleStrTheseThings"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"fantastic"];                  
      [array addObject:@"Disease"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ScheduleStr isEqualToString:@"ScheduleStrTheConclusion"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"fantastic"];                  
      [array addObject:@"Disease"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToaccountthingsdeitMethodAction:(NSInteger )indexCount{

  NSString *IntentionStr=@"Intention";
  if ([IntentionStr isEqualToString:@"IntentionStrCertainty"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Rich"];                  
      [array addObject:@"Scientific"];
       
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([IntentionStr isEqualToString:@"IntentionStrwill"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Narrow"  forKey:@"garden"];                    
      [dictionary setObject:@"yourself"  forKey:@"surmount"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([IntentionStr isEqualToString:@"IntentionStrconsole"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Rich"];                  
      [array addObject:@"Scientific"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([IntentionStr isEqualToString:@"IntentionStrConclusions"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Rich"];                  
      [array addObject:@"Scientific"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTocriticpromiseinternationalMethodAction:(NSInteger )indexCount{

  NSString *cosmopolitanStr=@"cosmopolitan";
  if ([cosmopolitanStr isEqualToString:@"cosmopolitanStrProtect"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Urge"];                  
      [array addObject:@"accidentally"];
       
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosmopolitanStr isEqualToString:@"cosmopolitanStrAction"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Imformation"  forKey:@"Action"];                    
      [dictionary setObject:@"Live"  forKey:@"Rough"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosmopolitanStr isEqualToString:@"cosmopolitanStrBasketball"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Urge"];                  
      [array addObject:@"accidentally"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosmopolitanStr isEqualToString:@"cosmopolitanStrMembership"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Urge"];                  
      [array addObject:@"accidentally"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToimprovepriceeffectiveMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTobutterflyrecommendtheyMethodAction:(NSInteger )indexCount{

  NSString *beStr=@"be";
  if ([beStr isEqualToString:@"beStrAndIfYou"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Tool"];                  
      [array addObject:@"Way"];
       
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([beStr isEqualToString:@"beStrException"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Village"  forKey:@"Guard"];                    
      [dictionary setObject:@"Death"  forKey:@"Neck"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([beStr isEqualToString:@"beStrDeduced"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Tool"];                  
      [array addObject:@"Way"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([beStr isEqualToString:@"beStrAncient"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Tool"];                  
      [array addObject:@"Way"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToskillwillprinceMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTopeacesentimentdelicacyMethodAction:(NSInteger )indexCount{

  NSString *PracticeStr=@"Practice";
  if ([PracticeStr isEqualToString:@"PracticeStrApplication"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Simplicity"];                  
      [array addObject:@"Basketball"];
       
      switch (indexCount) {
        case 0: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTopassionshippoorMethodAction:indexCount];
         break;
        }        
        case 1: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeToproductrichhowMethodAction:indexCount];
          break;
        }        
        case 2: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 3: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTohusbandformerpatientMethodAction:indexCount];
         break;
        }        
        case 4: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 5: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotwinkletruthcherishMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PracticeStr isEqualToString:@"PracticeStrMistake"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Library"  forKey:@"Appearance"];                    
      [dictionary setObject:@"ReadThis"  forKey:@"Conclusions"];
      
      switch (indexCount) {
        case 0: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTopassionshippoorMethodAction:indexCount];
         break;
        }        
        case 1: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeToproductrichhowMethodAction:indexCount];
          break;
        }        
        case 2: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 3: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTohusbandformerpatientMethodAction:indexCount];
         break;
        }        
        case 4: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 5: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotwinkletruthcherishMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PracticeStr isEqualToString:@"PracticeStrTear"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Simplicity"];                  
      [array addObject:@"Basketball"];
      
      switch (indexCount) {
        case 0: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTopassionshippoorMethodAction:indexCount];
         break;
        }        
        case 1: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeToproductrichhowMethodAction:indexCount];
          break;
        }        
        case 2: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 3: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTohusbandformerpatientMethodAction:indexCount];
         break;
        }        
        case 4: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 5: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotwinkletruthcherishMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PracticeStr isEqualToString:@"PracticeStrmore"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Simplicity"];                  
      [array addObject:@"Basketball"];
      
      switch (indexCount) {
        case 0: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTopassionshippoorMethodAction:indexCount];
         break;
        }        
        case 1: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeToproductrichhowMethodAction:indexCount];
          break;
        }        
        case 2: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 3: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTohusbandformerpatientMethodAction:indexCount];
         break;
        }        
        case 4: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotravelshipdueMethodAction:indexCount];
         break;
        }        
        case 5: {
          TrustDeityYesterdayViewController *TrustDeityYesterdayVC = [[TrustDeityYesterdayViewController alloc] init];
          [TrustDeityYesterdayVC comeTotwinkletruthcherishMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTomoralgracepressMethodAction:(NSInteger )indexCount{

  NSString *FellowStr=@"Fellow";
  if ([FellowStr isEqualToString:@"FellowStrProtect"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Request"];                  
      [array addObject:@"Exact"];
       
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToandlanguagechooseMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FellowStr isEqualToString:@"FellowStrbusiness"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Aim"  forKey:@"Luck"];                    
      [dictionary setObject:@"Way"  forKey:@"ComeTo"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToandlanguagechooseMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FellowStr isEqualToString:@"FellowStronly"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Request"];                  
      [array addObject:@"Exact"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToandlanguagechooseMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FellowStr isEqualToString:@"FellowStrWarn"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Request"];                  
      [array addObject:@"Exact"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTolanguageessentialbananaMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToelectionassociationmannerMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToandlanguagechooseMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTocherisharguepermitMethodAction:(NSInteger )indexCount{

  NSString *FriendlyStr=@"Friendly";
  if ([FriendlyStr isEqualToString:@"FriendlyStrchecking"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"same"];                  
      [array addObject:@"Practical"];
       
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FriendlyStr isEqualToString:@"FriendlyStrmatter"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Government"  forKey:@"choosing"];                    
      [dictionary setObject:@"Desk"  forKey:@"Seed"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FriendlyStr isEqualToString:@"FriendlyStrPrince"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"same"];                  
      [array addObject:@"Practical"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([FriendlyStr isEqualToString:@"FriendlyStrBird"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"same"];                  
      [array addObject:@"Practical"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTocertainsoulmatetreeMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTodetailfaithfreedomMethodAction:indexCount];
         break;
        }        
        case 5: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTorelationelectionresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToserendipitybadfantasticMethodAction:(NSInteger )indexCount{

  NSString *HideStr=@"Hide";
  if ([HideStr isEqualToString:@"HideStrlove"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"them"];                  
      [array addObject:@"which"];
       
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTocurrentthickliteratureMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HideStr isEqualToString:@"HideStrFellow"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"they"  forKey:@"order"];                    
      [dictionary setObject:@"Warn"  forKey:@"FromAll"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTocurrentthickliteratureMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HideStr isEqualToString:@"HideStrAboveYou"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"them"];                  
      [array addObject:@"which"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTocurrentthickliteratureMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HideStr isEqualToString:@"HideStrDistinguish"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"them"];                  
      [array addObject:@"which"];
      
      switch (indexCount) {
        case 0: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
         break;
        }        
        case 1: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTokillsettleimagineMethodAction:indexCount];
          break;
        }        
        case 2: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTodistrictattemptblossomMethodAction:indexCount];
         break;
        }        
        case 3: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeToprogressloggedsingleMethodAction:indexCount];
         break;
        }        
        case 4: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTocurrentthickliteratureMethodAction:indexCount];
         break;
        }        
        case 5: {
          PresenceDepthPhilosophiesViewController *PresenceDepthPhilosophiesVC = [[PresenceDepthPhilosophiesViewController alloc] init];
          [PresenceDepthPhilosophiesVC comeTopumpkinaveragehospitalMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToinfluencesamesurmountMethodAction:(NSInteger )indexCount{

  NSString *InstrumentStr=@"Instrument";
  if ([InstrumentStr isEqualToString:@"InstrumentStrFromThe"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Victory"];                  
      [array addObject:@"Lip"];
       
      switch (indexCount) {
        case 0: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeToquickearthlikelyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTostaffpickpropertyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([InstrumentStr isEqualToString:@"InstrumentStrDesk"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"twinkle"  forKey:@"Wire"];                    
      [dictionary setObject:@"those"  forKey:@"Once"];
      
      switch (indexCount) {
        case 0: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeToquickearthlikelyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTostaffpickpropertyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([InstrumentStr isEqualToString:@"InstrumentStrmoment"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Victory"];                  
      [array addObject:@"Lip"];
      
      switch (indexCount) {
        case 0: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeToquickearthlikelyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTostaffpickpropertyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([InstrumentStr isEqualToString:@"InstrumentStrIntention"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Victory"];                  
      [array addObject:@"Lip"];
      
      switch (indexCount) {
        case 0: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeToquickearthlikelyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTocompareemployoriginMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTodollarlatterfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustContentFemaleViewController *WeMustContentFemaleVC = [[WeMustContentFemaleViewController alloc] init];
          [WeMustContentFemaleVC comeTostaffpickpropertyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)addLoadheatbeparkInfo:(NSInteger )typeNumber{

  NSString *PreferStr=@"Prefer";
  if ([PreferStr isEqualToString:@"PreferStrcosmopolitan"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"yourself"];                                  
      [array addObject:@"your"];
       

      switch (typeNumber) {
        case 0: {
          [[SimpleWalkMinuteObject instance]  objcertainimagineattentionInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[SimpleWalkMinuteObject instance]  objexpressstaffpoolInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[SimpleWalkMinuteObject instance]  objdreamvoteblackInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[SimpleWalkMinuteObject instance]  objworthpurposegalaxyInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[SimpleWalkMinuteObject instance]   objrelationdifficultradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[SimpleWalkMinuteObject instance]   objworthpurposegalaxyInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PreferStr isEqualToString:@"PreferStrhorizon"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Flower"  forKey:@"Cloud"];                                    
      [dictionary setObject:@"Pair"  forKey:@"Solution"];
      

      switch (typeNumber) {
        case 0: {
          [[SimpleWalkMinuteObject instance]  objcertainimagineattentionInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[SimpleWalkMinuteObject instance]  objexpressstaffpoolInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[SimpleWalkMinuteObject instance]  objdreamvoteblackInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[SimpleWalkMinuteObject instance]  objworthpurposegalaxyInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[SimpleWalkMinuteObject instance]   objrelationdifficultradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[SimpleWalkMinuteObject instance]   objworthpurposegalaxyInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PreferStr isEqualToString:@"PreferStrArithmetic"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Flower"  forKey:@"Cloud"];                                    
      [dictionary setObject:@"Pair"  forKey:@"Solution"];
      

      switch (typeNumber) {
        case 0: {
          [[SimpleWalkMinuteObject instance]  objcertainimagineattentionInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[SimpleWalkMinuteObject instance]  objexpressstaffpoolInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[SimpleWalkMinuteObject instance]  objdreamvoteblackInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[SimpleWalkMinuteObject instance]  objworthpurposegalaxyInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[SimpleWalkMinuteObject instance]   objrelationdifficultradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[SimpleWalkMinuteObject instance]   objworthpurposegalaxyInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PreferStr isEqualToString:@"PreferStrSoil"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"yourself"];                                  
      [array addObject:@"your"];
      

      switch (typeNumber) {
        case 0: {
          [[SimpleWalkMinuteObject instance]  objcertainimagineattentionInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[SimpleWalkMinuteObject instance]  objexpressstaffpoolInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[SimpleWalkMinuteObject instance]  objdreamvoteblackInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[SimpleWalkMinuteObject instance]  objworthpurposegalaxyInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[SimpleWalkMinuteObject instance]   objrelationdifficultradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[SimpleWalkMinuteObject instance]   objworthpurposegalaxyInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadpeekaboochooseforInfo:(NSInteger )typeNumber{

  NSString *AvenueStr=@"Avenue";
  if ([AvenueStr isEqualToString:@"AvenueStrTheater"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"mother"];                                  
      [array addObject:@"yourself"];
       

      switch (typeNumber) {
        case 0: {
          [[ReligionMaterialFieldObject instance]  objparticularsunshinedependInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ReligionMaterialFieldObject instance]  objglassprogressrecognizeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ReligionMaterialFieldObject instance]  objoperatestorethatInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ReligionMaterialFieldObject instance]  objthemstockeverythingInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ReligionMaterialFieldObject instance]   objunlessfaithhotInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ReligionMaterialFieldObject instance]   objmultiplythosefinishInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AvenueStr isEqualToString:@"AvenueStrMembership"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Ought"  forKey:@"Loan"];                                    
      [dictionary setObject:@"Soulmate"  forKey:@"Friendly"];
      

      switch (typeNumber) {
        case 0: {
          [[ReligionMaterialFieldObject instance]  objparticularsunshinedependInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ReligionMaterialFieldObject instance]  objglassprogressrecognizeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ReligionMaterialFieldObject instance]  objoperatestorethatInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ReligionMaterialFieldObject instance]  objthemstockeverythingInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ReligionMaterialFieldObject instance]   objunlessfaithhotInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ReligionMaterialFieldObject instance]   objmultiplythosefinishInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AvenueStr isEqualToString:@"AvenueStrSwing"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Ought"  forKey:@"Loan"];                                    
      [dictionary setObject:@"Soulmate"  forKey:@"Friendly"];
      

      switch (typeNumber) {
        case 0: {
          [[ReligionMaterialFieldObject instance]  objparticularsunshinedependInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ReligionMaterialFieldObject instance]  objglassprogressrecognizeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ReligionMaterialFieldObject instance]  objoperatestorethatInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ReligionMaterialFieldObject instance]  objthemstockeverythingInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ReligionMaterialFieldObject instance]   objunlessfaithhotInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ReligionMaterialFieldObject instance]   objmultiplythosefinishInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AvenueStr isEqualToString:@"AvenueStrsmile"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"mother"];                                  
      [array addObject:@"yourself"];
      

      switch (typeNumber) {
        case 0: {
          [[ReligionMaterialFieldObject instance]  objparticularsunshinedependInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ReligionMaterialFieldObject instance]  objglassprogressrecognizeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ReligionMaterialFieldObject instance]  objoperatestorethatInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ReligionMaterialFieldObject instance]  objthemstockeverythingInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ReligionMaterialFieldObject instance]   objunlessfaithhotInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ReligionMaterialFieldObject instance]   objmultiplythosefinishInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadbeingupontruthInfo:(NSInteger )typeNumber{

  NSString *timesStr=@"times";
  if ([timesStr isEqualToString:@"timesStrReference"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"hilarious"];                                  
      [array addObject:@"Pair"];
       

      switch (typeNumber) {
        case 0: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CareLeastDemandObject instance]   objstafffinisheastInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CareLeastDemandObject instance]   objserendipitydiscussiondressInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([timesStr isEqualToString:@"timesStrKnee"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Center"  forKey:@"Pray"];                                    
      [dictionary setObject:@"Guide"  forKey:@"obstacles"];
      

      switch (typeNumber) {
        case 0: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CareLeastDemandObject instance]   objstafffinisheastInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CareLeastDemandObject instance]   objserendipitydiscussiondressInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([timesStr isEqualToString:@"timesStrPassage"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Center"  forKey:@"Pray"];                                    
      [dictionary setObject:@"Guide"  forKey:@"obstacles"];
      

      switch (typeNumber) {
        case 0: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CareLeastDemandObject instance]   objstafffinisheastInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CareLeastDemandObject instance]   objserendipitydiscussiondressInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([timesStr isEqualToString:@"timesStrMsg"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"hilarious"];                                  
      [array addObject:@"Pair"];
      

      switch (typeNumber) {
        case 0: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CareLeastDemandObject instance]  objhairrealizeandInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CareLeastDemandObject instance]  objinsteaddegreeframeInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CareLeastDemandObject instance]   objstafffinisheastInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CareLeastDemandObject instance]   objserendipitydiscussiondressInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadcurrentthickliteratureInfo:(NSInteger )typeNumber{

  NSString *MysteryStr=@"Mystery";
  if ([MysteryStr isEqualToString:@"MysteryStrCoast"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"fail"];                                  
      [array addObject:@"TestOf"];
       

      switch (typeNumber) {
        case 0: {
          [[KindWithinBelieveObject instance]  objtwocanpatternInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[KindWithinBelieveObject instance]  objdreamrelativewillInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[KindWithinBelieveObject instance]  objunlessmerefitInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[KindWithinBelieveObject instance]  objproductioninternationalchanceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[KindWithinBelieveObject instance]   objqualityorderthanInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[KindWithinBelieveObject instance]   objtimessizeassociationInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MysteryStr isEqualToString:@"MysteryStrExchange"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Hate"  forKey:@"questions"];                                    
      [dictionary setObject:@"passion"  forKey:@"Experiment"];
      

      switch (typeNumber) {
        case 0: {
          [[KindWithinBelieveObject instance]  objtwocanpatternInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[KindWithinBelieveObject instance]  objdreamrelativewillInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[KindWithinBelieveObject instance]  objunlessmerefitInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[KindWithinBelieveObject instance]  objproductioninternationalchanceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[KindWithinBelieveObject instance]   objqualityorderthanInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[KindWithinBelieveObject instance]   objtimessizeassociationInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MysteryStr isEqualToString:@"MysteryStrEnough"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Hate"  forKey:@"questions"];                                    
      [dictionary setObject:@"passion"  forKey:@"Experiment"];
      

      switch (typeNumber) {
        case 0: {
          [[KindWithinBelieveObject instance]  objtwocanpatternInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[KindWithinBelieveObject instance]  objdreamrelativewillInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[KindWithinBelieveObject instance]  objunlessmerefitInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[KindWithinBelieveObject instance]  objproductioninternationalchanceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[KindWithinBelieveObject instance]   objqualityorderthanInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[KindWithinBelieveObject instance]   objtimessizeassociationInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MysteryStr isEqualToString:@"MysteryStrPhilosophies"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"fail"];                                  
      [array addObject:@"TestOf"];
      

      switch (typeNumber) {
        case 0: {
          [[KindWithinBelieveObject instance]  objtwocanpatternInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[KindWithinBelieveObject instance]  objdreamrelativewillInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[KindWithinBelieveObject instance]  objunlessmerefitInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[KindWithinBelieveObject instance]  objproductioninternationalchanceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[KindWithinBelieveObject instance]   objqualityorderthanInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[KindWithinBelieveObject instance]   objtimessizeassociationInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadoperateshallchiefInfo:(NSInteger )typeNumber{

  NSString *MinisterStr=@"Minister";
  if ([MinisterStr isEqualToString:@"MinisterStrneighborhoods"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Single"];                                  
      [array addObject:@"Valley"];
       

      switch (typeNumber) {
        case 0: {
          [[TogetherHistoryTrainObject instance]  objmaybestocktranquilityInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TogetherHistoryTrainObject instance]  objtriallotsentimentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TogetherHistoryTrainObject instance]  objgameparadoxdifficultInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TogetherHistoryTrainObject instance]  objflyeastsurmountInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TogetherHistoryTrainObject instance]   objrockblissradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TogetherHistoryTrainObject instance]   objtriallotsentimentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MinisterStr isEqualToString:@"MinisterStronly"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Blow"  forKey:@"AndIfYou"];                                    
      [dictionary setObject:@"galaxy"  forKey:@"Soil"];
      

      switch (typeNumber) {
        case 0: {
          [[TogetherHistoryTrainObject instance]  objmaybestocktranquilityInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TogetherHistoryTrainObject instance]  objtriallotsentimentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TogetherHistoryTrainObject instance]  objgameparadoxdifficultInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TogetherHistoryTrainObject instance]  objflyeastsurmountInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TogetherHistoryTrainObject instance]   objrockblissradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TogetherHistoryTrainObject instance]   objtriallotsentimentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MinisterStr isEqualToString:@"MinisterStravoid"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Blow"  forKey:@"AndIfYou"];                                    
      [dictionary setObject:@"galaxy"  forKey:@"Soil"];
      

      switch (typeNumber) {
        case 0: {
          [[TogetherHistoryTrainObject instance]  objmaybestocktranquilityInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TogetherHistoryTrainObject instance]  objtriallotsentimentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TogetherHistoryTrainObject instance]  objgameparadoxdifficultInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TogetherHistoryTrainObject instance]  objflyeastsurmountInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TogetherHistoryTrainObject instance]   objrockblissradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TogetherHistoryTrainObject instance]   objtriallotsentimentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([MinisterStr isEqualToString:@"MinisterStryour"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Single"];                                  
      [array addObject:@"Valley"];
      

      switch (typeNumber) {
        case 0: {
          [[TogetherHistoryTrainObject instance]  objmaybestocktranquilityInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TogetherHistoryTrainObject instance]  objtriallotsentimentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TogetherHistoryTrainObject instance]  objgameparadoxdifficultInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TogetherHistoryTrainObject instance]  objflyeastsurmountInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TogetherHistoryTrainObject instance]   objrockblissradioInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TogetherHistoryTrainObject instance]   objtriallotsentimentInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  NSInteger typeNumber = 10;  
  [self addLoadoperateshallchiefInfo:typeNumber];
  
  [self addLoadbeingupontruthInfo:typeNumber];
  
  [self addLoadheatbeparkInfo:typeNumber];
  
  [self addLoadcurrentthickliteratureInfo:typeNumber];
  
  [self addLoadpeekaboochooseforInfo:typeNumber];
 
}




-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

@end