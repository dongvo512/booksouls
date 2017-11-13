//
//  BookImageCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/13/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Image.h"

@interface BookImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBookView;

@end

@implementation BookImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForCell:(Image *)img{
    
    [self.imgBookView sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"bg_default"]];
}
@end
