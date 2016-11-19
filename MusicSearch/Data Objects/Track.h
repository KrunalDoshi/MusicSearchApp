//
//  Track.h
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject <NSXMLParserDelegate>

@property (nonatomic,strong) NSString *songName;
@property (nonatomic,strong) NSString *artistName;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) NSString *albumImage;


+ (void)getTracks:(NSString*)searchTerm withCompletionHandler:(void (^)(NSMutableArray * trackList,NSError *error))completionHandler;
- (void)fetchLyrics:(Track*)track withErrorHandler:(void (^)(NSError *error))errorHandler;
@end
