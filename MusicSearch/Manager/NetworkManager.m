//
//  NetworkManager.m
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"

@implementation NetworkManager

+ (void)fetchData:(NSURL*)url withCompletionHandler:(void (^)(NSData *data,NSError *error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    //Check for Internet Connection
    if([NetworkManager checkForInternetConnection]) {
    
        // Create a data task object to perform the data downloading.
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil) {
                // If any error occurs then just display its description on the console.
                NSLog(@"%@", [error localizedDescription]);
                completionHandler(nil,error);
            }
            else{
                // If no error occurs, check the HTTP status code.
                NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                
                // If it's other than 200, then show it on the console.
                if (HTTPStatusCode != 200) {
                    NSLog(@"HTTP status code = %ld", HTTPStatusCode);
                }
                
                // Call the completion handler with the returned data on the main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(data,nil);
                });
            }
        }];
        
        // Resume the task.
        [task resume];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
        completionHandler(nil,error);
    }
    
}

#pragma mark -
#pragma mark Reachability

+ (BOOL)checkForInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {
        return NO;
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        return YES;
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
