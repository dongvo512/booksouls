//
//  UserInfo.m
//  BookSouls
//
//  Created by Dong Vo on 11/6/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.name_slug forKey:@"name_slug"];
    [encoder encodeObject:self.avatarId forKey:@"avatarId"];
    [encoder encodeObject:self.wallpaperId forKey:@"wallpaperId"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.phoneVerified forKey:@"phoneVerified"];
    [encoder encodeObject:self.homeAddress forKey:@"homeAddress"];
    [encoder encodeObject:self.officeAddress forKey:@"officeAddress"];
    [encoder encodeObject:self.lastAddress forKey:@"lastAddress"];
    [encoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    [encoder encodeObject:self.fbId forKey:@"fbId"];
    [encoder encodeObject:self.gId forKey:@"gId"];
    [encoder encodeObject:self.invitedBy forKey:@"invitedBy"];
    [encoder encodeObject:self.authToken forKey:@"authToken"];
    [encoder encodeObject:self.lastLat forKey:@"lastLat"];
    [encoder encodeObject:self.lastLng forKey:@"lastLng"];
    [encoder encodeObject:self.totalRate forKey:@"totalRate"];
    [encoder encodeObject:self.pointRate forKey:@"pointRate"];
    [encoder encodeObject:self.totalSell forKey:@"totalSell"];
    [encoder encodeObject:self.avgRating forKey:@"avgRating"];
    [encoder encodeObject:self.openTime forKey:@"openTime"];
    [encoder encodeObject:self.openTime forKey:@"role"];
    [encoder encodeObject:self.openTime forKey:@"createdAt"];
    [encoder encodeObject:self.openTime forKey:@"avatar"];
    [encoder encodeObject:self.openTime forKey:@"wallpaper"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.name_slug = [decoder decodeObjectForKey:@"name_slug"];
        self.avatarId = [decoder decodeObjectForKey:@"avatarId"];
        self.wallpaperId = [decoder decodeObjectForKey:@"wallpaperId"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.phoneVerified = [decoder decodeObjectForKey:@"phoneVerified"];
        self.homeAddress = [decoder decodeObjectForKey:@"homeAddress"];
        self.officeAddress = [decoder decodeObjectForKey:@"officeAddress"];
        self.lastAddress = [decoder decodeObjectForKey:@"lastAddress"];
        self.inviteCode = [decoder decodeObjectForKey:@"inviteCode"];
        self.fbId = [decoder decodeObjectForKey:@"fbId"];
        self.gId = [decoder decodeObjectForKey:@"gId"];
        self.invitedBy = [decoder decodeObjectForKey:@"invitedBy"];
        self.authToken = [decoder decodeObjectForKey:@"authToken"];
        self.lastLat = [decoder decodeObjectForKey:@"lastLat"];
        self.lastLng = [decoder decodeObjectForKey:@"lastLng"];
        self.totalRate = [decoder decodeObjectForKey:@"totalRate"];
        self.pointRate = [decoder decodeObjectForKey:@"pointRate"];
        self.totalSell = [decoder decodeObjectForKey:@"totalSell"];
        self.avgRating = [decoder decodeObjectForKey:@"avgRating"];
        self.openTime = [decoder decodeObjectForKey:@"openTime"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.wallpaper = [decoder decodeObjectForKey:@"wallpaper"];
    }
    
    return self;
}

@end
