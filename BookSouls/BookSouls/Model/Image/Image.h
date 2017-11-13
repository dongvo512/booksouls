//
//  Image.h
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : JSONModel

@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSNumber <Optional> *active;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *path;
@property (nonatomic, strong) NSString <Optional> *url;

@end
