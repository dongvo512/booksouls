//
//  MenuCell.m
//  hairista
//
//  Created by Dong Vo on 1/26/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "MenuCell.h"
#import "ItemMenu.h"


@interface MenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForCell:(ItemMenu *)itemMenu{

    self.imgIcon.image = [UIImage imageNamed:itemMenu.itemIconName];
    
    self.lblName.text = itemMenu.itemName;
}

@end
