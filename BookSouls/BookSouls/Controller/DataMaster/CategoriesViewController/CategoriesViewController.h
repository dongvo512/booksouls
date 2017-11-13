//
//  CategoriesViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Categories;


@interface CategoriesViewController : UIViewController

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewController;
@property (nonatomic, weak) id delegate;

@end
@protocol CategoriesViewControllerDelegate <NSObject>

- (void)selectedCategories:(Categories *)cat;

@end
