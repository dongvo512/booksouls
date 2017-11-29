//
//  BookSellerView.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookSellerView.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDTH_1_STAR 14.2

@interface BookSellerView()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthStarContraint;
@property (weak, nonatomic) IBOutlet UILabel *lblSelled;
@property (weak, nonatomic) IBOutlet UILabel *lblSubSelled;


@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (nonatomic, strong) UserInfo *userCurr;
@end

@implementation BookSellerView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForView:(UserInfo *)user{
    
    self.userCurr = user;
    
    [self.imgViewAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    
    self.lblName.text = user.name;
    self.widthStarContraint.constant = WIDTH_1_STAR * user.avgRating.integerValue;
    
    if(user.totalSell.integerValue >0){
        
        [self.lblSubSelled setHidden:NO];
        self.lblSelled.text = user.totalSell.stringValue;
    }
    else{
        
        [self.lblSubSelled setHidden:YES];
    }
    
   // self.lblAddress.text = [Common formattedDateTimeWithDateString:user.createdAt inputFormat:@"yyyy-MM-dd HH:mm:ss" outputFormat:@"dd-MM-yyy HH:mm:SS"];
    self.lblAddress.text = user.homeAddress;
    
}

#pragma mark - Action

- (IBAction)touchBtnInfoSeller:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedSellerInfo:)]){
        
        [[self delegate] selectedSellerInfo:self.userCurr];
    }
}


- (IBAction)touchBtnCall:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchCall)]){
        
        [[self delegate] touchCall];
    }
}

- (IBAction)touchBtnSMS:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchSMS)]){
        
        [[self delegate] touchSMS];
    }
}

@end
