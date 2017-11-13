//
//  BookDetailBannerCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookDetailBannerCell.h"
#import "Image.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookDetailBannerCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;

@end

@implementation BookDetailBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForCell:(Image *)img{
    
   [self.imgBanner sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"bg_default"]];
}

@end
