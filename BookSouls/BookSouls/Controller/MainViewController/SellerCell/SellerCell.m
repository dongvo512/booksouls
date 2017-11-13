//
//  SellerCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/8/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellerCell.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SellerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
@implementation SellerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForCell:(UserInfo *)user{
    
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    self.lblName.text = user.name;
}

@end
