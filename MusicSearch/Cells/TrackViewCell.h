//
//  TrackViewCell.h
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblSongName;
@property (nonatomic,strong) IBOutlet UILabel *lblArtistName;
@property (nonatomic,strong) IBOutlet UILabel *lblAlbumName;
@property (nonatomic,strong) IBOutlet UIImageView *imgAlbumImage;

@end
