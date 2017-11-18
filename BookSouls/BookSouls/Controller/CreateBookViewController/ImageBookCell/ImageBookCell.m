//
//  ImageBookCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ImageBookCell.h"
#import "Image.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageBookCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) Image *imageCurr;
@end

@implementation ImageBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForCell:(Image *)img{
    
    self.imageCurr = img;
    
    if([img.isDefaultIMG boolValue]){
        
        [self.imgView setImage:[UIImage imageNamed:@"bg_Image"]];
        [self.btnDelete setHidden:YES];
    }
    else{
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"bg_default"]];
        [self.btnDelete setHidden:NO];
    }
}

- (IBAction)touchBtnDelete:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchButtonDelete:)]){
        
        [[self delegate] touchButtonDelete:self.imageCurr];
    }
}



@end
