//
//  PreviewBarcodeViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewBarcodeViewController : UIViewController

@property (nonatomic, weak) id delegate;

@end
@protocol PreviewBarcodeViewControllerDelegate <NSObject>

- (void)finishGetBarcode:(NSString *)barcode;

@end
