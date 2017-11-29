//
//  SellerInfoView.h
//  BookSouls
//
//  Created by Dong Vo on 11/24/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;

@interface SellerInfoView : UICollectionReusableView
- (void)setDataForView:(UserInfo *)user;
@end
