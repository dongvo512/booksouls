//
//  SellerView.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;

@interface SellerView : UICollectionReusableView

- (void)setDataForView:(NSMutableArray *)arrCategories;
@property (nonatomic, weak) id delegate;
@end
@protocol SellerViewDelegate <NSObject>

- (void)selectedReadMore;
- (void)selectedItemSeller:(UserInfo *)user;

@end
