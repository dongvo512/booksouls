//
//  BuyerCancelViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerCancelViewController : UIViewController

@property (nonatomic, weak) id delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;

@end
@protocol BuyerCancelViewControllerDelegate <NSObject>
- (void)aceptCancelFromBuyer:(NSString *)description;
@end
