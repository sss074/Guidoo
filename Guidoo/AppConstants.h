//
//  AppConstants.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h


#define FacebookID @"393774907631752"

#define ERRRORLOGIN @"Неверный логин или пароль"
#define EXITTITLE @"Выйти из аккаунта"


#define TheApp AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define  FIRASANSMEDIUM @"FiraSans-Medium"
#define  FIRASANSREGULAR @"FiraSans-Regular"

#define SUCCSESS 200
#define INVALIDTOKEN 401
#define ISPRESENT 409
#define ISBOOKTOUR 400
#define DISTANCE 0.005
#define ACCEPTED @"ACCEPTED"

#define OPENSANS @"OpenSans"
#define OPENSANSLIGHT @"OpenSans-Light"
#define OPENSANSSEMIBOLD @"OpenSans-Semibold"
#define OPENSANSITALIC @"OpenSans-Italic"
#define VIBRCOUNT 2

static NSInteger nightTime = 86400;
static NSDictionary *dictCodes = nil;
static NSString * const currentLoginKey =  @"currentLogin";
static NSString * const userLoginInfo =  @"userLoginInfo";
static NSString * const userPreferences = @"userPreferences";
static NSString * const locationInfo = @"locationInfo";
static NSString * const FacebookProfile = @"FacebookProfile";
static NSString * const address = @"address";
static NSString * const userInfo = @"userInfo";
static NSString * const profileInfo = @"profileInfo";
static NSString * const avatar = @"avatar";
static NSString * const phoneNumberKey = @"phoneNumberKey";

static NSString * const kDevBaseApiUrl  =  @"http://138.68.162.195:9080";
static NSString * const kImageBaseApiUrl  =  @"http://138.68.162.195:9080/guide/";
static NSString * const kImageFBPrevBaseApiUrl  =  @"http://graph.facebook.com/";
static NSString * const kImageFBNextBaseApiUrl  =  @"/picture?type=large";
static NSString * const stripeKey  =  @"pk_test_DTmxO5oUnY9xQGEn5ZzlSeEW";

static NSString *phonecharSet = @"_.-/:;()&@\",?!'[]{}#%^*=\\|~<>₽$£₹€•´`";
static NSString *charSet = @"_.-/:;()&@\",?!'[]{}#%^*+=\\|~<>₽$£₹€•´`";
static NSString *passCharTemplate = @"/:;()&@\",?!'[]{}#%^*+=\\|~<>₽$£₹€•";
static NSString *emailCharTemplate = @" /:;()&\",?!'[]{}#%^*+=\\|~<>₽$£₹€•";

typedef NS_ENUM(NSUInteger, NavBarType) {
    NONTYPE = 0,
    BASETYPE,
    BACKTYPE,
    FILTERTYPE,
    MAPTYPE,
    MENUTYPE,
    CHOSETYPE,
    MARKTYPE,
    MARKSAVEDTYPE
};




static NSString* key_isToolBarExistNSNumber = @"isToolBarExistNSNumber";
static NSString* key_doneBtnTitleNSString = @"doneBtnTitleNSString";
static NSString* key_cancelBtnTitleNSString = @"cancelBtnTitleNSString";
static NSString* key_horizEdgeOffsetsCancelDoneBtns = @"horizEdgeOffsetsCancelDoneBtns";
static NSString* key_toolBarTitleNSString = @"toolBarTitleNSString";
static NSString* key_datePickerSelectedDateNSDate = @"datePickerSelectedDateNSDate";
static NSString* key_datePickerSelectedDateNSString = @"datePickerSelectedDateNSString";
static NSString* key_pickerFontNameNSString = @"pickerFontNameNSString";
static NSString* key_pickerFontSizeNSNumber = @"pickerFontSizeNSNumber";
static NSString* key_pickerContentTextColorUIColor = @"pickerContentTextColorUIColor";
static NSString* key_pickerComponentsRowsBackgroundColorUIColor = @"pickerComponentsRowsBackgroundColorUIColor";
static NSString* key_pickerBackgroundColorUIColor = @"pickerBackgroundColorUIColor";
static NSString* key_pickerSelectionLinesColorUIColor = @"pickerSelectionLinesColorUIColor";
static NSString* key_toolBarTitleColorUIColor = @"toolBarTitleColorUIColor";
static NSString* key_toolbarTitleTextFontNSString = @"toolbarTitleTextFontNSString";
static NSString* key_toolBarTitleTextFontSizeNSNumber = @"toolBarTitleTextFontSizeNSNumber";
static NSString* key_pickerSelectedRowsNSArray = @"pickerSelectedRowsNSArray";
static NSString* kInitDictionary = @"initSettingsDictionary";


typedef NS_ENUM(NSUInteger, TRPickerAppearancePlace) {
    TRPickerAppearancePlace_Top = 0,
    TRPickerAppearancePlace_Bottom
};

#endif /* AppConstants_h */
