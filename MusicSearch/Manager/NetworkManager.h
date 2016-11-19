//
//  NetworkManager.h
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

/*
 This method fetch the data from the Server
 */
+ (void)fetchData:(NSURL*)url withCompletionHandler:(void (^)(NSData *data,NSError *error))completionHandler;

@end
