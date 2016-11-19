//
//  Track.m
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "Track.h"
#import "NetworkManager.h"
#import "Define.h"

@interface Track()
@property (nonatomic,strong) NSMutableDictionary *lyricsDictionary;
@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) NSMutableString *foundValue;

@property (nonatomic, strong) NSString *currentElement;
@end

@implementation Track

+ (void)getTracks:(NSString*)searchTerm withCompletionHandler:(void (^)(NSMutableArray *trackList, NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",trackSearchURL,searchTerm];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    [NetworkManager fetchData:requestURL withCompletionHandler:^(NSData *data, NSError *error) {
        if(error == nil) {
            //Creating the Dictionary from the JSON object
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //Fetch the results
            NSArray *results = [dict valueForKey:@"results"];
            //Initialize TrackList Arrau
            NSMutableArray *trackList = [[NSMutableArray alloc] init];
            //Iterate through the list, create Track objects and add to the tracklist
            for (NSDictionary *trackDictionary in results) {
                Track *track = [[Track alloc] init];
                track.songName = [trackDictionary valueForKey:@"trackName"];
                track.albumName = [trackDictionary valueForKey:@"collectionName"];
                track.artistName = [trackDictionary valueForKey:@"artistName"];
                track.albumImage = [trackDictionary valueForKey:@"artworkUrl100"];
                [trackList addObject:track];
            }
            completionHandler(trackList,nil);
        }
        else {
            completionHandler(nil,error);
        }
    }];
}

- (void)fetchLyrics:(Track*)track withErrorHandler:(void (^)(NSError *error))errorHandler {
    NSString *urlString = [NSString stringWithFormat:lyricsURL,track.artistName,track.songName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    __weak Track *weakSelf = self;
    [NetworkManager fetchData:requestURL withCompletionHandler:^(NSData *data, NSError *error) {
        //This is done by xml parsing as this api does not return the correct json format in the response.
        if(data != nil) {
            weakSelf.xmlParser = [[NSXMLParser alloc] initWithData:data];
            weakSelf.xmlParser.delegate = self;
            // Initialize the mutable string that we'll use during parsing.
            weakSelf.foundValue = [[NSMutableString alloc] init];
            // Start parsing.
            [weakSelf.xmlParser parse];
        }
        else {
            errorHandler(error);
        }
    }];

}

#pragma mark - NSXMLParserDelegate method implementation

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize
    
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // parsing completed
    NSLog(@"%@",self.lyricsDictionary);
    [[NSNotificationCenter defaultCenter] postNotificationName:GotLyricsNotification object:self.lyricsDictionary];
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    // If the current element name is equal to "LyricsResult" then initialize the lyrics dictionary.
    if ([elementName isEqualToString:@"LyricsResult"]) {
        self.lyricsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    // Keep the current element.
    self.currentElement = elementName;
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"lyrics"]){
        // If the lyrics element was found then store it.
        [self.lyricsDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"lyrics"];
    }
    else if ([elementName isEqualToString:@"url"]){
        // If the url name element was found then store it.
        [self.lyricsDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"url"];
    }
    
    // Clear the mutable string.
    [self.foundValue setString:@""];
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if ([self.currentElement isEqualToString:@"lyrics"] ||
        [self.currentElement isEqualToString:@"url"]) {
        
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}


@end
