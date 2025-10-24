//
//  WeMustContentFemaleViewController.m
//  TestConfusion

//  Created by KevinWang on 19/07/18.
//  Copyright ©  2019年 WUJIE INTERACTIVE. All rights reserved.
//

#import "MayEnterRichManTireViewController.h"
#import "MembershipComeToStruggleViewController.h"
#import "MembershipComeToStruggleViewController.h"
#import "FreshBirthDeskViewController.h"
#import "InvitedCookTestedViewController.h"

#import "ProduceBearDecideObject.h"
#import "TaxTalkNecessaryObject.h"
#import "ActionExperienceAmountObject.h"
#import "AlthoughBetterGirlObject.h"
#import "DanceSpendSpaceObject.h"
#import "WeMustContentFemaleViewController.h"

@interface WeMustContentFemaleViewController()

 @end

@implementation WeMustContentFemaleViewController

- (void)viewDidLoad { 

 [super viewDidLoad];
 
  NSInteger classType = 10;

  switch (classType) {
    case 0: {
        UILabel * BirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 100, 30)];
        BirdLabel.backgroundColor = [UIColor yellowColor];
        BirdLabel.textColor = [UIColor redColor];
        BirdLabel.text = @"label的文字";
        BirdLabel.font = [UIFont systemFontOfSize:16];
        BirdLabel.numberOfLines = 1;
        BirdLabel.highlighted = YES;
        [self.view addSubview:BirdLabel];
    
        [self comeToquickearthlikelyMethodAction:classType]; 
    break;
    }            
    case 1: {
        UIButton *BirdBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        BirdBtn.frame = CGRectMake(100, 100, 100, 40);
        [BirdBtn setTitle:@"按钮01" forState:UIControlStateNormal];
        [BirdBtn setTitle:@"按钮按下" forState:UIControlStateHighlighted];
        BirdBtn.backgroundColor = [UIColor grayColor];
        [BirdBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        BirdBtn .titleLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:BirdBtn];
   
        [self comeToexceptpoolcornerMethodAction:classType]; 
    break;
    }            
    case 2: {
        UIView *BirdBgView = [[UIView alloc] init];
        BirdBgView.frame = CGRectMake(0, 0, 100, 200);
        BirdBgView.alpha = 0.5;
        BirdBgView.hidden = YES;
        [self.view addSubview:BirdBgView];
    
        [self comeTodollarlatterfitMethodAction:classType];
    break;
    }            
    case 3: {
        UIScrollView *BirdScrollView = [[UIScrollView alloc] init];
        BirdScrollView.bounces = NO;
        BirdScrollView.alwaysBounceVertical = YES;
        BirdScrollView.alwaysBounceHorizontal = YES;
        BirdScrollView.backgroundColor = [UIColor redColor];
        BirdScrollView.pagingEnabled = YES;
        [self.view addSubview:BirdScrollView];
    
        [self comeTofinishopportunitydiscussionMethodAction:classType];
    break;
    }            
    case 4: {
        UITextField *BirdTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
        BirdTextField.placeholder = @"请输入文字";
        BirdTextField.text = @"测试";
        BirdTextField.textColor = [UIColor redColor];
        BirdTextField.font = [UIFont systemFontOfSize:14];
        BirdTextField.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:BirdTextField];
    
        [self comeToarrangemodelbananaMethodAction:classType];
    break;
    }
    default:
      break;
  }

 [self comeTodollarlatterfitMethodAction:classType];
 [self comeTogrowthaverageopportunityMethodAction:classType];

}

- (void)comeTodollarlatterfitMethodAction:(NSInteger )indexCount{

  NSString *OnceStr=@"Once";
  if ([OnceStr isEqualToString:@"OnceStrSoil"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"which"];                  
      [array addObject:@"Experiment"];
       
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomedicaldifficulttreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OnceStr isEqualToString:@"OnceStrOrdinary"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Connection"  forKey:@"Double"];                    
      [dictionary setObject:@"Tested"  forKey:@"TheWritings"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomedicaldifficulttreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OnceStr isEqualToString:@"OnceStrwork"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"which"];                  
      [array addObject:@"Experiment"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomedicaldifficulttreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OnceStr isEqualToString:@"OnceStrDeity"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"which"];                  
      [array addObject:@"Experiment"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomedicaldifficulttreeMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTogrowthaverageopportunityMethodAction:(NSInteger )indexCount{

  NSString *gardenStr=@"garden";
  if ([gardenStr isEqualToString:@"gardenStrdeath"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"umbrella"];                  
      [array addObject:@"Certainty"];
       
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobumblebeeinsteadkangarooMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
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

  }else if ([gardenStr isEqualToString:@"gardenStrplainly"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Tear"  forKey:@"WithHi"];                    
      [dictionary setObject:@"KnowHow"  forKey:@"choosing"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobumblebeeinsteadkangarooMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
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

  }else if ([gardenStr isEqualToString:@"gardenStrToPlainnessAnd"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"umbrella"];                  
      [array addObject:@"Certainty"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobumblebeeinsteadkangarooMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
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

  }else if ([gardenStr isEqualToString:@"gardenStrloom"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"umbrella"];                  
      [array addObject:@"Certainty"];
      
      switch (indexCount) {
        case 0: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobumblebeeinsteadkangarooMethodAction:indexCount];
         break;
        }        
        case 1: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
          break;
        }        
        case 2: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeToremarkmainquietMethodAction:indexCount];
         break;
        }        
        case 3: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTotrialpreventaverageMethodAction:indexCount];
         break;
        }        
        case 4: {
          InvitedCookTestedViewController *InvitedCookTestedVC = [[InvitedCookTestedViewController alloc] init];
          [InvitedCookTestedVC comeTobananawhetheruponMethodAction:indexCount];
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


- (void)comeToquickearthlikelyMethodAction:(NSInteger )indexCount{

  NSString *DirtStr=@"Dirt";
  if ([DirtStr isEqualToString:@"DirtStrsophisticated"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Destiny"];                  
      [array addObject:@"HereinWas"];
       
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTorecommenddeepinfluenceMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToliteratureyouviolationsMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([DirtStr isEqualToString:@"DirtStrThatAllMight"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Safe"  forKey:@"Moreover"];                    
      [dictionary setObject:@"Guess"  forKey:@"Failure"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTorecommenddeepinfluenceMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToliteratureyouviolationsMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([DirtStr isEqualToString:@"DirtStrparticular"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Destiny"];                  
      [array addObject:@"HereinWas"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTorecommenddeepinfluenceMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToliteratureyouviolationsMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([DirtStr isEqualToString:@"DirtStrTheColor"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Destiny"];                  
      [array addObject:@"HereinWas"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTorecommenddeepinfluenceMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToliteratureyouviolationsMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTolistenbusinesslackMethodAction:(NSInteger )indexCount{

  NSString *HelloGameStr=@"HelloGame";
  if ([HelloGameStr isEqualToString:@"HelloGameStrShout"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Invite"];                  
      [array addObject:@"certain"];
       
      switch (indexCount) {
        case 0: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTogigglewhichradioMethodAction:indexCount];
         break;
        }        
        case 1: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTostorelayfoodMethodAction:indexCount];
          break;
        }        
        case 2: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTopumpkinthingsdangerMethodAction:indexCount];
         break;
        }        
        case 3: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeToparadoxwhomereMethodAction:indexCount];
         break;
        }        
        case 4: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        case 5: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HelloGameStr isEqualToString:@"HelloGameStrhorizon"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Wire"  forKey:@"Cloud"];                    
      [dictionary setObject:@"Village"  forKey:@"Neighbor"];
      
      switch (indexCount) {
        case 0: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTogigglewhichradioMethodAction:indexCount];
         break;
        }        
        case 1: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTostorelayfoodMethodAction:indexCount];
          break;
        }        
        case 2: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTopumpkinthingsdangerMethodAction:indexCount];
         break;
        }        
        case 3: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeToparadoxwhomereMethodAction:indexCount];
         break;
        }        
        case 4: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        case 5: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HelloGameStr isEqualToString:@"HelloGameStrquestions"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Invite"];                  
      [array addObject:@"certain"];
      
      switch (indexCount) {
        case 0: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTogigglewhichradioMethodAction:indexCount];
         break;
        }        
        case 1: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTostorelayfoodMethodAction:indexCount];
          break;
        }        
        case 2: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTopumpkinthingsdangerMethodAction:indexCount];
         break;
        }        
        case 3: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeToparadoxwhomereMethodAction:indexCount];
         break;
        }        
        case 4: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        case 5: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([HelloGameStr isEqualToString:@"HelloGameStrKnowHow"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Invite"];                  
      [array addObject:@"certain"];
      
      switch (indexCount) {
        case 0: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTogigglewhichradioMethodAction:indexCount];
         break;
        }        
        case 1: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTostorelayfoodMethodAction:indexCount];
          break;
        }        
        case 2: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTopumpkinthingsdangerMethodAction:indexCount];
         break;
        }        
        case 3: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeToparadoxwhomereMethodAction:indexCount];
         break;
        }        
        case 4: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        case 5: {
          MayEnterRichManTireViewController *MayEnterRichManTireVC = [[MayEnterRichManTireViewController alloc] init];
          [MayEnterRichManTireVC comeTosurmountpeekabooobjectMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTostaffpickpropertyMethodAction:(NSInteger )indexCount{

  NSString *MayEnterStr=@"MayEnter";
  if ([MayEnterStr isEqualToString:@"MayEnterStrHereinWas"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"altered"];                  
      [array addObject:@"Entertain"];
       
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTowaveriverbecomeMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MayEnterStr isEqualToString:@"MayEnterStrAppearance"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Opposite"  forKey:@"Sacrificed"];                    
      [dictionary setObject:@"money"  forKey:@"Prince"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTowaveriverbecomeMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MayEnterStr isEqualToString:@"MayEnterStrCorrect"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"altered"];                  
      [array addObject:@"Entertain"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTowaveriverbecomeMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MayEnterStr isEqualToString:@"MayEnterStrTrust"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"altered"];                  
      [array addObject:@"Entertain"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTowaveriverbecomeMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomemoryfantasticavoidMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToarrangemodelbananaMethodAction:(NSInteger )indexCount{

  NSString *SoulmateStr=@"Soulmate";
  if ([SoulmateStr isEqualToString:@"SoulmateStrnot"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"peekaboo"];                  
      [array addObject:@"Politics"];
       
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([SoulmateStr isEqualToString:@"SoulmateStrresult"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Know"  forKey:@"Customer"];                    
      [dictionary setObject:@"same"  forKey:@"Library"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([SoulmateStr isEqualToString:@"SoulmateStrEvil"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"peekaboo"];                  
      [array addObject:@"Politics"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([SoulmateStr isEqualToString:@"SoulmateStrwertain"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"peekaboo"];                  
      [array addObject:@"Politics"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTobarorderforMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTofinishopportunitydiscussionMethodAction:(NSInteger )indexCount{

  NSString *MentionedStr=@"Mentioned";
  if ([MentionedStr isEqualToString:@"MentionedStrDepth"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Mistake"];                  
      [array addObject:@"TheFruits"];
       
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MentionedStr isEqualToString:@"MentionedStrForth"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Process"  forKey:@"Weather"];                    
      [dictionary setObject:@"business"  forKey:@"Expression"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MentionedStr isEqualToString:@"MentionedStrbubble"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Mistake"];                  
      [array addObject:@"TheFruits"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([MentionedStr isEqualToString:@"MentionedStrException"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Mistake"];                  
      [array addObject:@"TheFruits"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTobasisanimalhitMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTomerethingsresultMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToprincebusinessequalMethodAction:(NSInteger )indexCount{

  NSString *YouToDoStr=@"YouToDo";
  if ([YouToDoStr isEqualToString:@"YouToDoStrBookOf"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Divide"];                  
      [array addObject:@"concern"];
       
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTowhorelationbrotherMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([YouToDoStr isEqualToString:@"YouToDoStrBird"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Profit"  forKey:@"Basketball"];                    
      [dictionary setObject:@"Sport"  forKey:@"ManList"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTowhorelationbrotherMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([YouToDoStr isEqualToString:@"YouToDoStrpassion"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Divide"];                  
      [array addObject:@"concern"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTowhorelationbrotherMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([YouToDoStr isEqualToString:@"YouToDoStrJump"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Divide"];                  
      [array addObject:@"concern"];
      
      switch (indexCount) {
        case 0: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTonorthpassionreadyMethodAction:indexCount];
         break;
        }        
        case 1: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTosortrespectdeathMethodAction:indexCount];
          break;
        }        
        case 2: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTowhorelationbrotherMethodAction:indexCount];
         break;
        }        
        case 3: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        case 4: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeTogiggleaquasandboxMethodAction:indexCount];
         break;
        }        
        case 5: {
          FreshBirthDeskViewController *FreshBirthDeskVC = [[FreshBirthDeskViewController alloc] init];
          [FreshBirthDeskVC comeToparkwearproductMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTocompareemployoriginMethodAction:(NSInteger )indexCount{

  NSString *GovernmentStr=@"Government";
  if ([GovernmentStr isEqualToString:@"GovernmentStrTheFruits"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Preserve"];                  
      [array addObject:@"Prefer"];
       
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([GovernmentStr isEqualToString:@"GovernmentStrTheFruits"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Blow"  forKey:@"Formal"];                    
      [dictionary setObject:@"Prince"  forKey:@"When"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([GovernmentStr isEqualToString:@"GovernmentStrJump"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Preserve"];                  
      [array addObject:@"Prefer"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([GovernmentStr isEqualToString:@"GovernmentStrblossom"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Preserve"];                  
      [array addObject:@"Prefer"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTocatchpopularthingsMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToexceptpoolcornerMethodAction:(NSInteger )indexCount{

  NSString *theyStr=@"they";
  if ([theyStr isEqualToString:@"theyStrProposal"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Variety"];                  
      [array addObject:@"Speech"];
       
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToprofessionrealizesizeMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([theyStr isEqualToString:@"theyStrconsider"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Wood"  forKey:@"renaissance"];                    
      [dictionary setObject:@"ArrivedAtRead"  forKey:@"Philosophies"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToprofessionrealizesizeMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([theyStr isEqualToString:@"theyStrsee"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Variety"];                  
      [array addObject:@"Speech"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToprofessionrealizesizeMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([theyStr isEqualToString:@"theyStrWeMust"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Variety"];                  
      [array addObject:@"Speech"];
      
      switch (indexCount) {
        case 0: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomultiplydefensebutterflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToextenddropeastMethodAction:indexCount];
          break;
        }        
        case 2: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTomurderhotdetailMethodAction:indexCount];
         break;
        }        
        case 3: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToprofessionrealizesizeMethodAction:indexCount];
         break;
        }        
        case 4: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeToquestionsbubblefinishMethodAction:indexCount];
         break;
        }        
        case 5: {
          MembershipComeToStruggleViewController *MembershipComeToStruggleVC = [[MembershipComeToStruggleViewController alloc] init];
          [MembershipComeToStruggleVC comeTochoosecoldproperMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)addLoaddistrictnoticewhoInfo:(NSInteger )typeNumber{

  NSString *KneeStr=@"Knee";
  if ([KneeStr isEqualToString:@"KneeStrRetire"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Invited"];                                  
      [array addObject:@"Itisan"];
       

      switch (typeNumber) {
        case 0: {
          [[ProduceBearDecideObject instance]  objpumpkinthingsdangerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ProduceBearDecideObject instance]  objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ProduceBearDecideObject instance]  objsuffercommandbananaInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ProduceBearDecideObject instance]  objtemperaturerelativedivisionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ProduceBearDecideObject instance]   objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ProduceBearDecideObject instance]   objpumpkinthingsdangerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([KneeStr isEqualToString:@"KneeStrBookAnd"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Sheet"  forKey:@"Victory"];                                    
      [dictionary setObject:@"Algebra"  forKey:@"Urge"];
      

      switch (typeNumber) {
        case 0: {
          [[ProduceBearDecideObject instance]  objpumpkinthingsdangerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ProduceBearDecideObject instance]  objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ProduceBearDecideObject instance]  objsuffercommandbananaInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ProduceBearDecideObject instance]  objtemperaturerelativedivisionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ProduceBearDecideObject instance]   objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ProduceBearDecideObject instance]   objpumpkinthingsdangerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([KneeStr isEqualToString:@"KneeStrenthusiasm"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Sheet"  forKey:@"Victory"];                                    
      [dictionary setObject:@"Algebra"  forKey:@"Urge"];
      

      switch (typeNumber) {
        case 0: {
          [[ProduceBearDecideObject instance]  objpumpkinthingsdangerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ProduceBearDecideObject instance]  objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ProduceBearDecideObject instance]  objsuffercommandbananaInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ProduceBearDecideObject instance]  objtemperaturerelativedivisionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ProduceBearDecideObject instance]   objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ProduceBearDecideObject instance]   objpumpkinthingsdangerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([KneeStr isEqualToString:@"KneeStrExperiment"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Invited"];                                  
      [array addObject:@"Itisan"];
      

      switch (typeNumber) {
        case 0: {
          [[ProduceBearDecideObject instance]  objpumpkinthingsdangerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ProduceBearDecideObject instance]  objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ProduceBearDecideObject instance]  objsuffercommandbananaInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ProduceBearDecideObject instance]  objtemperaturerelativedivisionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ProduceBearDecideObject instance]   objtimesedgesoulmateInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ProduceBearDecideObject instance]   objpumpkinthingsdangerInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadhandleemploythickInfo:(NSInteger )typeNumber{

  NSString *FromAllStr=@"FromAll";
  if ([FromAllStr isEqualToString:@"FromAllStrDisease"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"able"];                                  
      [array addObject:@"concern"];
       

      switch (typeNumber) {
        case 0: {
          [[TaxTalkNecessaryObject instance]  objneithersingletearmannerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TaxTalkNecessaryObject instance]  objgetpopulationcommitteeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TaxTalkNecessaryObject instance]  objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TaxTalkNecessaryObject instance]  objdelicacyadvancenorthInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TaxTalkNecessaryObject instance]   objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TaxTalkNecessaryObject instance]   objmurderwhilebeyondInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([FromAllStr isEqualToString:@"FromAllStrsome"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Adopt"  forKey:@"bubble"];                                    
      [dictionary setObject:@"WithHi"  forKey:@"DoExactly"];
      

      switch (typeNumber) {
        case 0: {
          [[TaxTalkNecessaryObject instance]  objneithersingletearmannerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TaxTalkNecessaryObject instance]  objgetpopulationcommitteeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TaxTalkNecessaryObject instance]  objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TaxTalkNecessaryObject instance]  objdelicacyadvancenorthInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TaxTalkNecessaryObject instance]   objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TaxTalkNecessaryObject instance]   objmurderwhilebeyondInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([FromAllStr isEqualToString:@"FromAllStrSnow"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Adopt"  forKey:@"bubble"];                                    
      [dictionary setObject:@"WithHi"  forKey:@"DoExactly"];
      

      switch (typeNumber) {
        case 0: {
          [[TaxTalkNecessaryObject instance]  objneithersingletearmannerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TaxTalkNecessaryObject instance]  objgetpopulationcommitteeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TaxTalkNecessaryObject instance]  objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TaxTalkNecessaryObject instance]  objdelicacyadvancenorthInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TaxTalkNecessaryObject instance]   objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TaxTalkNecessaryObject instance]   objmurderwhilebeyondInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([FromAllStr isEqualToString:@"FromAllStrIHave"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"able"];                                  
      [array addObject:@"concern"];
      

      switch (typeNumber) {
        case 0: {
          [[TaxTalkNecessaryObject instance]  objneithersingletearmannerInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[TaxTalkNecessaryObject instance]  objgetpopulationcommitteeInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[TaxTalkNecessaryObject instance]  objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[TaxTalkNecessaryObject instance]  objdelicacyadvancenorthInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[TaxTalkNecessaryObject instance]   objalteredloggedableInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[TaxTalkNecessaryObject instance]   objmurderwhilebeyondInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadinfluenceshipownershipInfo:(NSInteger )typeNumber{

  NSString *DepthStr=@"Depth";
  if ([DepthStr isEqualToString:@"DepthStrownership"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Smell"];                                  
      [array addObject:@"Birth"];
       

      switch (typeNumber) {
        case 0: {
          [[ActionExperienceAmountObject instance]  objproductseerelateInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ActionExperienceAmountObject instance]  objlanguagemurdersophisticatedInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ActionExperienceAmountObject instance]  objtheyfitcertainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ActionExperienceAmountObject instance]  objsufferpermitproductionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ActionExperienceAmountObject instance]   objblossomrealizecertainInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ActionExperienceAmountObject instance]   objsufferpermitproductionInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([DepthStr isEqualToString:@"DepthStrplainly"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Daughter"  forKey:@"GetIs"];                                    
      [dictionary setObject:@"Smell"  forKey:@"speak"];
      

      switch (typeNumber) {
        case 0: {
          [[ActionExperienceAmountObject instance]  objproductseerelateInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ActionExperienceAmountObject instance]  objlanguagemurdersophisticatedInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ActionExperienceAmountObject instance]  objtheyfitcertainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ActionExperienceAmountObject instance]  objsufferpermitproductionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ActionExperienceAmountObject instance]   objblossomrealizecertainInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ActionExperienceAmountObject instance]   objsufferpermitproductionInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([DepthStr isEqualToString:@"DepthStrable"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Daughter"  forKey:@"GetIs"];                                    
      [dictionary setObject:@"Smell"  forKey:@"speak"];
      

      switch (typeNumber) {
        case 0: {
          [[ActionExperienceAmountObject instance]  objproductseerelateInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ActionExperienceAmountObject instance]  objlanguagemurdersophisticatedInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ActionExperienceAmountObject instance]  objtheyfitcertainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ActionExperienceAmountObject instance]  objsufferpermitproductionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ActionExperienceAmountObject instance]   objblossomrealizecertainInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ActionExperienceAmountObject instance]   objsufferpermitproductionInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([DepthStr isEqualToString:@"DepthStrVillage"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Smell"];                                  
      [array addObject:@"Birth"];
      

      switch (typeNumber) {
        case 0: {
          [[ActionExperienceAmountObject instance]  objproductseerelateInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[ActionExperienceAmountObject instance]  objlanguagemurdersophisticatedInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[ActionExperienceAmountObject instance]  objtheyfitcertainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[ActionExperienceAmountObject instance]  objsufferpermitproductionInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[ActionExperienceAmountObject instance]   objblossomrealizecertainInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[ActionExperienceAmountObject instance]   objsufferpermitproductionInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoaddangerwealthytheyInfo:(NSInteger )typeNumber{

  NSString *onceStr=@"once";
  if ([onceStr isEqualToString:@"onceStrDouble"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"wealthy"];                                  
      [array addObject:@"Lord"];
       

      switch (typeNumber) {
        case 0: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[AlthoughBetterGirlObject instance]  objthanfoodoriginInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[AlthoughBetterGirlObject instance]  objsingletearfaithplainlyInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[AlthoughBetterGirlObject instance]   objrelationhospitalgiggleInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[AlthoughBetterGirlObject instance]   objtreethemrecommendInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([onceStr isEqualToString:@"onceStrWinter"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"hope"  forKey:@"Government"];                                    
      [dictionary setObject:@"Mentioned"  forKey:@"Under"];
      

      switch (typeNumber) {
        case 0: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[AlthoughBetterGirlObject instance]  objthanfoodoriginInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[AlthoughBetterGirlObject instance]  objsingletearfaithplainlyInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[AlthoughBetterGirlObject instance]   objrelationhospitalgiggleInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[AlthoughBetterGirlObject instance]   objtreethemrecommendInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([onceStr isEqualToString:@"onceStrWheel"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"hope"  forKey:@"Government"];                                    
      [dictionary setObject:@"Mentioned"  forKey:@"Under"];
      

      switch (typeNumber) {
        case 0: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[AlthoughBetterGirlObject instance]  objthanfoodoriginInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[AlthoughBetterGirlObject instance]  objsingletearfaithplainlyInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[AlthoughBetterGirlObject instance]   objrelationhospitalgiggleInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[AlthoughBetterGirlObject instance]   objtreethemrecommendInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([onceStr isEqualToString:@"onceStrFootball"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"wealthy"];                                  
      [array addObject:@"Lord"];
      

      switch (typeNumber) {
        case 0: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[AlthoughBetterGirlObject instance]  objthanfoodoriginInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[AlthoughBetterGirlObject instance]  objsingletearfaithplainlyInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[AlthoughBetterGirlObject instance]  objthingsedgeforeignInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[AlthoughBetterGirlObject instance]   objrelationhospitalgiggleInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[AlthoughBetterGirlObject instance]   objtreethemrecommendInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadlengthlossproductionInfo:(NSInteger )typeNumber{

  NSString *StruggleStr=@"Struggle";
  if ([StruggleStr isEqualToString:@"StruggleStrNobody"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Bird"];                                  
      [array addObject:@"Adopt"];
       

      switch (typeNumber) {
        case 0: {
          [[DanceSpendSpaceObject instance]  objdollarrelationenvironmentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DanceSpendSpaceObject instance]  objessentialskillballInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DanceSpendSpaceObject instance]  objfaithconcernconsciousInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DanceSpendSpaceObject instance]  objshapedegreehowInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DanceSpendSpaceObject instance]   objwideeventbeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DanceSpendSpaceObject instance]   objdollarrelationenvironmentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([StruggleStr isEqualToString:@"StruggleStrPlayer"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"get"  forKey:@"Proposal"];                                    
      [dictionary setObject:@"Variety"  forKey:@"AnyTime"];
      

      switch (typeNumber) {
        case 0: {
          [[DanceSpendSpaceObject instance]  objdollarrelationenvironmentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DanceSpendSpaceObject instance]  objessentialskillballInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DanceSpendSpaceObject instance]  objfaithconcernconsciousInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DanceSpendSpaceObject instance]  objshapedegreehowInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DanceSpendSpaceObject instance]   objwideeventbeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DanceSpendSpaceObject instance]   objdollarrelationenvironmentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([StruggleStr isEqualToString:@"StruggleStrTear"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"get"  forKey:@"Proposal"];                                    
      [dictionary setObject:@"Variety"  forKey:@"AnyTime"];
      

      switch (typeNumber) {
        case 0: {
          [[DanceSpendSpaceObject instance]  objdollarrelationenvironmentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DanceSpendSpaceObject instance]  objessentialskillballInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DanceSpendSpaceObject instance]  objfaithconcernconsciousInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DanceSpendSpaceObject instance]  objshapedegreehowInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DanceSpendSpaceObject instance]   objwideeventbeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DanceSpendSpaceObject instance]   objdollarrelationenvironmentInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([StruggleStr isEqualToString:@"StruggleStrcherish"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Bird"];                                  
      [array addObject:@"Adopt"];
      

      switch (typeNumber) {
        case 0: {
          [[DanceSpendSpaceObject instance]  objdollarrelationenvironmentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DanceSpendSpaceObject instance]  objessentialskillballInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DanceSpendSpaceObject instance]  objfaithconcernconsciousInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DanceSpendSpaceObject instance]  objshapedegreehowInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DanceSpendSpaceObject instance]   objwideeventbeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DanceSpendSpaceObject instance]   objdollarrelationenvironmentInfo:typeNumber];
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
  [self addLoaddangerwealthytheyInfo:typeNumber];
  
  [self addLoadlengthlossproductionInfo:typeNumber];
  
  [self addLoadhandleemploythickInfo:typeNumber];
  
  [self addLoaddistrictnoticewhoInfo:typeNumber];
  
  [self addLoadinfluenceshipownershipInfo:typeNumber];
 
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