//
//  BookNewCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookNewCell.h"
#import "Book.h"
#import "Image.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexString.h"

@interface BookNewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookNew;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end

@implementation BookNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //self.viewImage.layer.masksToBounds = NO;
    self.viewImage.layer.shadowOffset = CGSizeMake(-2, 4);
    self.viewImage.layer.shadowRadius = 2;
    self.viewImage.layer.shadowOpacity = 0.2;
}

- (void)setDataForCell:(Book *)book{
    
    self.lblTitle.text = book.name;
    self.lblAuthor.text = book.author;
    
    NSString *priceNew = [Common getString3DigitsDot:book.price.integerValue];
    NSString *priceTemp = [NSString stringWithFormat:@"  %@",priceNew];
    
    self.lblPrice.text = priceTemp;
    
    if(book.images.count > 0){
        
        Image *img = [book.images firstObject];
        [self.imgBookNew sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }

}

@end
