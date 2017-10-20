//
//  SlideMenuViewController.h
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuLeftView.h"


@interface SlideMenuViewController : UIViewController

+ (id)sharedInstance;

@property (nonatomic, strong) MenuLeftView *viewMenuLeft;
@property (nonatomic) BOOL isUserManager;
@property (nonatomic) BOOL isAdmin;

// nhấn nút menu.
-(void)toggle;

// set tỉ lệ menu trái với màn hình.
-(void)setRatioWidthMenuLeft:(CGFloat)ratio;

// thay root Viewcontroller cho navigationcontroller với danh sách items trên Menu.
- (void)selectedItemInMenu:(NSInteger )index;

@end
