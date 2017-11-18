//
//  BookSearchViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@interface BookSearchViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrSearch;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewController;
@property (nonatomic, weak) id delegate;
@end

@protocol BookSearchViewControllerDelegate <NSObject>
- (void)selectedBook:(Book *)book;
@end
