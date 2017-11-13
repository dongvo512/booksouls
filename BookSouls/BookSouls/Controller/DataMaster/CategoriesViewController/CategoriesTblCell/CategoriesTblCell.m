//
//  CategoriesTblCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "CategoriesTblCell.h"
#import "Categories.h"

@interface CategoriesTblCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblCategoriesName;

@end

@implementation CategoriesTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForCell:(Categories *)cat{
    
    self.lblCategoriesName.text = cat.name;
    
}

@end
