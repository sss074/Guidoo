//
//  SWFTSView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWFTSView.h"
#import "SWFTSLanguageCell.h"
#import "SWPreferences.h"

@interface SWFTSView () <UITableViewDataSource,UITableViewDelegate>{
    NSArray* languages;
    UIImageView* logoView;
}
@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,strong)IBOutlet UISlider* distanceSlider;
@property (nonatomic,strong)IBOutlet UISlider* durationSlider;
@property (nonatomic,strong)IBOutlet UISlider* rangeSlider;
@property (nonatomic,strong)IBOutlet UISwitch* proffSwith;
@property (nonatomic,strong)IBOutlet UILabel* distanceLabel;
@property (nonatomic,strong)IBOutlet UILabel* durationLabel;
@property (nonatomic,strong)IBOutlet UILabel* priceLabel;
@property (nonatomic,strong)IBOutlet UIButton* skipBut;
@property (nonatomic,strong)IBOutlet UIButton* continueBut;

@end

@implementation SWFTSView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    logoView = [UIImageView new];

    _distanceLabel.text = [NSString stringWithFormat:@"km %ld",(long)_distanceSlider.value / 1000];
    _durationLabel.text = [NSString stringWithFormat:@"h %ld",(long)_durationSlider.value];
    _priceLabel.text = [NSString stringWithFormat:@"$ %ld",(long)_rangeSlider.value];
    

    UIImage *streachedMaxImage = [[UIImage imageNamed:@"9402"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *streachedMinImage = [[UIImage imageNamed:@"940"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [_durationSlider setMaximumTrackImage:streachedMaxImage forState:UIControlStateNormal];
    [_durationSlider setMinimumTrackImage:streachedMinImage forState:UIControlStateNormal];
    [_distanceSlider setMaximumTrackImage:streachedMaxImage forState:UIControlStateNormal];
    [_distanceSlider setMinimumTrackImage:streachedMinImage forState:UIControlStateNormal];
    [_rangeSlider setMaximumTrackImage:streachedMaxImage forState:UIControlStateNormal];
    [_rangeSlider setMinimumTrackImage:streachedMinImage forState:UIControlStateNormal];
    
    [[SWWebManager sharedManager]dictionaries:^(NSArray<SWLanguage *> *obj) {
        NSLog(@"%@",obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            languages = [NSArray arrayWithArray:obj];
           [_tableView reloadData];
        });
    }];

    
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return languages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FTSLanguageCell";
    
    SWFTSLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   

    cell.content = languages[indexPath.row];
    
    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWFTSLanguageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell.swith setSelected:!cell.swith.isSelected];
}
#pragma  mark - Action methods
- (IBAction)sliderValueChanged:(UISlider *)sender {
    UISlider* slider = (UISlider*)sender;
    NSLog(@"slider value = %f", sender.value);
    
    if([slider isEqual:_distanceSlider]){
        _distanceLabel.text = [NSString stringWithFormat:@"km %ld",(long)_distanceSlider.value / 1000];
    } else if([slider isEqual:_durationSlider]){
        _durationLabel.text = [NSString stringWithFormat:@"h %ld",(long)_durationSlider.value];
    } else if([slider isEqual:_rangeSlider]){
        _priceLabel.text = [NSString stringWithFormat:@"$ %ld",(long)_rangeSlider.value];
    }
}
- (IBAction)changeSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
    }
    
}
- (IBAction)clicked:(id)sender{
    
    TheApp;
    UIButton* button = (UIButton*)sender;
    
    NSMutableString* lg = [[NSMutableString alloc] init];
    NSMutableArray * IDs = [NSMutableArray new];
    NSString* param = nil;
    __block SWLogin *object = [self objectDataForKey:currentLoginKey];
    if(object != nil){
        if([button isEqual:_continueBut]){
            BOOL isLanguage = NO;
            for(int i = 0; i < languages.count; i++){
                SWFTSLanguageCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if(cell.swith.isSelected){
                    [lg appendString:[NSString stringWithFormat:@"&languageIds=%ld",((NSNumber*)cell.content.ID).integerValue]];
                    [IDs addObject:cell.content.ID];
                    isLanguage = YES;
                }
            }
            if(!isLanguage){
                [self showAlertMessage:@"You must select a language."];
                return;
            }
            param = [NSString stringWithFormat:@"userId=%ld&maxPricePerHour=1000&maxDistance=2000000000&maxTourDuration=24&isProfessional=false&sessionToken=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken,lg];
            //param = [NSString stringWithFormat:@"userId=%ld&maxPricePerHour=%f&maxDistance=%f&maxTourDuration=%f&isProfessional=%d&sessionToken=%@%@",((NSNumber*)object.userId).integerValue,_rangeSlider.value,_distanceSlider.value,_durationSlider.value,(int)_proffSwith.isOn,object.sessionToken,lg];
        } else {
            for(int i = 0; i < languages.count; i++){
                SWFTSLanguageCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [lg appendString:[NSString stringWithFormat:@"&languageIds=%ld",((NSNumber*)cell.content.ID).integerValue]];
                [IDs addObject:cell.content.ID];
            }
            param = [NSString stringWithFormat:@"userId=%ld&maxPricePerHour=1000&maxDistance=2000000000&maxTourDuration=24&isProfessional=false&sessionToken=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken,lg];
        }

        
        [[SWWebManager sharedManager]preferences:param success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                SWPreferences* obj = [SWPreferences new];
                obj.userId = object.userId;
                obj.maxPricePerHour = @(_rangeSlider.value);
                obj.maxDistance = @(_distanceSlider.value);
                obj.maxTourDuration =@(_durationSlider.value);
                obj.isProfessional = @(_proffSwith.isOn);
                obj.sessionToken = object.sessionToken;
                obj.languageIds = IDs;
                [self setObjectDataForKey:obj forKey:userPreferences];
                
                NSString* param = nil;
                NSDictionary* fbInfo = [self objectForKey:FacebookProfile];
                if(fbInfo != nil){
                    
                    [logoView sd_setImageWithURL:[NSURL URLWithString:fbInfo[@"profilePhotoURL"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if(image != nil){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setObjectDataForKey:image forKey:avatar];
                            });
                        }
                    }];
                    
                    NSString* str = fbInfo[@"name"];
                    NSArray* components = [str componentsSeparatedByString:@" "];
                    if(components.count == 1) {
                        param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&firstName=%@&lastName=%@&email=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken, components[0] ? components[0] : @"",@"",fbInfo[@"email"],lg];
                    } else if(components.count == 2) {
                        param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&firstName=%@&lastName=%@&email=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken, components[0] ? components[0] : @"", components[1] ? components[1] : @"",fbInfo[@"email"],lg];
                    }
                } else{
                    param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&firstName=%@&lastName=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken, object.firstName, object.lastName,lg];
                    //[self setObjectDataForKey:[UIImage imageNamed:@"empty-avatar"] forKey:avatar];
                }
                
                
                [[SWWebManager sharedManager] setProfileUser:param success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setObjectDataForKey:object forKey:userLoginInfo];
                        app.window.rootViewController = [self checkPresentForClassDescriptor:@"CompleteNavController"];
                    });
                }];
            });
        }];
    }

    
}

@end
