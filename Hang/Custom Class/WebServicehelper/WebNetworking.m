//
//  WebNetworking.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/18/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "WebNetworking.h"

@implementation WebNetworking

#pragma mark -

- (void)sendRequestWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName{
    
    session = [NSURLSession sharedSession];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    
    NSData *requestBody = [[self getJsonStringfromObject:parameater] dataUsingEncoding:NSUTF8StringEncoding];
    if (requestBody)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestBody];
    }
    
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [delegate webNetworkingSessionDidCompleteWithResult:[self getJsonObjectfromString:response] forRequest:requesrName];
            }
            else{
                [delegate webNetworkingSessionDidFailWithError:error forRequest:requesrName];
            }
        });
    }];
    
    [dataTask resume];
    
}

- (void)sendRequestWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName
                     extra:(id)extra{
    
    session = [NSURLSession sharedSession];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    
    NSData *requestBody = [[self getJsonStringfromObject:parameater] dataUsingEncoding:NSUTF8StringEncoding];
    if (requestBody)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestBody];
    }
    
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [delegate webNetworkingSessionDidCompleteWithResult:[self getJsonObjectfromString:response] forRequest:requesrName extra:extra];
            }
            else{
                [delegate webNetworkingSessionDidFailWithError:error forRequest:requesrName extra:extra];
            }
        });
    }];
    
    [dataTask resume];
    
}

- (void)uploadImageWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                 imageData:(NSData *)imageData
                 imageName:(NSString*)filename
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:strUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    
    if(imageData != nil)
    {
        NSString *UserId = [NSString stringWithFormat:@"%@", parameater[@"UserID"]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserID\"; filename=\"%@\"\r\n", UserId] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ProfileImage\"; filetype=\"image/jpg\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:imageData]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setHTTPBody:postbody];
    
    dataTask = [session uploadTaskWithRequest:request fromData:postbody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [delegate webNetworkingSessionDidCompleteWithResult:[self getJsonObjectfromString:response] forRequest:requesrName];
            }
            else{
                [delegate webNetworkingSessionDidFailWithError:error forRequest:requesrName];
            }
            
        });
        
    }];
    
    [dataTask resume];
    
}

- (void)stopRequest
{
    [dataTask suspend];
    [session invalidateAndCancel];
}

#pragma mark -

- (NSMutableData *)getHTTPBodyParamsFromDictionary :(NSDictionary *)params boundary:(NSString*)boundary
{
    NSMutableData *data = [NSMutableData data];
    
    for(NSString * key in params)
    {
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key,[params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return data;
}

- (id)getJsonObjectfromString:(NSString*)jsonString{
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:&error];
    return json;
}

- (NSString*)getJsonStringfromObject:(id)obj{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - WebNetworkingDelegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{
    
}
- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
    
}

@end
