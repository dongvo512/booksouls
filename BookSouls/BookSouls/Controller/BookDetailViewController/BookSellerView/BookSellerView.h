//
//  BookSellerView.h
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;

@interface BookSellerView : UICollectionReusableView

- (void)setDataForView:(UserInfo *)user;
@property (nonatomic, weak) id delegate;

@end

@protocol BookSellerViewDelegate <NSObject>
- (void)touchCall;
- (void)touchSMS;
- (void)selectedSellerInfo:(UserInfo *)seller;
@end
