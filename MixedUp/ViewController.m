//
//  ViewController.m
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) PlaylistViewController *playlistVC;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NetworkController sharedInstance]requestOAuthAccess];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;

    self.playlistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PLAYLIST_VC"];
    [self addChildViewController:self.playlistVC];
    [self.playlistVC didMoveToParentViewController:self];
    self.playlistVC.playlistArray = [[NSMutableArray alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return self.beatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  Beat *beat = self.beatsArray[indexPath.row];
  cell.textLabel.text = beat.name;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Beat *beat = self.beatsArray[indexPath.row];
    [self.playlistVC.playlistArray addObject:beat];
//    NSLog(@"test test: %@", playlistVC.playlistArray.count);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  
  [[NetworkController sharedInstance] searchTerm:searchTerm completionHandler:^(NSError *error, NSMutableArray *beats) {
    self.beatsArray = beats;
    [self.tableView reloadData];
  }];
  
}

@end
