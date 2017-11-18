//
//  StatusBookViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusBookViewController : UIViewController
@property (nonatomic, weak) id delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;
@end

@protocol StatusBookViewControllerDelegate <NSObject>

- (void)selectedStatusBook:(NSString *)status;

@end
