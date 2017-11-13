//
//  BookView.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@interface BookView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *viewReadMore;

- (void)setDataForView:(NSMutableArray *)arrBookNew title:(NSString *)title;
@property (nonatomic, weak) id delegate;
@end
@protocol BookViewDelegate <NSObject>

- (void)selectedItemBook:(Book *)book;

@end
