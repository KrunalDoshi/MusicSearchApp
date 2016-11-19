//
//  LyricsViewController.m
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "LyricsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Define.h"

@interface LyricsViewController ()

@end

@implementation LyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotLyrics:) name:GotLyricsNotification object:nil];

    self.lblSongLyrics.layer.cornerRadius = 10;
    self.lblSongLyrics.layer.borderWidth = 3.0;
    self.lblSongLyrics.layer.borderColor = [[UIColor colorWithRed:26/255 green:73/255 blue:106/255 alpha:1.0] CGColor];
    
    self.title = @"Lyrics";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:appFont size:appFontTitleSize]}];
}

- (void)viewWillAppear:(BOOL)animated {
    self.lblSongName.text = self.track.songName;
    self.lblAlbumName.text = self.track.albumName;
    self.lblArtistName.text = self.track.artistName;
    
    //Loading the album image asynchronsuly
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.track.albumImage]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.imgAlbumImage.image = [UIImage imageWithData: data];
        });
    });

    //Fetching the track lyrics and handling the error if any
    [self.track fetchLyrics:self.track withErrorHandler:^(NSError *error) {
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:ConnectionError message:ConnectionErrorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alerController addAction:okAction];
        [self presentViewController:alerController animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Custom Methods

/*
 Method updates the lyrics in text view once we get the lyrics from the API
 */
- (void)gotLyrics:(NSNotification*)notificationObject {
    NSDictionary *dictionary = notificationObject.object;
    self.lblSongLyrics.text = [dictionary valueForKey:@"lyrics"];
}

@end
