//
//  CategoriesCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/8/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "CategoriesCell.h"
#import "Categories.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CategoriesCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategories;

@end

@implementation CategoriesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgCategories.layer.masksToBounds = YES;
    self.imgCategories.layer.cornerRadius = 8;
    
}
- (void)setDataForCell:(Categories *)cat{
    
    self.lblTitle.text = cat.name;
    [self.imgCategories sd_setImageWithURL:[NSURL URLWithString:cat.imageurl] placeholderImage:[UIImage imageNamed:@"bg_default"]];
}

@end
