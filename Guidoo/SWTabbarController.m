//
//  SWTabbarController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWTabbarController.h"
#import "CustomBadge.h"
#import <AVFoundation/AVFoundation.h>

@interface SWTabbarController (){
    NSInteger curBage;
    CustomBadge* badgeMessage;
    int vibrateCount;
    NSTimer * vibrateTimer;
}

@end

@implementation SWTabbarController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curBage = 0;
    
    self.tabBar.layer.borderWidth = 0.7f;
    self.tabBar.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.tabBar.clipsToBounds = YES;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
}
- (void)updateBage:(NSInteger)count withState:(BOOL)state{
 
    if(count > 0){
        if(badgeMessage == nil){
            CGFloat posX = self.tabBar.frame.size.width / self.tabBar.items.count;
            BadgeStyle* style = [BadgeStyle new];
            style.badgeTextColor = [UIColor whiteColor];
            style.badgeInsetColor = [UIColor colorWithRed:251.f / 255.f green:129.f / 255.f blue:129.f / 255.f alpha:1.f];
            style.badgeFrameColor = [UIColor clearColor];
            style.badgeFrame = YES;
            style.badgeShining = NO;
            style.badgeFontType =  BadgeStyleFontTypeHelveticaNeueLight;
            badgeMessage = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld",count] withStyle:style];
            [badgeMessage setFrame:CGRectMake(4 * posX - badgeMessage.frame.size.width / 2 - 15.f , 0.f, badgeMessage.frame.size.width, badgeMessage.frame.size.height)];
            [self.tabBar addSubview:badgeMessage];
        }
        if(state)
            [self setVibro];
    } else if(count == 0){
        [badgeMessage removeFromSuperview];
        badgeMessage = nil;
    }
 
}
- (void)setVibro{
   
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error == nil) {
        SystemSoundID myAlertSound;
        NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/sms-received1.caf"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
        AudioServicesPlaySystemSound(myAlertSound);
    }
    

    vibrateCount = 0;
    vibrateTimer = nil;
    vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(vibratePhone) userInfo:nil repeats:YES];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
-(void)vibratePhone {
    
    vibrateCount ++;
    
    if(vibrateCount <= VIBRCOUNT)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    else
        [vibrateTimer invalidate];
    
    
}
@end
