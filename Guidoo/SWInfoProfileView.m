//
//  SWInfoProfileView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWInfoProfileView.h"
#import "SWPreferences.h"
#import "SWProfileController.h"
#import "SWInfoProfileController.h"

@interface SWInfoProfileView () <UITableViewDataSource,UITableViewDelegate>{
    NSArray* content;
    NSArray* languages;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,weak) IBOutlet UIImageView *logoView;
@property (nonatomic,strong)IBOutlet UILabel* nameLabel;
@property (nonatomic,strong)IBOutlet UILabel* cityLabel;
@property (nonatomic,strong)IBOutlet UIButton* editBut;
@end


@implementation SWInfoProfileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    content = @[@"Languages",@"Verified personal data",@"Guidoo experience"];
    
    [_tableView setTableFooterView:[UIView new]];
    
    [[SWWebManager sharedManager]dictionaries:^(NSArray<SWLanguage *> *obj) {
        NSLog(@"%@",obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            languages = [NSArray arrayWithArray:obj];
            [_tableView reloadData];
        });
    }];
    
    SWProfile* profile = [self objectDataForKey:profileInfo];
    if(profile != nil){
        [_logoView setImage:[self objectDataForKey:avatar]];
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        _cityLabel.text = [self isParamValid:profile.countryId] ? [NSString stringWithFormat:@"%ld",((NSNumber*)profile.countryId).integerValue] : nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"updateProfile" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateProfile" object:nil];
}
#pragma mark -  NSNotification

- (void)updateProfile:(NSNotification*)notify{
    SWProfile* profile = [self objectDataForKey:profileInfo];
    if(profile != nil){
        [_logoView setImage:[self objectDataForKey:avatar]];
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        _cityLabel.text = [self isParamValid:profile.countryId] ? [NSString stringWithFormat:@"%ld",((NSNumber*)profile.countryId).integerValue] : nil;
    }
    [_tableView reloadData];
}
#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.textLabel.text = content[indexPath.row];
    cell.detailTextLabel.text = nil;
    if(indexPath.row == 0){
        SWProfile *objPref = [self objectDataForKey:profileInfo];
        if(objPref != nil && languages != nil){
            NSMutableString* lg = [[NSMutableString alloc] init];
            for(NSNumber* pref in objPref.languageIds){
                for( int i = 0 ; i < languages.count; i++){
                    SWLanguage* lang = languages[i];
                    if(((NSNumber*)lang.ID).integerValue == pref.integerValue){
                        [lg appendString:[NSString stringWithFormat:@"%@,",lang.name]];
                        break;
                    }
                }
            }
            if(lg.length > 0)
                cell.detailTextLabel.text = [lg substringToIndex:lg.length - 1];
        }
        
    } else if(indexPath.row == 1){
        NSDictionary* currentFacebookProfile = [self objectForKey:FacebookProfile];
        if(currentFacebookProfile != nil)
            cell.detailTextLabel.text = @"Facebook account";
        else
            cell.detailTextLabel.text = @"Phone account";
    }
    
    
    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{
    
    TheApp;
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_editBut]){
        UINavigationController* navcontroller = [((SWTabbarController*)app.window.rootViewController) selectedViewController];
        SWInfoProfileController* profController = (SWInfoProfileController*)[navcontroller.viewControllers lastObject];
        UINavigationController* controller = [self checkPresentForClassDescriptor:@"EditProfileNavController"];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [profController presentViewController:controller animated:YES completion:nil];
    }
}

@end
