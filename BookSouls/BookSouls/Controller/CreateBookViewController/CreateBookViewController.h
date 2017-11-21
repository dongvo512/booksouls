//
//  CreateBookViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@interface CreateBookViewController : UIViewController
@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) Book *bookEdit;
@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic, weak) id delegate;
@end

@protocol CreateBookViewControllerDelegate <NSObject>
- (void)finishEditing:(Book *)bookNew bookEdit:(Book*)bookEdit;
@end
