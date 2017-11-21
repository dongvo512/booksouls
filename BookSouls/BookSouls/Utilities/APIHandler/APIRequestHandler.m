//
//  APIRequestHandler.m
//  demo_Get_Data_API
//
//  Created by Dong Vo on 4/2/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "APIRequestHandler.h"

#import <AFNetworking/AFNetworking.h>


@interface APIRequestHandler ()
@end

@implementation APIRequestHandler

+ (void)initWithUrlStringXML:(NSString *)url withHttpMethod:(NSString *)httpMethod callApiResult:(CallAPIResult)callAPIResult{
    
    if(![Common checkForWIFIConnection]){
        
        callAPIResult(TRUE, @"Không thể kết nối với máy chủ \nVui lòng kiểm tra kết nối internet của bạn và thử lại.", nil);
        return;
        
    }
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"35dbcc27-ffed-a8e6-afc2-d39954ca12c7" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                   
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                        if (error) {
                                                            
                                                            callAPIResult(true,@"Không có dữ liệu",nil);
                                                            
                                                        } else {
                                                            
                                                            callAPIResult(false,nil,data);
                                                        }
                                                    });
                                                    
                                                }];
    [dataTask resume];
}

+ (void)initWithURLString:(NSString *)url withHttpMethod:(NSString *)httpMethod withRequestBody:(id)requestBody callApiResult:(CallAPIResult)callAPIResult
{
    
    if(![Common checkForWIFIConnection]){
    
        callAPIResult(TRUE, @"Không thể kết nối với máy chủ \nVui lòng kiểm tra kết nối internet của bạn và thử lại.", nil);
        return;

    }
    
    NSError *error = nil;
    NSData *jsonBody = nil;
    
    if (requestBody) {
        jsonBody = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&error];
    }

    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 60;
    
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:jsonBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@",Appdelegate_BookSouls.sesstionUser.token] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Bearer %@",Appdelegate_BookSouls.sesstionUser.token]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    NSURLSessionDataTask *dataTask;
    
     dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if(error){
        
            if(responseObject){
            
                id arrMsg = [responseObject objectForKey:@"msg"];
                
                if([arrMsg isKindOfClass:[NSArray class]]){
                
                    if([[arrMsg firstObject] length] > 0){
                        
                        callAPIResult(true,[arrMsg firstObject],nil);
                    }

                }
                else{
                
                    callAPIResult(true,arrMsg,nil);

                }
                
            }
            else{
            
                callAPIResult(true,error.localizedDescription,nil);
            }
        
        }
        else{
        
            callAPIResult(false,nil,responseObject);
        }
    }];
    
    [dataTask resume];
}

+ (void)uploadImageWithURLString:(NSString *)url filePath:(NSString *)filePath withHttpMethod:(NSString *)httpMethod uploadAPIResult:(UploadResult)uploadAPIResult{

    
    if(![Common checkForWIFIConnection]){
        
        uploadAPIResult(TRUE, @"Không thể kết nối với máy chủ \nVui lòng kiểm tra kết nối internet của bạn và thử lại.", nil, nil);
        return;
        
    }
    
    
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"authorization": [NSString stringWithFormat:@"Bearer %@",Appdelegate_BookSouls.sesstionUser.token],
                              };
    //NSArray *parameters = @[ @{ @"name": @"images", @"fileName": filePath } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    //NSError *error;
    //NSMutableString *body = [NSMutableString string];
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"images\"; filename=\"%@.jpg\"\r\n", @"newfile"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithContentsOfFile:filePath]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:httpMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSURLSessionUploadTask *uploadTask;

    uploadTask =  [manager
                   uploadTaskWithStreamedRequest:request
                   progress:^(NSProgress * _Nonnull uploadProgress) {

                       dispatch_async(dispatch_get_main_queue(), ^{

                           uploadAPIResult(false, @"", nil, uploadProgress);
                       });
                   }
                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

                       if (error) {
                          
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if(responseObject){
                                   
                                   id arrMsg = [responseObject objectForKey:@"msg"];
                                   
                                   if([arrMsg isKindOfClass:[NSArray class]]){
                                       
                                       if([[arrMsg firstObject] length] > 0){
                                           
                                           uploadAPIResult(true,[arrMsg firstObject],nil,nil);
                                       }
                                       
                                   }
                                   else{
                                       
                                       uploadAPIResult(true,arrMsg,nil,nil);
                                       
                                   }
                                   
                               }
                           });
                           
                       }
                       else{
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                                uploadAPIResult(false,nil,responseObject,nil);
                           });
                          

                       }
                   }];

    [uploadTask resume];
}

@end
