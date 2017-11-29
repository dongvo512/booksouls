//
//  SellerInfoView.m
//  BookSouls
//
//  Created by Dong Vo on 11/24/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellerInfoView.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDTH_1_STAR 10.4

@interface SellerInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraintStar;

@end

@implementation SellerInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForView:(UserInfo *)user{
    
     [self.imgViewAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    
    self.lblName.text = user.name;
    self.widthContraintStar.constant = WIDTH_1_STAR * user.avgRating.integerValue;
    
    self.lblPhone.text = user.phone;
    
    self.lblAddress.text = user.homeAddress;
}
@end
