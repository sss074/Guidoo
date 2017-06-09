//
//  SWGuideCell.h
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SWTourCell : UITableViewCell

@property (nonatomic, strong) SWTour* content;
@property (nonatomic, strong) SWGuide* guidInfo;

@end
