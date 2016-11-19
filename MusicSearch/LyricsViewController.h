//
//  LyricsViewController.h
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface LyricsViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *lblSongName;
@property (nonatomic,strong) IBOutlet UILabel *lblArtistName;
@property (nonatomic,strong) IBOutlet UILabel *lblAlbumName;
@property (nonatomic,strong) IBOutlet UITextView *lblSongLyrics;
@property (nonatomic,strong) IBOutlet UIImageView *imgAlbumImage;
@property (nonatomic,strong) Track *track;

@end
