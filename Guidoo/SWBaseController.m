//
//  ViewController.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseController.h"

@interface SWBaseController (){

}

@end

@implementation SWBaseController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    self.navigationItem.title = @"";
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
   
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    

}
#pragma mark - Service methods


- (void)setupNavBtn:(NavBarType)type{
    
    UIButton *btn = nil;
    UIImage *btnImg  = nil;
    UIBarButtonItem *barBtnItem = nil;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    switch (type) {
        case BASETYPE:{
            btnImg = [UIImage imageNamed:@"map"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnMapPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
            
            btnImg = [UIImage imageNamed:@"config"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnFilterPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barBtnItem;
        }
            break;
        case FILTERTYPE:{
            btnImg = [UIImage imageNamed:@"config"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnFilterPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barBtnItem;
        }
            break;
        case MAPTYPE:{
            btnImg = [UIImage imageNamed:@"map"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnMapPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
            break;
        case BACKTYPE: {
            btnImg = [UIImage imageNamed:@"icBack"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
            
        }
             break;
        case CHOSETYPE:{
            btnImg = [UIImage imageNamed:@"icBack"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
            
            btnImg = [UIImage imageNamed:@"save_profile"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnApplyPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barBtnItem;
        }
            break;
            
        case MARKTYPE: {
            btnImg = [UIImage imageNamed:@"icBack"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
            
            btnImg = [UIImage imageNamed:@"share"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSharePressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* barBtnItemShare = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
            btnImg = [UIImage imageNamed:@"pin6"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tintColor = [UIColor whiteColor];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSavedPressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barBtnItemSaved = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
            
            self.navigationItem.rightBarButtonItems = @[barBtnItemSaved,barBtnItemShare];
        }
            break;
            
        case MARKSAVEDTYPE: {
            btnImg = [UIImage imageNamed:@"icBack"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
            barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.leftBarButtonItem = barBtnItem;
            
            btnImg = [UIImage imageNamed:@"share"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSharePressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* barBtnItemShare = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
            btnImg = [UIImage imageNamed:@"pin6"];
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tintColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5];
            btn.frame = CGRectMake(0.f, 0.f, btnImg.size.width, btnImg.size.height);
            [btn setImage:btnImg forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnSavedPressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barBtnItemSaved = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
            
            self.navigationItem.rightBarButtonItems = @[barBtnItemSaved,barBtnItemShare];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Service methods
- (void)simpleTitle:(NSString*)title{
    
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    
    CGRect rect = self.navigationController.navigationBar.frame;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f,rect.size.width, rect.size.height)];
    _titleLabel.font =  [UIFont fontWithName:OPENSANS size:18.f];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:_titleLabel];
    _titleLabel.text = title;
    
    
}

#pragma mark - Action methods

- (void)btnMapPressed{

}
- (void)btnFilterPressed{
    
}
- (void)btnBackPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnMorePressed{

}

- (void)btnApplyPressed{
    
}
- (void)btnSharePressed{
    
}
- (void)btnSavedPressed{
    
}

@end
