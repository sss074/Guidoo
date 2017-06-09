//
//  SWEditProfileView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWEditProfileView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TRCustomPickerView.h"
#import "TRCustomDatePicker.h"
#import "SWInfoProfileController.h"
#import "SWEditProfileCell.h"


@interface SWEditProfileView ()<TRCustomDatePickerDelegate, TRCustomPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>{
    NSArray* content;
    UIImagePickerController * picker;
    SWProfile* profile;
    UITextField* activeTextField;
    UITextField* emailField;
    UITextField* phoneField;
    NSArray* languages;
    
    TRCustomPickerView* genderPicker;
    TRCustomPickerView* locationPicker;
    TRCustomDatePicker* datePicker;
    UIImage* curImage;
    BOOL isMorelanguages;
}

@property (nonatomic,strong)IBOutlet UIView* languageView;
@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,weak) IBOutlet UIImageView *logoView;
@property (nonatomic,weak) IBOutlet UIImageView *emptyView;
@property (nonatomic,strong)IBOutlet UILabel* nameLabel;
@property (nonatomic,strong)IBOutlet UIButton* saveBut;
@property (nonatomic,strong)IBOutlet UIButton* changeBut;
@property (nonatomic,strong)IBOutlet UIView* headerView;
@property (nonatomic,strong)IBOutlet UIView* footerView;
@property (nonatomic,strong)IBOutlet UIView* nameView;
@property (nonatomic,strong)IBOutlet UIButton* changeNameBut;
@property (nonatomic,strong)IBOutlet UITextField* firstField;
@property (nonatomic,strong)IBOutlet UITextField* lastField;
@property (nonatomic,strong)IBOutlet UISwitch* enSwith;
@property (nonatomic,strong)IBOutlet UISwitch* spSwith;
@property (nonatomic,strong)IBOutlet UISwitch* frSwith;
@property (nonatomic,strong)IBOutlet UIButton* lcancelBut;
@property (nonatomic,strong)IBOutlet UIButton* lapplyBut;
@property (nonatomic,strong)IBOutlet UIButton* deleteBut;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* nameLabelW;
@property (nonatomic,strong)IBOutlet UISwitch* notifySwitch;
@end


@implementation SWEditProfileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[SWWebManager sharedManager]dictionaries:^(NSArray<SWLanguage *> *obj) {
        NSLog(@"%@",obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            languages = [NSArray arrayWithArray:obj];
            [_tableView reloadData];
        });
    }];
    
    isMorelanguages = NO;
   
    [_languageView setHidden:YES];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectZero];
    emailField.textColor = [UIColor blackColor];
    emailField.placeholder = @"E-MAIL";
    emailField.delegate = self;
    emailField.font = [UIFont fontWithName:@"OpenSans" size:14.f];
    emailField.returnKeyType = UIReturnKeyDone;
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [emailField setTextAlignment:NSTextAlignmentLeft];
    emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [emailField setFrame:CGRectMake(20.f, 3, CGRectGetWidth(_tableView.frame) - 40.f, 40.f)];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectZero];
    phoneField.textColor = [UIColor blackColor];
    phoneField.placeholder = @"Phone number";
    phoneField.delegate = self;
    phoneField.font = [UIFont fontWithName:@"OpenSans" size:14.f];
    phoneField.returnKeyType = UIReturnKeyDone;
    phoneField.autocorrectionType = UITextAutocorrectionTypeNo;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneField setTextAlignment:NSTextAlignmentLeft];
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneField setFrame:CGRectMake(20.f, 3, CGRectGetWidth(_tableView.frame) - 40.f, 40.f)];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    numberToolbar.barTintColor = [UIColor colorWithRed:239.f/255.f green:243.f/255.f blue:245.f/255.f alpha:1.f];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barItem.tintColor = [UIColor blackColor];
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barItem,
                           nil];
    [numberToolbar sizeToFit];
    phoneField.inputAccessoryView = numberToolbar;
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    content = @[@{@"section":@"Personal information",
                  @"rows":@[@{@"image":@"friends",
                              @"title":@"Gender"},
                            @{@"image":@"calendar3",
                                @"title":@"Date of birth"},
                            @{@"image":@"envelope_prof",
                                @"title":@"Email"},
                            @{@"image":@"callOut",
                              @"title":@"Phone"}]},
                @{@"section":@"Important information",
                  @"rows":@[@{@"image":@"pointer3",
                      @"title":@"Location"},
                    @{@"image":@"globe1",
                      @"title":@"Languages"}]}
                ];

    
    [_tableView setTableFooterView:[UIView new]];
    
    profile.notifyState = @(YES);
    [_notifySwitch setOn:YES];
    
    profile = [self objectDataForKey:profileInfo];
    if(profile != nil){
       
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
        CGSize size = [self sizeWithText:_nameLabel.text width:CGRectGetWidth(self.frame) - 120.f font:_nameLabel.font];
        _nameLabelW.constant = size.width;
        _firstField.text = [self isParamValid:profile.firstName] ? profile.firstName : nil;
        _lastField.text = [self isParamValid:profile.lastName] ? profile.lastName : nil;
        emailField.text = [self isParamValid:profile.email] ? profile.email : nil;
        phoneField.text = [self isParamValid:profile.phoneNumber] ? profile.phoneNumber : nil;
        
        if([self isParamValid:profile.birthday]){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-mm-dd"];
            NSDate *date = [formatter dateFromString:profile.birthday];
            profile.birthdayStr = [NSDateFormatter localizedStringFromDate:date
                                                                 dateStyle:NSDateFormatterMediumStyle
                                                                 timeStyle:NSDateFormatterNoStyle];
        }
        
        if([self isParamValid:profile.languageIds]){
            isMorelanguages = (BOOL)(profile.languageIds.count > 3);
        }
        if([self isParamValid:profile.notifyState]){
            [_notifySwitch setOn:profile.notifyState.boolValue];
        }
        
    }
    [_emptyView setHidden:[self objectDataForKey:avatar] != nil ? YES : NO];
    [_logoView setHidden:[self objectDataForKey:avatar] != nil ? NO : YES];
    if([self objectDataForKey:avatar] != nil){
        curImage = [self objectDataForKey:avatar];
        [_logoView setImage:curImage];
    }
    

   
    
    CGRect fr = _headerView.frame;
    
    if(!_changeNameBut.isSelected)
        fr.size.height = 242.f;
    else
        fr.size.height = 410.f;
    
    _headerView.frame = fr;
    [_tableView setTableHeaderView:nil];
    [_tableView setTableHeaderView:_headerView];
    [_headerView updateConstraintsIfNeeded];
    [_nameView setHidden:!_changeNameBut.isSelected];
    
    [_tableView setTableFooterView:nil];
    [_tableView setTableFooterView:_footerView];
    [_footerView updateConstraintsIfNeeded];
    
    
    
    genderPicker = [[TRCustomPickerView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    genderPicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    genderPicker.customPickerViewDelegate = self;
    genderPicker.content = @[@[@"Male",@"Female"]];
    
    
    locationPicker = [[TRCustomPickerView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    locationPicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    locationPicker.customPickerViewDelegate = self;
    locationPicker.content = @[@[@"Israel",@"Ukraine"]];
   
    NSArray* countries = [self objectDataForKey:@"countries"];
    if([self isParamValid:countries]){
         NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:countries.count];
        for(int i = 0; i < countries.count; i++){
            SWCountries* obj = countries[i];
            [temp addObject:obj.name];
        }
        locationPicker.content = @[[NSArray arrayWithArray:temp]];
    }
    
    
    datePicker = [[TRCustomDatePicker alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    datePicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    datePicker.customDatePickerDelegate = self;
    
    _changeNameBut.tintColor = [UIColor whiteColor];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChose:) name:@"updateChose" object:nil];
    
    [_tableView reloadData];

}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateChose" object:nil];
    
    if(genderPicker.isShow)
        [genderPicker hide];
    
    if(locationPicker.isShow)
        [locationPicker hide];
    
    if(datePicker.isShow)
        [datePicker hide];

}
#pragma mark -  NSNotification

- (void)updateChose:(NSNotification*)notify{
   
    NSArray* result = notify.object;
    
    NSMutableArray* temp = [NSMutableArray new];
    SWLanguage* lang = nil;
    
    for(int i = 0; i < result.count; i++){
        if(![result[i] isEqual:[NSNull null]]){
            lang = languages[i];
            [temp addObject:lang.ID];
        }
    }
    profile.languageIds = [NSArray arrayWithArray:temp];
     isMorelanguages = (BOOL)(profile.languageIds.count > 3);
    [_tableView reloadData];
}
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info          = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0,0, kbSize.height + 100, 0);
    _tableView.contentInset          = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    [self scrollToActiveTextField:kbSize];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    _tableView.contentInset          = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)scrollToActiveTextField:(CGSize)kbSize{
    
    if (activeTextField){
        CGRect aRect = self.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y-kbSize.height);
            [_tableView setContentOffset:scrollPoint animated:YES];
        }
    }
}

#pragma  mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary* dict = content[section];
    NSArray* rows = dict[@"rows"];
    return rows.count;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary* dict = content[section];
    return dict[@"section"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EditProfileCell";
    
    SWEditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary* dict = content[indexPath.section];
    NSArray* rows = dict[@"rows"];
    NSDictionary* param = rows[indexPath.row];
    cell.content = param;
    switch (indexPath.section) {
        case 0:{
            if(indexPath.row == 0){
                cell.detail.text = [self isParamValid:profile.gender] ? profile.gender : nil;
            } else if(indexPath.row == 1){
                cell.detail.text = [self isParamValid:profile.birthdayStr] ? profile.birthdayStr : nil;
            } else if(indexPath.row == 2){
                cell.detail.text = [self isParamValid:profile.email] ? profile.email : nil;
            } else if(indexPath.row == 3){
                cell.detail.text = [self isParamValid:profile.phoneNumber] ? profile.phoneNumber : nil;
            }
        }
            
            break;
        case 1:{
            if(indexPath.row == 0){
                cell.detail.text = [self isParamValid:profile.countryId] ? ((NSNumber*)profile.countryId).integerValue == 0 ? @"Israel" : @"Ukraine" : nil;
            } else if(indexPath.row == 1){

                if(languages != nil && profile.languageIds != nil){
                    NSMutableString* lg = [[NSMutableString alloc] init];
                    for(NSNumber* pref in profile.languageIds){
                        for( int i = 0 ; i < languages.count; i++){
                            SWLanguage* lang = languages[i];
                            if(((NSNumber*)lang.ID).integerValue == pref.integerValue){
                                [lg appendString:[NSString stringWithFormat:@"%@,",lang.name]];
                                break;
                            }
                        }
                    }
                    if(lg.length > 0)
                        cell.detail.text = [lg substringToIndex:lg.length - 1];
                }
            }
        }
            
            break;
            
        default:
            break;
    }

    
    
    return cell;
}
#pragma  mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1 && indexPath.row == 1){
        if(isMorelanguages)
            return 100.f;
    }
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            genderPicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                key_pickerFontSizeNSNumber : @(14.f),
                                key_pickerContentTextColorUIColor : [UIColor blackColor],
                                key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                key_isToolBarExistNSNumber : @(YES),
                                key_doneBtnTitleNSString : @"Done",
                                key_cancelBtnTitleNSString : @"Cancel",
                                key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                key_toolBarTitleNSString : @"Select you gender",
                                key_pickerSelectedRowsNSArray : @[@(0)]};
            
            
            if(!genderPicker.isShow){
                if(genderPicker.isShow && genderPicker.isCompleted){
                    [genderPicker hide];
                } else if(!genderPicker.isShow && genderPicker.isCompleted){
                    [genderPicker show];
                }
            }

        } else if (indexPath.row == 1){
            datePicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                    key_pickerFontSizeNSNumber : @(14.f),
                                    key_pickerContentTextColorUIColor : [UIColor blackColor],
                                    key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                    key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                    key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                    key_isToolBarExistNSNumber : @(YES),
                                    key_doneBtnTitleNSString : @"Done",
                                    key_cancelBtnTitleNSString : @"Cancel",
                                    key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                    key_toolBarTitleNSString : @"Select birth date",
                                    key_toolBarTitleColorUIColor:[UIColor whiteColor],
                                    key_pickerSelectedRowsNSArray : @[@(0)]};
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            
            if(!datePicker.isShow){
                if(datePicker.isShow && datePicker.isCompleted){
                    [datePicker hide];
                } else if(!datePicker.isShow && datePicker.isCompleted){
                    [datePicker show];
                }
            }

            
        } else if(indexPath.row == 2){
            SWEditProfileCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            [cell.contentView addSubview:emailField];
            [cell.title setHidden:YES];
            [cell.detail setHidden:YES];
            [cell.imgView setHidden:YES];
            [emailField becomeFirstResponder];
        } else if(indexPath.row == 3){
            SWEditProfileCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            [cell.contentView addSubview:phoneField];
            [cell.title setHidden:YES];
            [cell.detail setHidden:YES];
            [cell.imgView setHidden:YES];
            [phoneField becomeFirstResponder];
        }
    } else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            /*if([_delegate respondsToSelector:@selector(chosePress:withContent:title:)]){
                [_delegate chosePress:self withContent:@[@"Israel",@"Ukraine"] title:@"Location"];
            }*/
            locationPicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                    key_pickerFontSizeNSNumber : @(14.f),
                                    key_pickerContentTextColorUIColor : [UIColor blackColor],
                                    key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                    key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                    key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                    key_isToolBarExistNSNumber : @(YES),
                                    key_doneBtnTitleNSString : @"Done",
                                    key_cancelBtnTitleNSString : @"Cancel",
                                    key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                    key_toolBarTitleNSString : @"Select you location",
                                    key_pickerSelectedRowsNSArray : @[@(0)]};
            
            
            if(!locationPicker.isShow){
                if(locationPicker.isShow && locationPicker.isCompleted){
                    [locationPicker hide];
                } else if(!locationPicker.isShow && locationPicker.isCompleted){
                    [locationPicker show];
                }
            }
            
        } else if(indexPath.row == 1){
            if([_delegate respondsToSelector:@selector(chosePress:withContent:title:)]){
                
                NSMutableArray* temp = [NSMutableArray new];
                SWLanguage* lang = nil;
                
                for(int i = 0; i < languages.count; i++){
                    lang = languages[i];
                    [temp addObject:@{@"title":lang.name,
                                      @"isCheck": @(NO)
                                      }];
                }
              
                [_delegate chosePress:self withContent:[NSArray arrayWithArray:temp] title:@"Languages"];
            }
        }
    }
}
#pragma  mark - Action methods
- (void)doneWithNumberPad{
    [activeTextField resignFirstResponder];
    activeTextField = nil;
    SWEditProfileCell* cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    profile.phoneNumber = [phoneField.text isEqualToString:@""] ? nil :[NSString stringWithFormat:@"+%@",[phoneField.text lowercaseString]];
    cell.detail.text = profile.phoneNumber;
    [phoneField removeFromSuperview];
    [cell.title setHidden:NO];
    [cell.detail setHidden:NO];
    [cell.imgView setHidden:NO];
    [_tableView reloadData];
}
- (IBAction)clicked:(id)sender{
   
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_changeBut]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* actionCreate = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self photoPressed:UIImagePickerControllerSourceTypeCamera];
                                                             }];
        UIAlertAction* actionAdd = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self photoPressed:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                                          }];
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCreate];
        [alert addAction:actionAdd];
        [alert addAction:actionCancel];

        [[self checkPresentForClassDescriptor:@"EditProfileNavController"] presentViewController:alert animated:YES completion:nil];
        
    } else if([button isEqual:_saveBut]){
        
        [activeTextField resignFirstResponder];

        if([self validateContent]){
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                NSMutableString* lg = [[NSMutableString alloc] init];
                for(int i = 0; i < profile.languageIds.count; i++){
                    NSNumber* index = profile.languageIds[i];
                    [lg appendString:[NSString stringWithFormat:@"&languageIds=%ld",index.integerValue]];
                }
                NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&firstName=%@&lastName=%@%@",((NSNumber*)object.userId).integerValue,object.sessionToken, profile.firstName,profile.lastName,lg];
                if([self isParamValid:profile.email])
                    param = [NSString stringWithFormat:@"%@&email=%@",param,profile.email];
                if([self isParamValid:profile.gender])
                    param = [NSString stringWithFormat:@"%@&gender=%@",param,profile.gender];
                if([self isParamValid:profile.birthday])
                    param = [NSString stringWithFormat:@"%@&birthday=%@",param,profile.birthday];
                if([self isParamValid:profile.countryId])
                    param = [NSString stringWithFormat:@"%@&countryId=%ld",param,((NSNumber*)profile.countryId).integerValue];
                if([self isParamValid:profile.notifyState])
                    param = [NSString stringWithFormat:@"%@&receiveNotifications=%@",param,((NSNumber*)profile.notifyState).boolValue ? @"true" : @"false"];

        
                [self setObjectDataForKey:profile forKey:profileInfo];
                [self setObjectDataForKey:curImage forKey:avatar];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateProfile" object:nil];
                
                [self showIndecator:YES];
                [[SWWebManager sharedManager] setProfileUser:param success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showIndecator:NO];
                       // NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                       /* [[SWWebManager sharedManager]profileUser:param success:^(SWProfile * obj) {
                            [self setObjectDataForKey:obj forKey:profileInfo];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setObjectDataForKey:curImage forKey:avatar];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateProfile" object:nil];

                            });
                        }];*/
                        
                    });
                }];
            }
        }
    } else if([button isEqual:_changeNameBut]){
        
        _changeNameBut.selected = !_changeNameBut.isSelected;

        
        CGRect fr = _headerView.frame;
       
        if(!_changeNameBut.isSelected){
            fr.size.height = 242.f;
            profile.firstName = [_firstField.text isEqualToString:@""] ? nil : _firstField.text;
            profile.lastName = [_lastField.text isEqualToString:@""] ? nil : _lastField.text;
            _nameLabel.text = [NSString stringWithFormat:@"%@ %@",profile.firstName,profile.lastName];
            CGSize size = [self sizeWithText:_nameLabel.text width:CGRectGetWidth(self.frame) - 120.f font:_nameLabel.font];
            _nameLabelW.constant = size.width;
        } else {
            fr.size.height = 410.f;
        }
        
        _headerView.frame = fr;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableHeaderView:_headerView];
        [_headerView updateConstraintsIfNeeded];
        [_nameView setHidden:!_changeNameBut.isSelected];
    } else if([button isEqual:_lcancelBut]){
        
        
        //[_languageView setHidden:YES];
    } else if([button isEqual:_lapplyBut]){
        NSMutableArray* temp = [NSMutableArray new];
        SWLanguage* lang = nil;

        if(_enSwith.isOn){
            lang = languages[0];
            [temp addObject:lang.ID];
        }
        if(_spSwith.isOn){
            lang = languages[1];
            [temp addObject:lang.ID];
        }
        if(_frSwith.isOn){
            lang = languages[2];
            [temp addObject:lang.ID];
        }
        profile.languageIds = [NSArray arrayWithArray:temp];
 
        
        [_tableView reloadData];
    } else if([button isEqual:_deleteBut]){
        UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete of the profile?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                [[SWWebManager sharedManager] removeProfileUser:param success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self logOut];
                    });
                }];
            }
            
        }];
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOK];
        [alert addAction:actionCancel];
        
        [[self checkPresentForClassDescriptor:@"EditProfileNavController"] presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)changeSwitch:(id)sender{

    UISwitch* obj = (UISwitch*)sender;
    
    if([obj isEqual:_notifySwitch]){
        profile.notifyState = @(_notifySwitch.isOn);
    }
   // if(!_spSwith.isOn && !_frSwith.isOn && !_enSwith.isOn)
      //  [_enSwith setOn:YES];
    
    
    
 
}
#pragma mark - UIImagePickerController Delegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)_picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (![type isEqualToString:(NSString *)kUTTypeVideo] && ![type isEqualToString:(NSString *)kUTTypeMovie]){
        
        curImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_logoView setImage:curImage];
            [_emptyView setHidden:YES];
            [_logoView setHidden: NO];

        });
        
    }
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma mark - Sewrvice methods
- (BOOL)validateContent{
  
    BOOL check = YES;
    NSString* message = nil;
    
    if([self isParamValid:profile.email]){
        if(![self validateEmail:profile.email]){
            message =  @"Incorrect email address";
            check = NO;
        }
    }
    if(![self isParamValid:profile.firstName]){
        message =  @"IIncorrect firstName";
        check = NO;
    }
    if(![self isParamValid:profile.lastName]){
        message =  @"Incorrect lastName";
        check = NO;
    }
   
    
    if(!check){
        UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOK];
        [[self checkPresentForClassDescriptor:@"EditProfileNavController"]  presentViewController:alert animated:YES completion:nil];
    }
    
    return  check;
}
- (void)photoPressed:(UIImagePickerControllerSourceType)_typePicker {
    
    picker.delegate = self;
    picker.sourceType = _typePicker;
    picker.mediaTypes = @[@"public.image"];
    
    [[self checkPresentForClassDescriptor:@"EditProfileNavController"] presentViewController:picker animated:YES completion:nil];
    
    
}
#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)__textField{
    
    activeTextField = __textField;
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        profile.firstName = nil;
        profile.lastName = nil;
        profile.email = nil;
    });
    return  YES;
}
- (BOOL)textField:(UITextField *) __textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    
    NSArray *currents = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currents firstObject];
    if ([[current primaryLanguage] isEqualToString:@"emoji"] ) {
        return NO;
    }
    
    BOOL returnKey = YES;
    NSCharacterSet *nameCharSet = [NSCharacterSet characterSetWithCharactersInString:charSet];
    if([__textField isEqual:emailField]){
        nameCharSet = [NSCharacterSet characterSetWithCharactersInString:emailCharTemplate];
    } else if([__textField isEqual:phoneField]){
        nameCharSet = [NSCharacterSet characterSetWithCharactersInString:phonecharSet];
    } else
    for (int i = 0; i < [string length]; i++){
        unichar c = [string characterAtIndex:i];
        if ([nameCharSet characterIsMember:c]){
            return NO;
        }
    }
    
    NSUInteger oldLength = [__textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });
    
    returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 30 || returnKey;
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];
    
    if([activeTextField isEqual:emailField]){
        SWEditProfileCell* cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        profile.email = [emailField.text isEqualToString:@""] ? nil : [emailField.text lowercaseString];
        cell.detail.text = profile.email;
        [emailField removeFromSuperview];
        [cell.title setHidden:NO];
        [cell.detail setHidden:NO];
        [cell.imgView setHidden:NO];
        [_tableView reloadData];
    }
    activeTextField = nil;
    
    return  YES;
}
#pragma mark - TRCustomDatePickerDelegate delegate methods

-(void) cancelCustomDatePicker:(TRCustomDatePicker*)customDatePicker{
    
}
-(void) inCustomDatePicker:(TRCustomDatePicker*) customDatePicker selectedDateDictionary:(NSDictionary*)selectedDateDict{
    
    
    NSDate* curDate = (NSDate*)selectedDateDict[@"selectedDateNSDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    profile.birthday = [formatter stringFromDate:curDate];
    profile.birthdayStr = [NSDateFormatter localizedStringFromDate:curDate
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    [_tableView reloadData];
}

#pragma mark - TRCustomPickerViewDelegate delegate methods

-(void) cancelCustomPickerView:(TRCustomPickerView*)customPickerView{
   
}
-(void) inCustomPickerView:(TRCustomPickerView*) customPickerView didSelectRows:(NSArray*) rows {
    
    if([customPickerView isEqual:genderPicker]){
        NSInteger curCountryRow = ((NSNumber*)rows[0]).integerValue;
        profile.gender = curCountryRow == 0 ? @"MALE" : @"FEMALE";
    } else if([customPickerView isEqual:locationPicker]){
        profile.countryId = rows[0];
    }
    
    [_tableView reloadData];
    
}

@end
