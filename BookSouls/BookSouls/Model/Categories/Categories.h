//
//  Categories.h
//  BookSouls
//
//  Created by Dong Vo on 11/8/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : JSONModel

@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSNumber <Optional> *slug;
@property (nonatomic, strong) NSString <Optional> *isShow;
@property (nonatomic, strong) NSString <Optional> *createdAt;
@property (nonatomic, strong) NSString <Optional> *updatedAt;
@property (nonatomic, strong) NSString <Optional> *image;
@property (nonatomic, strong) NSString <Optional> *imagePath;
@property (nonatomic, strong) NSString <Optional> *imageurl;

@end
