//
//  Order.h
//  BookSouls
//
//  Created by Dong Vo on 11/28/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Book,UserInfo;

@interface Order : JSONModel

@property (nonatomic, strong) NSNumber <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *discount;
@property (nonatomic, strong) NSNumber <Optional> *buyerId;
@property (nonatomic, strong) NSNumber <Optional> *sellerId;
@property (nonatomic, strong) NSNumber <Optional> *amount;
@property (nonatomic, strong) Book <Optional> *book;
@property (nonatomic, strong) NSNumber <Optional> *action_userId;
@property (nonatomic, strong) UserInfo <Optional> *buyer;
@property (nonatomic, strong) NSNumber <Optional> *price;
@property (nonatomic, strong) NSNumber <Optional> *qty;
@property (nonatomic, strong) NSNumber <Optional> *postId;
@property (nonatomic, strong) NSString <Optional> *createdAt;
@property (nonatomic, strong) NSString <Optional> *descriptionStr;
@property (nonatomic, strong) NSString <Optional> *status;
@property (nonatomic, strong) UserInfo <Optional> *seller;

@end
