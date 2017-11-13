//
//  WellcomeView.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "WellcomeView.h"

@interface WellcomeView()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation WellcomeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
  //  self.lblTitle.text = [NSString stringWithFormat:@"Xin chào, %@!",Appdelegate_BookSouls.sesstionUser.profile.name];
    // Initialization code
}

@end
