//
//  SellerCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/23/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellerListCell.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexString.h"

#define WIDTH_1_STAR 14.2

@interface SellerListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSelled;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraintStar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintSelled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraintSelled;

@end

@implementation SellerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForCell:(UserInfo *)user{
    
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    
    self.widthContraintStar.constant = WIDTH_1_STAR * user.avgRating.integerValue;
    
    self.lblName.text = user.name;
    
    if(user.totalSell.integerValue == 0){
        
        self.topContraintSelled.constant = 0;
        self.heightContraintSelled.constant = 0;
        
    }
    else{
        
        self.topContraintSelled.constant = 5;
        self.heightContraintSelled.constant = 16;
        NSString *strSelled = [NSString stringWithFormat:@"%@ sách đã bán",user.totalSell.stringValue];
        self.lblSelled.text = strSelled;
        
        [Common hightLightLabel:self.lblSelled withSubstring:user.totalSell.stringValue withColor:[UIColor colorWithHexString:@"#252C3A"] font:[UIFont fontWithName:@"Muli-Regular" size:12]];
    }
    
    self.lblAddress.text = user.homeAddress;
}

@end
