//
//  BookDetailTitleView.h
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book,Image;

@interface BookDetailTitleView : UICollectionReusableView

- (void)setDataForView:(Book *)book;

@property (nonatomic, weak) id delegate;

@end

@protocol BookDetailTitleViewDelegate <NSObject>
- (void)selectedImage:(Image *)imgSelected;
@end
