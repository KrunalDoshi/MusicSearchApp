//
//  ViewController.h
//  MusicSearch
//
//  Created by Krunal on 11/18/16.
//  Copyright © 2016 Virtusa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *trackList;

@end

