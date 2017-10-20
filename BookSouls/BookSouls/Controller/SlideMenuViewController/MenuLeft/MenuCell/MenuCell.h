//
//  MenuCell.h
//  hairista
//
//  Created by Dong Vo on 1/26/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemMenu;

@interface MenuCell : UITableViewCell

- (void)setDataForCell:(ItemMenu *)itemMenu;

@end
