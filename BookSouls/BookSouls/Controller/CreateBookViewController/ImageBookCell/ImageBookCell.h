//
//  ImageBookCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Image;

@interface ImageBookCell : UICollectionViewCell
- (void)setDataForCell:(Image *)img;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (nonatomic, weak) id delegate;
@end

@protocol ImageBookCellDelegate <NSObject>
- (void)touchButtonDelete:(Image *)img;
@end
