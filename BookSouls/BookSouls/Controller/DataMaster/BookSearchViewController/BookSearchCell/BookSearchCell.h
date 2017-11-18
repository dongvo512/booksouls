//
//  BookSearchCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface BookSearchCell : UICollectionViewCell

- (void)setDataForCell:(Book *)book;

@end
