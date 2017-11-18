//
//  ImagePickerViewController.h
//  Family
//
//  Created by Admin on 7/11/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImagePickerViewControllerDelegate <NSObject>

@optional

- (void) finishGetImage:(NSString *)fileName dataImage:(NSData *)dataImage dataImageThumnail:(NSData *)dataImageThumnail;
- (void) finishGetImage:(NSString *)fileName image:(UIImage *)image;

@end
@interface ImagePickerViewController : UIImagePickerController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    id <ImagePickerViewControllerDelegate> _delegate;
}
@property (nonatomic, strong) UIViewController *vcParent;
@property (strong, nonatomic) UIImage *imgCurrent;
@property (strong) id delegateImg;

- (void)takeAPickture:(UIViewController *)vcCurrent;
-(Boolean) isCheckCamrera;
-(void)cameraRoll:(UIViewController *)vcCurrent;

@property (nonatomic, retain) NSString *nameImageChosenCurr;

@end
