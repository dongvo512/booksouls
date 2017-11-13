//
//  SessionUser.m
//  hairista
//
//  Created by Dong Vo on 4/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SessionUser.h"

@implementation SessionUser

- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.profile forKey:@"profile"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        
        self.status = [decoder decodeObjectForKey:@"status"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.profile = [decoder decodeObjectForKey:@"profile"];
    }
    
    return self;
}

@end

