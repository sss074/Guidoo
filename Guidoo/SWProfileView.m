//
//  SWProfileView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWProfileView.h"
#import "SWInfoProfileController.h"
#import "SWEditProfileController.h"

@interface SWProfileView ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray* content;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,weak) IBOutlet UIImageView *logoView;
@property (nonatomic,strong)IBOutlet UILabel* nameLabel;
@property (nonatomic,strong)IBOutlet UIButton* continueBut;
@end

@implementation SWProfileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    content = @[@{@"image":@"creditCard",
                  @"title":@"Payment methods"},
                  @{@"image":@"settings",
                  @"title":@"Settings"},
                  @{@"image":@"become",
                  @"title":@"Become a guide"},
                  @{@"image":@"follow",
                  @"title":@"Invite friends"},
                  @{@"image":@"help",
                  @"title":@"Help & support"},
                  @{@"image":@"envelopeOpen",
                  @"title":@"Feedback"},
                  @{@"image":@"logout",
                  @"title":@"Logout"}
                ];
    
    [_tableView setTableFooterView:[UIView new]];
    
    SWProfile* profile = [self objectDataForKey:profileInfo];
    if(profile != nil){
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        [_logoView setImage:[self objectDataForKey:avatar]];
    }
    UIImage* image = [self objectDataForKey:avatar];
    if(image == nil)
        [_logoView setImage:[UIImage imageNamed:@"empty-avatar"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"updateProfile" object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateProfile" object:nil];
}
#pragma mark -  NSNotification

- (void)updateProfile:(NSNotification*)notify{
    SWProfile* profile = [self objectDataForKey:profileInfo];
    if(profile != nil){
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        [_logoView setImage:[self objectDataForKey:avatar]];
    }
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   
    NSDictionary* dict = (NSDictionary*)content[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:dict[@"image"]]];
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:17.f];
    
    
    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == content.count - 1){
        UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to sign out of the account?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self logOut];
        }];
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOK];
        [alert addAction:actionCancel];

        TheApp;
        [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
  
    }
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{
    
    TheApp;
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_continueBut]){
        /*SWEditProfileController* controller = [self checkPresentForClassDescriptor:@"EditProfileNavController"];
        UINavigationController* navcontroller = [((SWTabbarController*)app.window.rootViewController) selectedViewController];
        controller.hidesBottomBarWhenPushed = YES;
        [navcontroller pushViewController:controller animated:YES];*/
        UINavigationController* navcontroller = [((SWTabbarController*)app.window.rootViewController) selectedViewController];
        SWInfoProfileController* profController = (SWInfoProfileController*)[navcontroller.viewControllers lastObject];
        UINavigationController* controller = [self checkPresentForClassDescriptor:@"EditProfileNavController"];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [profController presentViewController:controller animated:YES completion:nil];
    }
}

@end
