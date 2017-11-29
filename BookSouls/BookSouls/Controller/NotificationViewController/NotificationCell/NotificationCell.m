//
//  NotificationCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "NotificationCell.h"
#import "Notify.h"
#import "UIColor+HexString.h"

@interface NotificationCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateNotify;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForCell:(Notify *)notify{
    
    self.lblTitle.text = notify.title;
    
    if([notify.title containsString:@"Hủy"]){
        
        [self.lblTitle setTextColor:[UIColor colorWithHexString:@"#F44E4E"]];
    }
    else if([notify.title containsString:@"Bán"]){
        
        [self.lblTitle setTextColor:[UIColor colorWithHexString:@"#F0C86D"]];
    }
    else if([notify.title containsString:@"Mua"]){
        
        [self.lblTitle setTextColor:[UIColor colorWithHexString:@"#1CB8FF"]];
    }
    
    self.lblCreateNotify.text = [Common formattedDateTimeWithDateString:notify.createdAt inputFormat:@"yyyy-MM-dd HH:mm:ss" outputFormat:@"dd/MM/yyyy HH:mm"];
    self.lblContent.text = notify.content;
}
@end
