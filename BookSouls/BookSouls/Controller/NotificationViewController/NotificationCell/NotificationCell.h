//
//  NotificationCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Notify;
@interface NotificationCell : UITableViewCell

- (void)setDataForCell:(Notify *)notify;

@end
