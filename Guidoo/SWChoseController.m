//
//  SWChoseController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 12.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChoseController.h"
#import "SWChoseView.h"

@interface SWChoseController ()

@property (nonatomic,strong)IBOutlet SWChoseView* choseView;

@end

@implementation SWChoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _choseView.content = _content;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setupNavBtn:CHOSETYPE];
    [self simpleTitle:_titleStr];
    
}
- (void)btnBackPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnApplyPressed{
  
    BOOL key = NO;
    
    for(id obj in _choseView.result){
        if(![obj isEqual:[NSNull null]]){
            key = YES;
            break;
        }
    }
    if(!key){
        UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:@"You must select at least one value" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChose" object:_choseView.result];
        [self btnBackPressed];
    }
}
@end
