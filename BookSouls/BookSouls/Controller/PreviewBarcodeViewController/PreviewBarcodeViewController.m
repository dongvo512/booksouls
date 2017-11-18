//
//  PreviewBarcodeViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "PreviewBarcodeViewController.h"
#import "MTBBarcodeScanner.h"

@interface PreviewBarcodeViewController (){
    
     MTBBarcodeScanner *scanner;
}
@property (weak, nonatomic) IBOutlet UIView *viewBarcode;

@end

@implementation PreviewBarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]
                                                        previewView:self.viewBarcode];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
               
                if([[self delegate] respondsToSelector:@selector(finishGetBarcode:)]){
                    
                    [[self delegate] finishGetBarcode:code.stringValue];
                }
                    
                [scanner stopScanning];
                
                 [self.navigationController popViewControllerAnimated:YES];
            } error:&error];
            
        } else {
            // The user denied access to the camera
          
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
