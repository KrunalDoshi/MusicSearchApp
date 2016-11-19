//
//  ViewController.m
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import "ViewController.h"
#import "Track.h"
#import "TrackViewCell.h"
#import "LyricsViewController.h"
#import "Define.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.trackList = [[NSMutableArray alloc] init];
    
    //Title and Font
    self.title = @"Music Search";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:appFont size:appFontTitleSize]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView DataSource Mehotds

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trackList count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    TrackViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TrakCellIdentifier];
    Track *track = [self.trackList objectAtIndex:indexPath.row];
    cell.lblSongName.text = track.songName;
    cell.lblAlbumName.text = track.albumName;
    cell.lblArtistName.text = track.artistName;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: track.albumImage]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            cell.imgAlbumImage.image = [UIImage imageWithData: data];
        });
    });
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark Tableview Delegate Methods

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    Track *track = [self.trackList objectAtIndex:indexPath.row];
    LyricsViewController *lyricsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LyricsViewController"];
    lyricsViewController.track = track;
    [self.navigationController pushViewController:lyricsViewController animated:YES];
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSCharacterSet *allowedCharaterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *searchTerm = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:allowedCharaterSet];
    [Track getTracks:searchTerm withCompletionHandler:^(NSMutableArray *trackList,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error == nil) {
                self.trackList = trackList;
                [self.tableView reloadData];
            }
            else {
                UIAlertController *alerController = [UIAlertController alertControllerWithTitle:ConnectionError message:ConnectionErrorMessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alerController addAction:okAction];
                [self presentViewController:alerController animated:YES completion:nil];
            }
        });
    }];
}

@end
