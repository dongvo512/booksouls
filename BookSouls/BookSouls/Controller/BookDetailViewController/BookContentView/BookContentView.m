//
//  BookContentView.m
//  BookSouls
//
//  Created by Dong Vo on 11/11/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookContentView.h"

@interface BookContentView()

@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;

@end

@implementation BookContentView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataForView:(NSString *)contentBook isExpand:(BOOL)isExpand isShowExpand:(BOOL)isShowExpand{
    
    self.lblContent.text = contentBook;
    [self.btnExpand setSelected:isExpand];
  
    [self.imgBackground setHidden:YES];
    
    if(isShowExpand){
        
        [self.btnExpand setHidden:NO];
    }
    else{
    
        [self.btnExpand setHidden:YES];
    }
    
    
    if(!isExpand){
        
        [self.lblContent setNumberOfLines:3];
       
        if(isShowExpand){
           
            [self.imgBackground setHidden:NO];
        }
    }
    else{
        
        [self.lblContent setNumberOfLines:0];
    }
    
    
}

- (IBAction)touchBtnExpand:(id)sender {
    
    if([[self delegate]
        respondsToSelector:@selector(selectedBtnExpand)]){
        
        [[self delegate] selectedBtnExpand];
    }
}


@end
