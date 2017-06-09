//
//  SWGuideCell.h
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWGuideCell : UITableViewCell

@property (nonatomic, strong)SWGuide* content;
@property (nonatomic, assign)BOOL isMore;

@end
