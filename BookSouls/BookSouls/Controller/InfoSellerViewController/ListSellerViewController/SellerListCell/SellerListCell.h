//
//  SellerCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/23/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;

@interface SellerListCell : UITableViewCell
- (void)setDataForCell:(UserInfo *)user;
@end
