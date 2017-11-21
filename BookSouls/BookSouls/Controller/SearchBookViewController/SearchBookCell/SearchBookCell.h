//
//  SearchBookCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface SearchBookCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (nonatomic, weak) id delegate;
- (void)setDataForCell:(Book *)book;

@end
@protocol SearchBookCellDelegate <NSObject>
- (void)selectButtonEdit:(Book *)book;
@end
