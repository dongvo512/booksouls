//
//  SellerCancelViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerCancelViewController : UIViewController

@property (nonatomic, weak) id delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;

@end
@protocol SellerCancelViewControllerDelegate <NSObject>
- (void)aceptCancelFromSeller:(NSString *)description;
@end
