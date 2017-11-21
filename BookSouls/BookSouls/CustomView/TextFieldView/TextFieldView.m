//
//  TextFieldView.m
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "TextFieldView.h"
#import "UIColor+HexString.h"

@interface TextFieldView ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubTitleContraint;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnIcon;

#define TOP_SUB_TITLE_EDIT 2
#define SIZE_SUB_EDIT 12
#define FONT_SUB_EDIT @"Muli-Light"

#define COLOR_SUB_EDIT @"#9098A9"
#define COLOR_SUB_DEFAULT @"#9098A9"
#define FONT_SUB_DEFAULT @"Roboto-Regular"
#define TOP_SUB_TITLE_DEFAULT 22
#define SIZE_SUB_DEFAULT 14

@end

@implementation TextFieldView

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Action

- (IBAction)touchBtnIcon:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchIconButton:)]){
        
        [[self delegate] touchIconButton:self];
    }
    
}
#pragma mark - Method

- (void)setup{
    
    self.view = [[NSBundle mainBundle] loadNibNamed:@"TextFieldView" owner:self options:nil].firstObject;
    
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
}

- (void)clearData{
    
    self.tfContent.text = @"";
   
    if(!self.isDisable){
        
        self.topSubTitleContraint.constant = TOP_SUB_TITLE_DEFAULT;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_DEFAULT size:SIZE_SUB_DEFAULT]];
                             
                             [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
                             
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:nil];
        [UIView commitAnimations];
    }
}

- (void)setDataForTextView{
    
    if(self.isDisable){
        
        [self.tfContent setEnabled:NO];
        self.topSubTitleContraint.constant = TOP_SUB_TITLE_EDIT;
        [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_EDIT size:SIZE_SUB_EDIT]];
        
        [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
    }
 
    self.lblSubTitle.text = self.strSubTile;
   
    [self.btnIcon setTitle:self.strIcon forState:UIControlStateNormal];
  
}
- (void)setDataEditing:(NSString *)content{
    
    if(content.length > 0){
       
        self.tfContent.text = content;
        self.topSubTitleContraint.constant = TOP_SUB_TITLE_EDIT;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_EDIT size:SIZE_SUB_EDIT]];
                             
                             [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
                             
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:nil];
        [UIView commitAnimations];
    }
    else{
        
        if(!self.isDisable){
            
            self.topSubTitleContraint.constant = TOP_SUB_TITLE_DEFAULT;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 
                                 [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_DEFAULT size:SIZE_SUB_DEFAULT]];
                                 
                                 [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
                                 
                                 [self.view layoutIfNeeded];
                                 
                             }
                             completion:nil];
            [UIView commitAnimations];
        }
        
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.topSubTitleContraint.constant = TOP_SUB_TITLE_EDIT;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                        
                         [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_EDIT size:SIZE_SUB_EDIT]];
                         
                         [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
                         
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:nil];
    [UIView commitAnimations];

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.text.length == 0 && !self.isDisable){
        
        self.topSubTitleContraint.constant = TOP_SUB_TITLE_DEFAULT;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             [self.lblSubTitle setFont:[UIFont fontWithName:FONT_SUB_DEFAULT size:SIZE_SUB_DEFAULT]];
                             
                             [self.lblSubTitle setTextColor:[UIColor colorWithHexString:COLOR_SUB_EDIT]];
                             
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:nil];
        [UIView commitAnimations];
    }
    
    if(self.isPrice){
        
        NSString *strTemp = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        textField.text = [Common getString3DigitsDot:strTemp.integerValue];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
@end
