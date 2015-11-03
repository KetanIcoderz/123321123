//
//  WebNetworking.h
//  Hang
//
//  Created by iCoderz_Ankit on 9/18/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebNetworkingDelegate;

@interface WebNetworking : NSObject
{
    NSURLSession *session;
    NSURLSessionDataTask *dataTask;
    id extraParameater;
}

- (void)sendRequestWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName;

- (void)sendRequestWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName
                     extra:(id)extra;

- (void)uploadImageWithUrl:(NSString*)strUrl
                parameater:(NSDictionary*)parameater
                 imageData:(NSData *)imageData
                 imageName:(NSString*)filename
                  delegate:(id <WebNetworkingDelegate>)delegate
           withRequestName:(NSString*)requesrName;

- (void)stopRequest;

@end


@protocol WebNetworkingDelegate

@optional

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName;
- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName;

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName extra:(id)extra;
- (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName extra:(id)extra;

/*

#pragma mark - WebNetworking Delegate

- (void)webNetworkingSessionDidCompleteWithResult:(NSDictionary*)result forRequest:(NSString*)requesrName{

[appDelegate hideActivity];

if ([requesrName isEqualToString:@""]) {

if ([result[@"Status"] isEqualToString:@"TRUE"]) {

}
else{

}

}
else{

if ([result[@"Status"] isEqualToString:@"TRUE"]) {

}
else{

}

}
}

 - (void)webNetworkingSessionDidFailWithError:(NSError*)error forRequest:(NSString*)requesrName{
 
 [appDelegate hideActivityWithError:error.localizedDescription];
 }

*/

@end