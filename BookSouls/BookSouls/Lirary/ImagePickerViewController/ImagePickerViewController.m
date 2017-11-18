//
//  ImagePickerViewController.m
//  Family
//
//  Created by Admin on 7/11/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Common.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController
#define NEW_SIZE_IMAGE_HEIGHT 100
#define NEW_SIZE_IMAGE_WIDTH 100

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

- (void)takeAPickture:(UIViewController *)vcCurrent{
    
    
    self.delegate = self;
    if([self isCheckCamrera]){
        
        self.allowsEditing = NO;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.videoQuality = UIImagePickerControllerQualityTypeLow;
        
        [vcCurrent presentViewController:self animated:YES completion:NULL];
    }
        
}

- (void)cameraRoll:(UIViewController *)vcCurrent{
    
    self.delegate = self;
    self.allowsEditing = NO;
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    [vcCurrent presentViewController:self animated:YES completion:NULL];
}

- (Boolean) isCheckCamrera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return NO;
    }
    else
        return YES;
}

#pragma mark - Image Picker Controller delegate methods

- (NSString *)getRandomImageName{
    
    NSInteger year = [Common yearFromDate:[NSDate date]];
    NSInteger month = [Common monthFromDate:[NSDate date]];
    NSInteger day = [Common dayFromDate:[NSDate date]];
    NSInteger hour = [Common hourFromDate:[NSDate date]];
    NSInteger minute = [Common minuteFromDate:[NSDate date]];
    NSInteger second = [Common secondFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"IMG_%d%d%d%d%d%d.JPG", year, month, day, hour, minute, second];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    NSString *strFileName = [self getRandomImageName];
    
    if([[self delegateImg]respondsToSelector:@selector(finishGetImage:image:)]){
        
        [[self delegateImg] finishGetImage:strFileName image:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIImage *)reSizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
