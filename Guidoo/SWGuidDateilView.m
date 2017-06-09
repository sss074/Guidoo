//
//  SWGuidDateilView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWGuidDateilView.h"
#import "SWPreferences.h"
#import "SWGuideCell.h"
#import "SWTourCell.h"
#import "SWTourCell.h"


@interface SWGuidDateilView () {
    NSArray* guids;
    NSInteger curIndex;
    SWGuide* guide;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,strong)IBOutlet UIView* headerView;
@property (nonatomic,strong) IBOutlet UIImageView *logoView;
@property (nonatomic,strong)IBOutlet UILabel* nameLabel;
@property (nonatomic,strong)IBOutlet UILabel* profLabel;
@property (nonatomic,strong)IBOutlet UILabel* genderLabel;
@property (nonatomic,strong)IBOutlet UILabel* expirienceLabel;
@property (nonatomic,strong)IBOutlet UILabel* locationLabel;
@property (nonatomic,strong)IBOutlet UILabel* languageLabel;
@property (nonatomic,strong)IBOutlet UIButton* backBut;
@property (nonatomic,strong)IBOutlet UIButton* shareBut;
@property (nonatomic,strong)IBOutlet UIButton* bookmarkBut;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@end

@implementation SWGuidDateilView

- (void)setContent:(NSArray *)content{
    _content = content;

    if(_content != nil){
        __block NSMutableArray* temp = [[NSMutableArray alloc]initWithArray:_content];
        guide = temp[0];
       /* if([self isParamValid:guide]){
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)guide.guideId).integerValue,object.sessionToken];
                [[SWWebManager sharedManager]getGuideProfile:param withID:guide.guideId success:^(SWGuide *obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([self isParamValid:guide.regId]){
                            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)guide.regId).integerValue,kImageFBNextBaseApiUrl]);
                            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)guide.regId).integerValue,kImageFBNextBaseApiUrl]];
                            [_logoView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if(image != nil){
                                    [_logoView setImage:image];
                                }
                            }];
                        }
                        
                        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName];
                        NSInteger star = ((NSNumber*)guide.rating).integerValue;
                        for(UIImageView* obj in _stars){
                            [obj setImage:[UIImage imageNamed:@"star_normal"]];
                        }
                        for(int i = 0; i < star; i++){
                            UIImageView* obj = _stars[i];
                            [obj setImage:[UIImage imageNamed:@"star_act"]];
                        }
                        _expirienceLabel.text = @"Parameter is missing";
                        
                        
                        
                    });
                }];
            }

        }*/
        _bookmarkBut.tintColor = [self checkGuid:guide.guideId] ? [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f] : [UIColor whiteColor];
        
        if([self isParamValid:guide.regId]){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)guide.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)guide.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_logoView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_logoView setImage:image];
                }
            }];
        }
        
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName];
        NSInteger star = ((NSNumber*)guide.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
            [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
      
        _genderLabel.text = [self isParamValid:guide.resume] ? guide.resume : nil;
        _expirienceLabel.text = @"Parameter is missing";
        _profLabel.text = @"Parameter is missing";
        SWTour* tour = temp[1];
        
        if( [self isParamValid:tour.languageIds]){
            NSMutableString* lg = [[NSMutableString alloc] init];
            for(int i = 0; i < tour.languageIds.count; i++){
                [lg appendString:[NSString stringWithFormat:@",%@",[self languageFromID:tour.languageIds[i]]]];
            }
            if(lg.length > 0)
                _languageLabel.text = [lg substringWithRange:NSMakeRange(1, lg.length - 1)];
        }
        _locationLabel.text = [self isParamValid:tour.city] ? tour.city : nil;
        
        [temp removeObjectAtIndex:0];
        _content = [NSArray arrayWithArray:temp];
        [_tableView reloadData];
        
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];

    [_logoView setCornerRadius:CGRectGetHeight(_logoView.frame) / 2];
    [_logoView setClipsToBounds:YES];
    [_tableView setTableHeaderView:_headerView];
}

#pragma mark - Action methods

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_backBut]){
        if([_delegate respondsToSelector:@selector(backPress:)]){
            [_delegate backPress:self];
        }
    } else if([button isEqual:_shareBut]){
        if([_delegate respondsToSelector:@selector(sendMail:withContent:)]){
            [_delegate sendMail:self withContent:guide];
        }
    } if([button isEqual:_bookmarkBut]){

        [self showIndecator:YES];
        if([self checkGuid:guide.guideId]){
            [[SWWebManager sharedManager]removeBookmarksGuid:nil withTourID:guide.guideId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _bookmarkBut.tintColor = [self checkGuid:guide.guideId] ? [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f] : [UIColor whiteColor];
                });
            }];
        } else {
            [[SWWebManager sharedManager]bookmarksGuid:nil withGuideID:guide.guideId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _bookmarkBut.tintColor = [self checkGuid:guide.guideId] ? [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f] : [UIColor whiteColor];
                });
            }];
        }
        
    }
}
#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TourCell";

    SWTourCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.content = _content[indexPath.row];

    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 355.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([_delegate respondsToSelector:@selector(didSelectItem:withContent:)]){
        [_delegate didSelectItem:self withContent:_content[indexPath.row]];
    }
}

@end
