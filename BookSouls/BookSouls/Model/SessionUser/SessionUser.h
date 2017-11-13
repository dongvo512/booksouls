//
//  SessionUser.h
//  hairista
//
//  Created by Dong Vo on 4/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import <JSONModel.h>

//@protocol UserInfo
//@end
@interface SessionUser : JSONModel
@property (nonatomic, strong) NSNumber <Optional> *status;
@property (nonatomic, strong) NSString <Optional> *token;
@property (nonatomic, strong) UserInfo <Optional> *profile;

@end
