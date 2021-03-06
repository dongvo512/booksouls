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
- (void)setDataForCell:(Book *)book;
@property (weak, nonatomic) IBOutlet UIView *viewQuality;

@end

