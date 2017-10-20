//
//  CommonDefine.h
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define Appdelegate_hairista ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define _CM_IPAD @"IPAD"
#define _CM_IPAD_PRO @"IPAD PRO"
#define _CM_IPHONE_3_5_INCH     @"IPHONE 3.5 INCH"
#define _CM_IPHONE_4_INCH       @"IPHONE 4 INCH"
#define _CM_IPHONE_47_INCH      @"IPHONE 4.7 INCH"
#define _CM_IPHONE_55_INCH      @"IPHONE 5.5 INCH"

#define _CM_STRING_EMPTY @""

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define IPHONE   UIUserInterfaceIdiomPhone
#define SW ([[UIScreen mainScreen] bounds].size.width)
#define SH ([[UIScreen mainScreen] bounds].size.height)

#define CHECK_NIL(value) (value == [NSNull null]?@"":value)

#define IMG_DEFAULT [UIImage imageNamed:@"bg_default"]
#define IMG_USER_DEFAULT [UIImage imageNamed:@"ic_avatar"]

#endif /* CommonDefine_h */
