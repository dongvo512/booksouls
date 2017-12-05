//
//  CommentSellerViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSellerViewController : UIViewController

@property (nonatomic, weak) id delegate;
- (void)presentInParentViewController:(UIViewController *)parentViewController;

@end
@protocol CommentSellerViewControllerDelegate <NSObject>
- (void)aceptCommentForSeller:(NSString *)description numStar:(NSInteger)numStar;
@end
