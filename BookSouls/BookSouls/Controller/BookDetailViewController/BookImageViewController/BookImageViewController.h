//
//  BookImageViewController.h
//  BookSouls
//
//  Created by Dong Vo on 11/13/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookImageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrImages;
@property (nonatomic) NSInteger indexCurr;
@property (nonatomic, strong) NSString *bookName;
@end
