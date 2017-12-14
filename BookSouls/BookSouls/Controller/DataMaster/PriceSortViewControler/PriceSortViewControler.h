//
//  PriceSortViewControler.h
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceSortViewControler : UIViewController
@property (nonatomic, weak) id delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;
@property (nonatomic, strong) NSArray *arrPrice;
@end

@protocol PriceSortViewControlerDelegate <NSObject>

- (void)selectedPriceBook:(NSString *)price;

@end

