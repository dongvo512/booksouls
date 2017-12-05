//
//  ContentOrderViewSellingController.h
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderViewController;

@interface ContentOrderViewSellingController : UIViewController
@property (nonatomic, weak) OrderViewController *vcParent;

- (IBAction)touchBtnWaitingSell:(id)sender;
- (IBAction)touchBtnShping:(id)sender;
- (IBAction)touchComment:(id)sender;
- (IBAction)touchBtnSelled:(id)sender;
- (IBAction)touchBtnCancel:(id)sender;

@end
