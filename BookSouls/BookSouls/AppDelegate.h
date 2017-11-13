//
//  AppDelegate.h
//  BookSouls
//
//  Created by Dong Vo on 10/16/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionUser.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SessionUser *sesstionUser;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) NSMutableArray *arrCategories;

@end

