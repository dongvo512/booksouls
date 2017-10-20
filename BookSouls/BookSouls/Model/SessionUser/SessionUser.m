//
//  SessionUser.m
//  hairista
//
//  Created by Dong Vo on 4/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SessionUser.h"

@implementation SessionUser

-(void)encodeWithCoder:(NSCoder *)encoder{

    [encoder encodeObject:self.idUser forKey:@"idUser"];
    
    [encoder encodeObject:self.name forKey:@"name"];
    
    [encoder encodeObject:self.name_slug forKey:@"name_slug"];
    
    [encoder encodeObject:self.avatarId forKey:@"avatarId"];
    
    [encoder encodeObject:self.wallpaperId forKey:@"wallpaperId"];
    
    [encoder encodeObject:self.email forKey:@"email"];
    
    [encoder encodeObject:self.phone forKey:@"phone"];
    
    [encoder encodeObject:self.status forKey:@"status"];
    
    [encoder encodeObject:self.phoneVerified forKey:@"phoneVerified"];
    
    [encoder encodeObject:self.homeAddress forKey:@"homeAddress"];
    
    [encoder encodeObject:self.lastAddress forKey:@"lastAddress"];
    
    [encoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    
    [encoder encodeObject:self.provider forKey:@"provider"];
    
    [encoder encodeObject:self.providerId forKey:@"providerId"];
    
    [encoder encodeObject:self.provider_reponse forKey:@"provider_reponse"];
    
    [encoder encodeObject:self.invitedBy forKey:@"invitedBy"];
    
    [encoder encodeObject:self.authToken forKey:@"authToken"];
    
    [encoder encodeObject:self.lastLat forKey:@"lastLat"];
    
    [encoder encodeObject:self.lastLng forKey:@"lastLng"];
    
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    
    [encoder encodeObject:self.city forKey:@"city"];
    
    [encoder encodeObject:self.about forKey:@"about"];
    
    [encoder encodeObject:self.avgRate forKey:@"avgRate"];
    
    [encoder encodeObject:self.totalComment forKey:@"totalComment"];
    
    [encoder encodeObject:self.totalRate forKey:@"totalRate"];
    
    [encoder encodeObject:self.totalPointRate forKey:@"totalPointRate"];
    
    [encoder encodeObject:self.role forKey:@"role"];
    
    [encoder encodeObject:self.isOnline forKey:@"isOnline"];
    
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    
    [encoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    
    [encoder encodeObject:self.wallpaper forKey:@"wallpaper"];
    
    [encoder encodeObject:self.token forKey:@"token"];
    
    [encoder encodeObject:self.openTime forKey:@"openTime"];
    
    [encoder encodeObject:self.closeTime forKey:@"closeTime"];
    
    [encoder encodeObject:self.district forKey:@"district"];

    [encoder encodeObject:self.province forKey:@"province"];

}

-(id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        
        self.idUser = [decoder decodeObjectForKey:@"idUser"];
        
        self.name = [decoder decodeObjectForKey:@"name"];
        
        self.name_slug = [decoder decodeObjectForKey:@"name_slug"];
        
        self.avatarId = [decoder decodeObjectForKey:@"avatarId"];
        
        self.avatarId = [decoder decodeObjectForKey:@"avatarId"];
        
        self.wallpaperId = [decoder decodeObjectForKey:@"wallpaperId"];
        
        self.email = [decoder decodeObjectForKey:@"email"];
        
        self.phone = [decoder decodeObjectForKey:@"phone"];
        
        self.status = [decoder decodeObjectForKey:@"status"];
        
        self.phoneVerified = [decoder decodeObjectForKey:@"phoneVerified"];
        
        self.homeAddress = [decoder decodeObjectForKey:@"homeAddress"];
        
        self.lastAddress = [decoder decodeObjectForKey:@"lastAddress"];
        
        self.inviteCode = [decoder decodeObjectForKey:@"inviteCode"];
        
        self.provider = [decoder decodeObjectForKey:@"provider"];
        
        self.provider_reponse = [decoder decodeObjectForKey:@"provider_reponse"];
        
        self.invitedBy = [decoder decodeObjectForKey:@"invitedBy"];
        
        self.authToken = [decoder decodeObjectForKey:@"authToken"];
        
        self.lastLat = [decoder decodeObjectForKey:@"lastLat"];
        
        self.lastLng = [decoder decodeObjectForKey:@"lastLng"];
        
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        
        self.city = [decoder decodeObjectForKey:@"city"];
        
        self.district = [decoder decodeObjectForKey:@"district"];
        
        self.province = [decoder decodeObjectForKey:@"province"];
        
        self.about = [decoder decodeObjectForKey:@"about"];
        
        self.avgRate = [decoder decodeObjectForKey:@"avgRate"];
        
        self.totalComment = [decoder decodeObjectForKey:@"totalComment"];
        
        self.totalRate = [decoder decodeObjectForKey:@"totalRate"];
        
        self.totalPointRate = [decoder decodeObjectForKey:@"totalPointRate"];
        
        self.role = [decoder decodeObjectForKey:@"role"];
        
        self.isOnline = [decoder decodeObjectForKey:@"isOnline"];
        
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        
        self.updatedAt = [decoder decodeObjectForKey:@"updatedAt"];
        
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        
        self.wallpaper = [decoder decodeObjectForKey:@"wallpaper"];
        
        self.token = [decoder decodeObjectForKey:@"token"];
        
        self.openTime = [decoder decodeObjectForKey:@"openTime"];
        
        self.closeTime = [decoder decodeObjectForKey:@"closeTime"];
        
    }
    return self;
}

@end
