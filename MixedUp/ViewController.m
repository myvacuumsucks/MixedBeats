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
@property (strong, nonatomic) NSArray *beatsArray;

@end

@implementation ViewController

//test
//test2
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NetworkController sharedInstance]requestOAuthAccess];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;

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


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  
  [[NetworkController sharedInstance] searchTerm:searchTerm completionHandler:^(NSError *error, NSMutableArray *beats) {
    self.beatsArray = beats;
    [self.tableView reloadData];
  }];
  
}



@end
