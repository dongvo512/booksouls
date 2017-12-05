//
//  OrderViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentOrderViewSellingController,ContentOrderBuyingViewController;


@interface OrderViewController : UIViewController
@property (nonatomic, strong) ContentOrderViewSellingController *vcSelling;
@property (nonatomic, strong) ContentOrderBuyingViewController *vcBuying;
- (IBAction)touchBookSelling:(id)sender;
- (IBAction)touchBtnBookEnd:(id)sender;

@end
