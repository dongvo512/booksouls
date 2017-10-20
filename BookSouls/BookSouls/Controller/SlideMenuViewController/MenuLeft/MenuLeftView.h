//
//  MenuLeftView.h
//  hairista
//
//  Created by Dong Vo on 1/26/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuLeftView : UIView

- (id) init:(BOOL)isUserManager isAdmin:(BOOL)isAdmin;

- (id)initWithFrame:(CGRect)frame isUserManager:(BOOL)isUserManager isAdmin:(BOOL)isAdmin;

- (void)loadUserInfo;

@property (nonatomic) BOOL isUserManager;
@property (nonatomic) BOOL isAdmin;

@property (strong, nonatomic) IBOutlet UIView *view;
@end
