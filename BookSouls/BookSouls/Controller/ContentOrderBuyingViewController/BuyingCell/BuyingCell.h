//
//  BuyingCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/28/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;

@interface BuyingCell : UITableViewCell

@property (nonatomic, weak) id delegate;

- (void)setDataForCell:(Order *)order indexSelected:(NSInteger)indexSelected;

@end

@protocol BuyingCellDelegate <NSObject>

- (void)selectedButtonAcept:(Order *)order;
- (void)selectedButtonCancel:(Order *)order;
- (void)selectedButtonComment:(Order *)order;

@end
