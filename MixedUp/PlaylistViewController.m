//
//  PlaylistViewController.m
//  MixedUp
//
//  Created by Brian Mendez on 12/16/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "PlaylistViewController.h"


@interface PlaylistViewController ()

- (IBAction)myPlaylistsButton:(id)sender;

@end

@implementation PlaylistViewController


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear: NO];
    //self.playlistToolbar.barTintColor = [UIColor blueColor];
  self.playlistToolbar.barStyle = UIBarStyleBlack;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.playlistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  Beat *beat = self.playlistArray[indexPath.row];
  cell.textLabel.text = beat.name;
  return cell;
}


- (IBAction)myPlaylistsButton:(id)sender {
  [[NetworkController sharedInstance]getMyUserID:^(NSError *error, NSString *userID) {
    NSLog(@"%@", userID);
  }];
  

  [[NetworkController sharedInstance] getMyPlaylists:([[NetworkController sharedInstance]user_ID]) completionHandler:^(NSError *error, NSDictionary *playlists) {
      self.playlistArray = playlists;
      [self.tableView reloadData];
  }];
}


@end
