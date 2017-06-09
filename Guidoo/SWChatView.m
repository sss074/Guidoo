//
//  SWChatView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChatView.h"
#import "SWChatCell.h"
#include <time.h>
#include <stdlib.h>

@interface SWChatView (){
    CGRect previousRect;
    NSArray * content;
    int curRow;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* sendY;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* sendH;
@property (nonatomic,strong)IBOutlet UIButton* sendBut;
@property (nonatomic,strong)IBOutlet UITextView* textView;
@property (nonatomic,strong)IBOutlet UIView* bottomView;

@end

@implementation SWChatView

- (void)setContent:(SWChatMessage *)content{
    _content = content;
    
    if(_content != nil){
        [self messageRead];
        
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    previousRect = CGRectZero;
    curRow = 1;
    
    [_textView setFont:[UIFont fontWithName:@"OpenSans" size:16.f]];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapRec setCancelsTouchesInView:NO];
    [_tableView addGestureRecognizer:tapRec];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChat:) name:@"updateChat" object:nil];
    
    [_tableView setHidden:YES];
    [_bottomView setHidden:YES];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateChat" object:nil];

}
#pragma mark -  Service methods
- (void)messageRead{
    
    if([self isParamValid:_content.messageId]){
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            [self showIndecator:YES];
            NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&senderUserId=%ld&lastMessageId=%ld",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken,((NSNumber*)_content.senderUserId).integerValue,((NSNumber*)_content.messageId).integerValue];
            [[SWWebManager sharedManager] confirmMessagesBefore:param success:nil];
        }
        
        [[SWDataManager sharedManager] resetChatItem:_content.senderUserId];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListChat" object:nil];
            [_tableView setHidden:NO];
            [_bottomView setHidden:NO];
            [[SWDataManager sharedManager] updateBage:NO];
            [self getContent];
        });
    } else {
        [[SWDataManager sharedManager] resetChatItem:_content.senderUserId];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListChat" object:nil];
            [_tableView setHidden:NO];
            [_bottomView setHidden:NO];
            [[SWDataManager sharedManager] updateBage:NO];
            [self getContent];
        });
    }

}
- (void)getContent{
    content = [[SWDataManager sharedManager] searchItems:_content.senderUserId withSort:YES];
    [_tableView reloadData];
    [self scrollToBottom];
}
- (void)tap:(UITapGestureRecognizer*)obj{
    
    [_textView resignFirstResponder];

}
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (_tableView.contentSize.height > _tableView.bounds.size.height){
        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
        [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
    
}
#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ChatCell";
    
    SWChatCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.content = content[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWChatMessage* obj = content[indexPath.row];
    
    CGSize size = [self sizeWithText:obj.message width:CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f font:[UIFont fontWithName:@"OpenSans" size:16.f]];
    
    return size.height + 90.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}


#pragma mark -  NSNotification

- (void)updateChat:(NSNotification*)notify{
    SWChatMessage* obj = notify.object;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&senderUserId=%ld&lastMessageId=%ld",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken,((NSNumber*)_content.senderUserId).integerValue,((NSNumber*)obj.messageId).integerValue];
            [[SWWebManager sharedManager] confirmMessagesBefore:param success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SWDataManager sharedManager] resetChatItem:_content.senderUserId];
                    [self getContent];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListChat" object:nil];
                });
            }];
        }
        
    });
    

}
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info          = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  
    [self scrollToActiveTextField:kbSize];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    _sendY.constant = 0;
    _sendH.constant = 50;
    [_textView setText:@""];
}

- (void)scrollToActiveTextField:(CGSize)kbSize{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sendY.constant += kbSize.height;
    });
   
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_sendBut]){
        NSString* mess = _textView.text;
        [_textView resignFirstResponder];
        
        __block NSString* mesText = [[mess componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        mesText = [mesText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([mesText isEqualToString:@""]){
            return;
        }

        mesText = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                        (CFStringRef)mesText,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        if(![mesText isEqualToString:@""] ){
            SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
            if(objLogin != nil){
                NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&receiverUserId=%ld&message=%@",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken,((NSNumber*)_content.senderUserId).integerValue,mesText];
                [[SWWebManager sharedManager] sendMessage:param success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        srand(time(NULL));
                        mesText = [[mess componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                        mesText = [mesText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        SWChatMessage* message = [SWChatMessage new];
                        message.senderUserId = _content.senderUserId;
                        message.regId = _content.regId;
                        message.sentTime = @((long long)([[NSDate date] timeIntervalSince1970] * 1000.0));
                        message.firstName = _content.firstName;
                        message.lastName = _content.lastName;
                        message.isIncome = @(NO);
                        message.messageId = @(rand() % 1000);
                        message.message = mesText;
                        message.isNew = @(NO);
                        [[SWDataManager sharedManager]updateChatItem:message];
                        
                        [self getContent];
                    });
                }];
            }
        }
    }
}

#pragma  mark - UITextView delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
-(void)textViewDidChange:(UITextView *)textView
{
  
   int rows = (int)(textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font.lineHeight;
    NSLog(@"%d",rows);
    NSLog(@"%d",curRow);
    if(rows > 1 && rows < 5){
        if(rows < curRow){
            _sendH.constant -= (textView.font.lineHeight + 5.f);
        } else if(rows > curRow){
            _sendH.constant += (textView.font.lineHeight + 5.f);
        }
        curRow = rows;
    } else if(rows == 1){
        _sendH.constant = 50;
        curRow = 1;
    }


}
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [self textViewDidChange:textView];
    }

    
    return YES;
}

@end
