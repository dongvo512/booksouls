//
//  Book.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "UserInfo.h"
#import "Image.h"

@protocol Image
@end

@interface Book : JSONModel

@property (nonatomic, strong) NSNumber <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *type;
@property (nonatomic, strong) NSString <Optional> *descriptionStr;
@property (nonatomic, strong) NSString <Optional> *description_slug;
@property (nonatomic, strong) NSString <Optional> *name_slug;
@property (nonatomic, strong) NSString <Optional> *author;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *isbn;
@property (nonatomic, strong) NSString <Optional> *nxb;
@property (nonatomic, strong) NSNumber <Optional> *lat;
@property (nonatomic, strong) NSNumber <Optional> *qty;
@property (nonatomic, strong) NSNumber <Optional> *lng;

@property (nonatomic, strong) NSString <Optional> *active;
@property (nonatomic, strong) NSNumber <Optional> *userId;


@property (nonatomic, strong) NSString <Optional> *meta;
@property (nonatomic, strong) NSNumber <Optional> *selled;
@property (nonatomic, strong) NSString <Optional> *subStatus;
@property (nonatomic, strong) NSString <Optional> *status;
@property (nonatomic, strong) NSNumber <Optional> *totalRate;
@property (nonatomic, strong) NSNumber <Optional> *pointRate;
@property (strong, nonatomic) NSMutableArray<Image,Optional> *images;

@property (nonatomic, strong) NSString <Optional> *rating;
@property (nonatomic, strong) UserInfo <Optional> *user;


@property (nonatomic, strong) NSNumber <Optional> *price;
@property (nonatomic, strong) NSString <Optional> *createdAt;
@property (nonatomic, strong) NSString <Optional> *updatedAt;
@property (nonatomic, strong) NSNumber <Optional> *priceDiscount;


@property (nonatomic, strong) NSNumber <Optional> *percentStatus;

@property (nonatomic, strong) NSString <Optional> *comments_count;

@property (nonatomic, strong) NSString <Optional> *categoryId;

@end
