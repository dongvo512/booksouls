//
//  CommentCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"

@interface CommentCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgRatio;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForCell:(Comment *)comment{
    
    self.lblTitle.text = comment.title;
    
    if(comment.isSelected){
        
        [self.imgRatio setImage:[UIImage imageNamed:@"btn_ratio_selected"]];
    }
    else{
        
         [self.imgRatio setImage:[UIImage imageNamed:@"btn_ratio_none"]];
    }
}

@end
