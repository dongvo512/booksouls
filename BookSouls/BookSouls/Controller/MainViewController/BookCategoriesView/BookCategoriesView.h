//
//  BookCategoriesView.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Categories;
@interface BookCategoriesView : UICollectionReusableView

- (void)setDataForView:(NSMutableArray *)arrSeller;
@property (nonatomic, weak) id delegate;
@end
@protocol BookCategoriesViewDelegate <NSObject>
- (void)touchReadMore;
- (void)selectedItemCategories:(Categories *)cate;
@end
