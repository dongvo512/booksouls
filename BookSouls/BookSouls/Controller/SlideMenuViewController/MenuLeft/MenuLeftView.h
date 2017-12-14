//
//  MenuLeftView.h
//  hairista
//
//  Created by Dong Vo on 1/26/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuLeftView : UIView

- (void)loadUserInfo;

@property (strong, nonatomic) IBOutlet UIView *view;

- (void)updateNumNoti:(NSNumber *)numNoti;
@end
