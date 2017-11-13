//
//  UserInfo.h
//  BookSouls
//
//  Created by Dong Vo on 11/6/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>


@interface UserInfo : JSONModel

@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *name_slug;
@property (nonatomic, strong) NSString <Optional> *avatarId;
@property (nonatomic, strong) NSString <Optional> *wallpaperId;
@property (nonatomic, strong) NSString <Optional> *email;
@property (nonatomic, strong) NSString <Optional> *phone;
@property (nonatomic, strong) NSString <Optional> *status;
@property (nonatomic, strong) NSString <Optional> *phoneVerified;
@property (nonatomic, strong) NSString <Optional> *homeAddress;
@property (nonatomic, strong) NSString <Optional> *officeAddress;
@property (nonatomic, strong) NSString <Optional> *lastAddress;
@property (nonatomic, strong) NSString <Optional> *inviteCode;
@property (nonatomic, strong) NSString <Optional> *fbId;
@property (nonatomic, strong) NSString <Optional> *gId;
@property (nonatomic, strong) NSString <Optional> *invitedBy;
@property (nonatomic, strong) NSString <Optional> *authToken;
@property (nonatomic, strong) NSString <Optional> *lastLat;
@property (nonatomic, strong) NSString <Optional> *lastLng;
@property (nonatomic, strong) NSString <Optional> *totalRate;
@property (nonatomic, strong) NSString <Optional> *pointRate;
@property (nonatomic, strong) NSNumber <Optional> *totalSell;
@property (nonatomic, strong) NSNumber <Optional> *avgRating;
@property (nonatomic, strong) NSString <Optional> *openTime;
@property (nonatomic, strong) NSString <Optional> *role;
@property (nonatomic, strong) NSString <Optional> *isOnline;
@property (nonatomic, strong) NSString <Optional> *createdAt;
@property (nonatomic, strong) NSString <Optional> *updatedAt;
@property (nonatomic, strong) NSString <Optional> *avatar;
@property (nonatomic, strong) NSString <Optional> *wallpaper;

@end
