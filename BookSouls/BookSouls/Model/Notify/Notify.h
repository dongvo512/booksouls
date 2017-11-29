//
//  Notify.h
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notify : JSONModel

@property (nonatomic, strong) NSNumber <Optional> *formUser;
@property (nonatomic, strong) NSNumber <Optional> *toUserId;
@property (nonatomic, strong) NSNumber <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *type;
@property (nonatomic, strong) NSString <Optional> *content;
@property (nonatomic, strong) NSNumber <Optional> *isRead;
@property (nonatomic, strong) NSString <Optional> *updatedAt;
@property (nonatomic, strong) NSString <Optional> *shortContent;
@property (nonatomic, strong) NSString <Optional> *createdAt;
@property (nonatomic, strong) NSString <Optional> *title;
@end
