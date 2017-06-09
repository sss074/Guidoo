//
//  SWEditProfileCell.h
//  Guidoo
//
//  Created by Sergiy Bekker on 11.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWEditProfileCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UILabel* detail;
@property (nonatomic, strong) NSDictionary* content;
@end
