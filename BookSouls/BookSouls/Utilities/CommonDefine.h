//
//  CommonDefine.h
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

typedef void (^CallAPIResult)(BOOL isError, NSString *stringError, id responseDataObject);
typedef void (^UploadResult)(BOOL isError, NSString *stringError, id responseDataObject, NSProgress *progress);

#define Appdelegate_BookSouls ((AppDelegate *)[[UIApplication sharedApplication] delegate])


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

// Api Define

#define kHTTP_METHOD_POST   @"POST"
#define kHTTP_METHOD_GET    @"GET"

#define URL_DEFAULT @"http://203.162.76.2/book/api/v1/"
#define URL_GOODREADS_SEARCH @"https://www.goodreads.com/search/index.xml?key=Kqv88ydGACMTdTY1KqEkA&q="
#define LIMIT_ITEM 10

/////////// GET
#define GET_BOOK_NEW @"books"

#define GET_BOOK_NEARLY @"books/nearly"

#define GET_BOOK_POPULAR @"booksPopular"

#define GET_BOOK_CATEGORIES @"categories"

#define GET_BEST_SELLER @"bestSellers"

#define GET_LIST_BOOK_RELATED @"posts"

////////// POST

#define ORDER_BOOK @"booking"

#define UPLOAD_IMAGE @"images"

#define POST_REGISTER @"register"

#define POST_LOGIN @"login"

#define POST_LOGIN_FB @"loginFb"

#define POST_LOGIN_GOOGLE @"loginGL"

#define POST_CREATE_BOOK @"posts/create"



#endif /* CommonDefine_h */
