//
//  APIRequestHandler.h
//  demo_Get_Data_API
//
//  Created by Dong Vo on 4/2/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequestHandler : NSObject

+ (void)initWithURLString:(NSString *)url withHttpMethod:(NSString *)httpMethod withRequestBody:(id)requestBody callApiResult:(CallAPIResult)callAPIResult;

+ (void)uploadImageWithURLString:(NSString *)url withHttpMethod:(NSString *)httpMethod withRequestBody:(id)requestBody uploadAPIResult:(UploadResult)uploadAPIResult;
@end
