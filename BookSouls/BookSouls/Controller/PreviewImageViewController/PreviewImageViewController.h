//
//  PreviewImageViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewImageViewController : UIViewController

@property (nonatomic, strong) UIImage *imagePreview;
@property (nonatomic, weak) id delegate;
@end
@protocol PreviewImageViewControllerDelegate <NSObject>

- (void)touchBtnAcept:(UIImage *)img;
- (void)touchBtnCancel;
@end
